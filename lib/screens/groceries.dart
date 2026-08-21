import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shopping_list/providers/grocery_Items_provider.dart';
import 'package:shopping_list/screens/new_item.dart';

class Groceries extends ConsumerStatefulWidget {
  const Groceries({super.key});

  @override
  ConsumerState<Groceries> createState() => _GroceriesState();
}

class _GroceriesState extends ConsumerState<Groceries> {
  void _addItem() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => NewItem()));
  }

  @override
  Widget build(BuildContext context) {
    final groceryItems = ref.watch(groceryItemsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Groceries"),
        centerTitle: false,
        actions: [IconButton(onPressed: _addItem, icon: Icon(Icons.add))],
      ),

      body: ListView.builder(
        itemCount: groceryItems.length,
        padding: EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return ListTile(
            leading: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: groceryItems[index].category.color,
              ),
            ),

            title: Text(
              groceryItems[index].name,
              style: Theme.of(context).textTheme.bodyLarge,
            ),

            trailing: Text(
              groceryItems[index].quantity.toString(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        },
      ),
    );
  }
}
