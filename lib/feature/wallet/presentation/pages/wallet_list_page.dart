
import 'package:flutter/material.dart';

import 'package:finora/feature/wallet/data/models/wallet_model.dart';
import 'package:finora/feature/wallet/data/repositories/wallet_repository_impl.dart';
import 'package:finora/feature/wallet/presentation/pages/add_wallet_page.dart';
import 'package:finora/feature/transaction/data/repositories/transaction_repository_impl.dart';
import 'package:finora/feature/transaction/data/models/transaction_model.dart';

class WalletListPage extends StatefulWidget {
  const WalletListPage({super.key});

  @override
  State<WalletListPage> createState() => _WalletListPageState();
}

class _WalletListPageState extends State<WalletListPage> {
  final _walletRepository = WalletRepositoryImpl();

  late Future<List<WalletModel>> _walletFuture;

  @override
  void initState() {
    super.initState();
    _loadWallets();
  }

  void _loadWallets() {
    _walletFuture = _walletRepository.getAllWallets();
  }

  Future<int> _getWalletBalance(String walletId) async {
    final transactions =
        await TransactionRepositoryImpl().getAllTransactions();

    int balance = 0;

    for (final transaction in transactions) {
      if (transaction.walletId == walletId) {
        if (transaction.type == TransactionType.income) {
          balance += transaction.amountPaisa;
        } else {
          balance -= transaction.amountPaisa;
        }
      }
    }

    return balance;
  }

  Future<int> _getTotalBalance(List<WalletModel> wallets) async {
    int total = 0;

    for (final wallet in wallets) {
      total += await _getWalletBalance(wallet.id);
    }

    return total;
  }

  String _formatMoney(int paisa) {
    return '৳ ${(paisa / 100).toStringAsFixed(2)}';
  }

  IconData _getWalletIcon(String icon) {
    switch (icon) {
      case 'account_balance':
        return Icons.account_balance;
      case 'account_balance_wallet':
        return Icons.account_balance_wallet;
      case 'savings':
        return Icons.savings;
      case 'credit_card':
        return Icons.credit_card;
      default:
        return Icons.payments;
    }
  }

  Future<void> _openAddWallet({WalletModel? wallet}) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => AddWalletPage(wallet: wallet),
      ),
    );

    if (result == true && mounted) {
      setState(_loadWallets);
    }
  }

  Future<void> _deleteWallet(WalletModel wallet) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Wallet?'),
        content: Text('Delete "${wallet.name}" wallet?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _walletRepository.deleteWallet(wallet.id);

      if (!mounted) return;

      setState(_loadWallets);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wallet deleted')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wallets'),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddWallet(),
        backgroundColor: const Color(0xFF10B981),
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: FutureBuilder<List<WalletModel>>(
        future: _walletFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Failed to load wallets'));
          }

          final wallets = snapshot.data ?? [];

          if (wallets.isEmpty) {
            return const Center(child: Text('No wallets found'));
          }

          return Column(
            children: [
              FutureBuilder<int>(
                future: _getTotalBalance(wallets),
                builder: (context, balanceSnapshot) {
                  final total = balanceSnapshot.data ?? 0;

                  return Card(
                    margin: const EdgeInsets.all(16),
                    color: const Color(0xFF10B981),
                    child: ListTile(
                      title: const Text(
                        'Total Balance',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        balanceSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? 'Loading...'
                            : _formatMoney(total),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: wallets.length,
                  itemBuilder: (context, index) {
                    final wallet = wallets[index];

                    return FutureBuilder<int>(
                      future: _getWalletBalance(wallet.id),
                      builder: (context, balanceSnapshot) {
                        return ListTile(
                          leading: CircleAvatar(
                            child: Icon(
                              _getWalletIcon(wallet.icon),
                            ),
                          ),

                          title: Text(wallet.name),

                          subtitle: Text(
                            balanceSnapshot.connectionState ==
                                    ConnectionState.waiting
                                ? 'Loading...'
                                : _formatMoney(
                                    balanceSnapshot.data ?? 0,
                                  ),
                          ),

                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                _openAddWallet(wallet: wallet);
                              } else if (value == 'delete') {
                                _deleteWallet(wallet);
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
