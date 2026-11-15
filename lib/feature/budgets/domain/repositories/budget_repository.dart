import 'package:finora/feature/budgets/data/models/budget_model.dart';

abstract class BudgetRepository {
  Future<void> addBudget(BudgetModel budget);

  Future<BudgetModel?> getBudget(String id);

  Future<List<BudgetModel>> getAllBudgets();

  Future<void> deleteBudget(String id);
}