import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/providers/categories_provider.dart';
import 'package:shopping_list/providers/grocery_Items_provider.dart';
import 'package:shopping_list/screens/groceries.dart';

class NewItemForm extends ConsumerStatefulWidget {
  const NewItemForm({super.key});

  @override
  ConsumerState<NewItemForm> createState() => _NewItemFormState();
}

class _NewItemFormState extends ConsumerState<NewItemForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  Categories selectedCategory = Categories.vegetables;
  var enteredName = '';
  var enteredQuantity = '';

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);
    final formKey = GlobalKey<FormState>();
    return Form(
      key: formKey,
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        } else {
          if (_nameController.text == "" &&
              _quantityController.text == "" &&
              selectedCategory == null) {
            Navigator.of(context).pop();
            return;
          }
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Do you want to close form?"),
              content: Text(
                "If you proceed to close the form, you will lose all information",
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Keep Editing"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => Groceries()),
                          (route) => false,
                        );
                      },
                      child: Text("close form"),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            maxLength: 50,
            decoration: const InputDecoration(label: Text("Name")),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Please enter a name.";
              }

              if (value.trim().length < 2) {
                return "Name must be at least 2 characters.";
              }

              if (value.trim().length > 50) {
                return "Name cannot exceed 50 characters.";
              }
              if (int.tryParse(value.trim()) != null) {
                return "Name cannot be a number";
              }

              return null;
            },
            onSaved: (newValue) {
              enteredName = newValue!;
            },
          ),

          const SizedBox(height: 20),

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextFormField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(label: Text("Quantity")),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter a quantity.";
                    }

                    final quantity = int.tryParse(value.trim());

                    if (quantity == null) {
                      return "Please enter a valid number.";
                    }

                    if (quantity <= 0) {
                      return "Quantity must be greater than 0.";
                    }

                    return null;
                  },
                  onSaved: (newValue) {
                    enteredQuantity = newValue!;
                  },
                ),
              ),

              const SizedBox(width: 20),

              Expanded(
                child: DropdownButtonFormField<Categories>(
                  initialValue: selectedCategory,
                  decoration: const InputDecoration(label: Text("Category")),
                  items: [
                    for (final category in categories.entries)
                      DropdownMenuItem(
                        value: category.key,
                        child: Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: category.value.color,
                              ),
                            ),
                            const SizedBox(width: 7),
                            Text(category.value.title),
                          ],
                        ),
                      ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  formKey.currentState!.reset();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.onSecondary,
                ),
                child: Text("Reset"),
              ),
              ElevatedButton(
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.onSecondary,
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    final groceries = ref.watch(groceryItemsProvider);
                    var newId = groceries.length + 1;
                    var newGroceryItem = GroceryItem(
                      id: newId.toString(),
                      name: enteredName,
                      quantity: int.tryParse(enteredQuantity)!,
                      category: categories[selectedCategory]!,
                    );
                    ref
                        .read(groceryItemsProvider.notifier)
                        .updateGroceryItem(newGroceryItem, ref);
                    Navigator.of(context).pop();
                    return;
                  }
                  if (enteredName == "" || enteredQuantity == "") {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Finish filling out the form!")),
                    );
                    return;
                  }
                },
                child: Text("Add Item"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
