import 'package:equatable/equatable.dart';
import 'package:finora/feature/transaction/data/models/transaction_model.dart';

enum TransactionListStatus {
  initial,
  loading,
  success,
  failure,
}

class TransactionListState extends Equatable {
  final TransactionListStatus status;
  final List<TransactionModel> transactions;
  final String? errorMessage;

  const TransactionListState({
    this.status = TransactionListStatus.initial,
    this.transactions = const [],
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        status,
        transactions,
        errorMessage,
      ];
}