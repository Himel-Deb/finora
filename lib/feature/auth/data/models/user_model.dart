
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 5)
class UserModel extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String passwordHash;

  @HiveField(4)
  final String? photoPath;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.passwordHash,
    this.photoPath,
  });

  UserModel copyWith({
    String? name,
    String? email,
    String? photoPath,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      passwordHash: passwordHash,
      photoPath: photoPath ?? this.photoPath,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        passwordHash,
        photoPath,
      ];
}
