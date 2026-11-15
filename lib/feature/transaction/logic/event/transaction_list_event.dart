import 'package:equatable/equatable.dart';
import 'package:finora/feature/transaction/data/models/transaction_model.dart';

abstract class TransactionListEvent extends Equatable {
  const TransactionListEvent();

  @override
  List<Object?> get props => [];
}

class LoadTransactions extends TransactionListEvent {
  const LoadTransactions();
}

class DeleteTransaction extends TransactionListEvent {
  final String transactionId;

  const DeleteTransaction(this.transactionId);

  @override
  List<Object?> get props => [transactionId];
}


class UpdateTransaction extends TransactionListEvent {
  final TransactionModel transaction;

  const UpdateTransaction(this.transaction);

  @override
  List<Object?> get props => [transaction];
}