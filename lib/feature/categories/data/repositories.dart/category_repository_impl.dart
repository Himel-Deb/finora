import 'package:finora/data/local/hive/category_box.dart';
import 'package:finora/feature/categories/data/models/category_model.dart';
import 'package:finora/feature/categories/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  @override
  Future<void> addCategory(CategoryModel category) async {
    await CategoryBox.saveCategory(category);
  }

  @override
  Future<CategoryModel?> getCategory(String id) async {
    return await CategoryBox.getCategory(id);
  }

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    return await CategoryBox.getAllCategories();
  }

  @override
  Future<void> deleteCategory(String id) async {
    await CategoryBox.deleteCategory(id);
  }
}