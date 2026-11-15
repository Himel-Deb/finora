
import 'package:finora/feature/budgets/data/models/budget_model.dart';
import 'package:hive/hive.dart';

class BudgetBox {
  static const String boxName = 'budgets';

  static Future<Box<BudgetModel>> openBox() async {
    return await Hive.openBox<BudgetModel>(boxName);
  }

  static Future<void> saveBudget(BudgetModel budget) async {
    final box = await openBox();
    await box.put(budget.id, budget);
  }

  static Future<BudgetModel?> getBudget(String id) async {
    final box = await openBox();
    return box.get(id);
  }

  static Future<List<BudgetModel>> getAllBudgets() async {
    final box = await openBox();
    return box.values.toList();
  }

  static Future<void> deleteBudget(String id) async {
    final box = await openBox();
    await box.delete(id);
  }
}
