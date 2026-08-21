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
  Categories? selectedCategory;

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);
    return Form(
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
            decoration: InputDecoration(label: Text("Name")),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return "You can't leave it empty";
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _quantityController,
                  decoration: InputDecoration(label: Text("Quantity")),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: DropdownButtonFormField<Categories>(
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
                            SizedBox(width: 7),
                            Text(category.value.title),
                          ],
                        ),
                      ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.onSecondary,
              padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
            ),
            onPressed: () {
              final groceries = ref.watch(groceryItemsProvider);
              var newId = groceries.length + 1;
              var newGroceryItem = GroceryItem(
                id: newId.toString(),
                name: _nameController.text,
                quantity: int.parse(_quantityController.text),
                category: categories[selectedCategory]!,
              );
              ref
                  .read(groceryItemsProvider.notifier)
                  .updateGroceryItem(newGroceryItem, ref);
              Navigator.of(context).pop();
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }
}
