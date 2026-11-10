import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:finora/feature/transaction/data/models/transaction_model.dart';
import 'package:finora/feature/transaction/data/repositories/transaction_repository_impl.dart';

void main() {
  late Directory tempDir;
  late TransactionRepositoryImpl repository;

  setUpAll(() async {
    Hive.registerAdapter(TransactionTypeAdapter());
    Hive.registerAdapter(TransactionModelAdapter());
  });

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp();

    Hive.init(tempDir.path);

    repository = TransactionRepositoryImpl();
  });

  tearDown(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  final transaction = TransactionModel(
    id: 'txn_001',
    amountPaisa: 25050,
    type: TransactionType.expense,
    categoryId: 'food',
    walletId: 'cash',
    date: DateTime(2026, 11, 3),
    note: 'Lunch',
  );

  test('Should add and get transaction', () async {
    await repository.addTransaction(transaction);

    final result = await repository.getTransaction('txn_001');

    expect(result, isNotNull);
    expect(result!.amountPaisa, 25050);
    expect(result.note, 'Lunch');
  });

  test('Should get all transactions', () async {
    await repository.addTransaction(transaction);

    final result = await repository.getAllTransactions();

    expect(result.length, 1);
  });

  test('Should delete transaction', () async {
    await repository.addTransaction(transaction);

    await repository.deleteTransaction('txn_001');

    final result = await repository.getTransaction('txn_001');

    expect(result, isNull);
  });
}