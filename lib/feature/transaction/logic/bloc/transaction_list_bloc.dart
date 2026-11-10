import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:finora/feature/transaction/logic/event/transaction_list_event.dart';
import 'package:finora/feature/transaction/logic/states/transaction_list_state.dart';
import 'package:finora/feature/transaction/data/repositories/transaction_repository_impl.dart';

class TransactionListBloc
    extends Bloc<TransactionListEvent, TransactionListState> {
  final TransactionRepositoryImpl repository;

  TransactionListBloc(this.repository)
      : super(const TransactionListState()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<DeleteTransaction>(_onDeleteTransaction);
  }

  Future<void> _onLoadTransactions(
    LoadTransactions event,
    Emitter<TransactionListState> emit,
  ) async {
    emit(
      const TransactionListState(
        status: TransactionListStatus.loading,
      ),
    );

    try {
      final transactions = await repository.getAllTransactions();

      emit(
        TransactionListState(
          status: TransactionListStatus.success,
          transactions: transactions,
        ),
      );
    } catch (e) {
      emit(
        TransactionListState(
          status: TransactionListStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onDeleteTransaction(
    DeleteTransaction event,
    Emitter<TransactionListState> emit,
  ) async {
    try {
      await repository.deleteTransaction(event.transactionId);

      final updatedTransactions = state.transactions
          .where((item) => item.id != event.transactionId)
          .toList();

      emit(
        TransactionListState(
          status: TransactionListStatus.success,
          transactions: updatedTransactions,
        ),
      );
    } catch (e) {
      emit(
        TransactionListState(
          status: TransactionListStatus.failure,
          transactions: state.transactions,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}