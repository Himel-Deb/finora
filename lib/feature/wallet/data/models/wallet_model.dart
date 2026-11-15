import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'wallet_model.g.dart';

@HiveType(typeId: 3)
class WalletModel extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String icon;

  const WalletModel({
    required this.id,
    required this.name,
    required this.icon,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        icon,
      ];
}