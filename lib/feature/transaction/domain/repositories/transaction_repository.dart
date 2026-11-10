
import '../../data/models/transaction_model.dart';

abstract class TransactionRepository {
  Future<void> addTransaction(TransactionModel transaction);

  Future<TransactionModel?> getTransaction(String id);

  Future<List<TransactionModel>> getAllTransactions();

  Future<void> deleteTransaction(String id);
}
