import 'package:hive_flutter/hive_flutter.dart';
import 'package:finora/feature/auth/data/models/user_model.dart';

class UserBox {
  static const String boxName = 'users';

  static Future<Box<UserModel>> openBox() async {
    return Hive.openBox<UserModel>(boxName);
  }

  static Future<void> saveUser(UserModel user) async {
    final box = await openBox();
    await box.put(user.id, user);
  }

  static Future<UserModel?> getUser(String id) async {
    final box = await openBox();
    return box.get(id);
  }
}