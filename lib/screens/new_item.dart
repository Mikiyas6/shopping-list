import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_list/widgets/new_item_form.dart';

class NewItem extends ConsumerStatefulWidget {
  const NewItem({super.key});

  @override
  ConsumerState<NewItem> createState() => _NewItemState();
}

class _NewItemState extends ConsumerState<NewItem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add a new Item"), centerTitle: false),
      body: Padding(padding: const EdgeInsets.all(12.0), child: NewItemForm()),
    );
  }
}
