import 'package:finora/feature/categories/data/models/category_model.dart';

abstract class CategoryRepository {
  Future<void> addCategory(CategoryModel category);

  Future<CategoryModel?> getCategory(String id);

  Future<List<CategoryModel>> getAllCategories();

  Future<void> deleteCategory(String id);
}