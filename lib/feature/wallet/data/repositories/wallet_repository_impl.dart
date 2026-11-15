import 'package:finora/data/local/hive/wallet_box.dart';
import 'package:finora/feature/wallet/data/models/wallet_model.dart';
import 'package:finora/feature/wallet/domain/repositories/wallet_repository.dart';

class WalletRepositoryImpl implements WalletRepository {
  @override
  Future<void> addWallet(WalletModel wallet) async {
    await WalletBox.saveWallet(wallet);
  }

  @override
  Future<WalletModel?> getWallet(String id) async {
    return await WalletBox.getWallet(id);
  }

  @override
  Future<List<WalletModel>> getAllWallets() async {
    return await WalletBox.getAllWallets();
  }

  @override
  Future<void> deleteWallet(String id) async {
    await WalletBox.deleteWallet(id);
  }
}