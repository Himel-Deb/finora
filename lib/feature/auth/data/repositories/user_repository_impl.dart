import 'package:finora/data/local/hive/user_box.dart';
import 'package:finora/feature/auth/data/models/user_model.dart';
import 'package:finora/feature/auth/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  @override
  Future<void> saveUser(UserModel user) async {
    await UserBox.saveUser(user);
  }

  @override
  Future<UserModel?> getUser(String id) async {
    return UserBox.getUser(id);
  }

  @override
  Future<void> updateUser(UserModel user) async {
    await UserBox.saveUser(user);
  }
}