import 'package:finora/feature/transaction/data/models/transaction_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TransactionBox {
  static const String boxName = 'transactions';

  static Future<Box<TransactionModel>> openBox() async {
    return await Hive.openBox<TransactionModel>(boxName);
  }

  static Future<void> saveTransaction(TransactionModel transaction) async {
    final box = await openBox();
    await box.put(transaction.id, transaction);
  }

  static Future<TransactionModel?> getTransaction(String id) async {
    final box = await openBox();
    return box.get(id);
  }

  static Future<List<TransactionModel>> getAllTransactions() async {
    final box = await openBox();
    return box.values.toList();
  }

  static Future<void> deleteTransaction(String id) async {
    final box = await openBox();
    await box.delete(id);
  }
}