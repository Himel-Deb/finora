
import 'package:finora/feature/budgets/presentation/add_budget_page.dart';
import 'package:finora/feature/budgets/presentation/budget_list_page.dart';
import 'package:finora/feature/profile/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';

import 'package:finora/feature/wallet/presentation/pages/wallet_list_page.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.account_balance_wallet_outlined),
            title: const Text('Wallets'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const WalletListPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.pie_chart_outline),
            title: const Text('Budgets'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const BudgetListPage(),
    ),
  );
},
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Profile'),
            trailing: const Icon(Icons.chevron_right),
           onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const ProfilePage(),
    ),
  );
},
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
