import 'package:finora/feature/categories/data/models/category_model.dart';
import 'package:finora/feature/categories/data/repositories.dart/category_repository_impl.dart';

class DefaultCategories {
  static Future<void> initialize() async {
    final repository = CategoryRepositoryImpl();

    final existingCategories = await repository.getAllCategories();

    if (existingCategories.isNotEmpty) return;

    final categories = [
      const CategoryModel(
        id: 'food',
        name: 'Food',
        icon: 'restaurant',
        isIncome: false,
      ),
      const CategoryModel(
        id: 'transport',
        name: 'Transport',
        icon: 'directions_bus',
        isIncome: false,
      ),
      const CategoryModel(
        id: 'shopping',
        name: 'Shopping',
        icon: 'shopping_bag',
        isIncome: false,
      ),
      const CategoryModel(
        id: 'bills',
        name: 'Bills',
        icon: 'receipt',
        isIncome: false,
      ),
      const CategoryModel(
        id: 'salary',
        name: 'Salary',
        icon: 'account_balance_wallet',
        isIncome: true,
      ),
      const CategoryModel(
        id: 'business',
        name: 'Business',
        icon: 'business',
        isIncome: true,
      ),
      const CategoryModel(
        id: 'other',
        name: 'Other',
        icon: 'category',
        isIncome: false,
      ),
    ];

    for (final category in categories) {
      await repository.addCategory(category);
    }
  }
}