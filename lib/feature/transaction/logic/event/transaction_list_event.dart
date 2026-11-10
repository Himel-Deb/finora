import 'package:equatable/equatable.dart';

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