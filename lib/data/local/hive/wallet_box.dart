import 'package:hive_flutter/hive_flutter.dart';
import 'package:finora/feature/wallet/data/models/wallet_model.dart';

class WalletBox {
  static const String boxName = 'wallets';

  static Future<Box<WalletModel>> openBox() async {
    return await Hive.openBox<WalletModel>(boxName);
  }

  static Future<void> saveWallet(WalletModel wallet) async {
    final box = await openBox();
    await box.put(wallet.id, wallet);
  }

  static Future<WalletModel?> getWallet(String id) async {
    final box = await openBox();
    return box.get(id);
  }

  static Future<List<WalletModel>> getAllWallets() async {
    final box = await openBox();
    return box.values.toList();
  }

  static Future<void> deleteWallet(String id) async {
    final box = await openBox();
    await box.delete(id);
  }
}