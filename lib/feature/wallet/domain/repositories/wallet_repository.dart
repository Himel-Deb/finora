import 'package:finora/feature/wallet/data/models/wallet_model.dart';

abstract class WalletRepository {
  Future<void> addWallet(WalletModel wallet);

  Future<WalletModel?> getWallet(String id);

  Future<List<WalletModel>> getAllWallets();

  Future<void> deleteWallet(String id);
}