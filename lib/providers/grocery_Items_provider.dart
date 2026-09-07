import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shopping_list/models/grocery_item.dart';

class GroceryItemNotifier extends StateNotifier<List<GroceryItem>> {
  GroceryItemNotifier() : super([]);

  void updateGroceryItem(GroceryItem newGroceryItem, WidgetRef ref) {
    state = [...state, newGroceryItem];
  }

  void deleteGroceryItem(GroceryItem groceryItem) {
    state.remove(groceryItem);
    state = [...state];
  }
}

final groceryItemsProvider =
    StateNotifierProvider<GroceryItemNotifier, List<GroceryItem>>((ref) {
      return GroceryItemNotifier();
    });
