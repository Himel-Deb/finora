import 'package:finora/feature/wallet/data/models/wallet_model.dart';
import 'package:finora/feature/wallet/data/repositories/wallet_repository_impl.dart';

class DefaultWallets {
  static Future<void> initialize() async {
    final repository = WalletRepositoryImpl();

    final existingWallets = await repository.getAllWallets();

    if (existingWallets.isNotEmpty) return;

    final wallets = [
      const WalletModel(
        id: 'cash',
        name: 'Cash',
        icon: 'payments',
      ),
      const WalletModel(
        id: 'bank',
        name: 'Bank',
        icon: 'account_balance',
      ),
      const WalletModel(
        id: 'bkash',
        name: 'bKash',
        icon: 'account_balance_wallet',
      ),
    ];

    for (final wallet in wallets) {
      await repository.addWallet(wallet);
    }
  }
}