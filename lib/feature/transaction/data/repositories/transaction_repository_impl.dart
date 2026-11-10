import 'package:finora/data/local/hive/transactions_box.dart';
import 'package:finora/feature/transaction/data/models/transaction_model.dart';
import 'package:finora/feature/transaction/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    await TransactionBox.saveTransaction(transaction);
  }

  @override
  Future<TransactionModel?> getTransaction(String id) async {
    return await TransactionBox.getTransaction(id);
  }

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    return await TransactionBox.getAllTransactions();
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await TransactionBox.deleteTransaction(id);
  }
}