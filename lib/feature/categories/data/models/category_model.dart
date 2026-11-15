import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'category_model.g.dart';

@HiveType(typeId: 2)
class CategoryModel extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String icon;

  @HiveField(3)
  final bool isIncome;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.isIncome,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        icon,
        isIncome,
      ];
}