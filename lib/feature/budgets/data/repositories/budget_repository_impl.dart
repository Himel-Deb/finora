import 'package:finora/data/local/hive/budget_box.dart';
import 'package:finora/feature/budgets/data/models/budget_model.dart';
import 'package:finora/feature/budgets/domain/repositories/budget_repository.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  @override
  Future<void> addBudget(BudgetModel budget) async {
    await BudgetBox.saveBudget(budget);
  }

  @override
  Future<BudgetModel?> getBudget(String id) async {
    return await BudgetBox.getBudget(id);
  }

  @override
  Future<List<BudgetModel>> getAllBudgets() async {
    return await BudgetBox.getAllBudgets();
  }

  @override
  Future<void> deleteBudget(String id) async {
    await BudgetBox.deleteBudget(id);
  }
}