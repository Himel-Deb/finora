
import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 1)
enum TransactionType {
  @HiveField(0)
  income,
  
  @HiveField(1)
  expense,
}

@HiveType(typeId: 0)
class TransactionModel extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int amountPaisa;

  @HiveField(2)
  final TransactionType type;

  @HiveField(3)
  final String categoryId;

  @HiveField(4)
  final String walletId;

  @HiveField(5)
  final DateTime date;

  @HiveField(6)
  final String? note;

  const TransactionModel({
    required this.id,
    required this.amountPaisa,
    required this.type,
    required this.categoryId,
    required this.walletId,
    required this.date,
    this.note,
  });

  @override
  List<Object?> get props => [
        id,
        amountPaisa,
        type,
        categoryId,
        walletId,
        date,
        note,
      ];
}