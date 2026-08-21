import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_list/data/categories.dart';

final categoriesProvider = Provider((ref) {
  return categories;
});
