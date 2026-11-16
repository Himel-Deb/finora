import 'package:finora/data/local/hive/user_box.dart';
import 'package:finora/feature/auth/data/models/user_model.dart';
import 'package:finora/feature/auth/data/services/password_service.dart';
import 'package:finora/feature/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  static const String userId = 'local_user';

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final existingUser = await getRegisteredUser();

    if (existingUser != null) {
      throw Exception('User already registered');
    }

    final passwordHash =
        await PasswordService.hashPassword(password);

    final user = UserModel(
      id: userId,
      name: name,
      email: email.trim().toLowerCase(),
      passwordHash: passwordHash,
    );

    await UserBox.saveUser(user);

    return user;
  }

  @override
  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    final user = await getRegisteredUser();

    if (user == null) return null;

    if (user.email != email.trim().toLowerCase()) {
      return null;
    }

    final isValid = await PasswordService.verifyPassword(
      password,
      user.passwordHash,
    );

    return isValid ? user : null;
  }

  @override
  Future<UserModel?> getRegisteredUser() async {
    return UserBox.getUser(userId);
  }

  @override
Future<void> updateUser(UserModel user) async {
  await UserBox.saveUser(user);
}
}