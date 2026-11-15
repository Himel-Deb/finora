import 'package:finora/feature/categories/data/models/category_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CategoryBox {
  static const String boxName = 'categories';

  static Future<Box<CategoryModel>> openBox() async {
    return await Hive.openBox<CategoryModel>(boxName);
  }

  static Future<void> saveCategory(CategoryModel category) async {
    final box = await openBox();
    await box.put(category.id, category);
  }

  static Future<CategoryModel?> getCategory(String id) async {
    final box = await openBox();
    return box.get(id);
  }

  static Future<List<CategoryModel>> getAllCategories() async {
    final box = await openBox();
    return box.values.toList();
  }

  static Future<void> deleteCategory(String id) async {
    final box = await openBox();
    await box.delete(id);
  }
}