
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'budget_model.g.dart';

@HiveType(typeId: 4)
class BudgetModel extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String categoryId;

  @HiveField(2)
  final int amountPaisa;

  @HiveField(3)
  final int month;

  @HiveField(4)
  final int year;

  const BudgetModel({
    required this.id,
    required this.categoryId,
    required this.amountPaisa,
    required this.month,
    required this.year,
  });

  @override
  List<Object?> get props => [
        id,
        categoryId,
        amountPaisa,
        month,
        year,
      ];
}
