
import 'package:flutter/material.dart';

import 'package:finora/feature/wallet/data/models/wallet_model.dart';
import 'package:finora/feature/wallet/data/repositories/wallet_repository_impl.dart';

class AddWalletPage extends StatefulWidget {
  final WalletModel? wallet;

  const AddWalletPage({super.key, this.wallet});

  @override
  State<AddWalletPage> createState() => _AddWalletPageState();
}

class _AddWalletPageState extends State<AddWalletPage> {
  final _nameController = TextEditingController();
  final _repository = WalletRepositoryImpl();

  final List<String> _icons = [
    'payments',
    'account_balance',
    'account_balance_wallet',
    'savings',
    'credit_card',
  ];

  String _selectedIcon = 'payments';

  @override
  void initState() {
    super.initState();

    if (widget.wallet != null) {
      _nameController.text = widget.wallet!.name;
      _selectedIcon = widget.wallet!.icon;
    }
  }

  Future<void> _saveWallet() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) return;

    final wallet = WalletModel(
      id: widget.wallet?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      icon: _selectedIcon,
    );

    await _repository.addWallet(wallet);

    if (!mounted) return;

    Navigator.pop(context, true);
  }

  IconData _getIcon(String icon) {
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

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.wallet != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Wallet' : 'Add Wallet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Wallet Name'),
            const SizedBox(height: 8),

            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Enter wallet name',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            const Text('Select Icon'),
            const SizedBox(height: 12),

            Wrap(
              spacing: 12,
              children: _icons.map((icon) {
                return ChoiceChip(
                  label: Icon(
                    _getIcon(icon),
                    color: _selectedIcon == icon
                        ? Colors.white
                        : Colors.black,
                  ),
                  selected: _selectedIcon == icon,
                  onSelected: (_) {
                    setState(() {
                      _selectedIcon = icon;
                    });
                  },
                );
              }).toList(),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveWallet,
                child: Text(
                  isEditing ? 'Update Wallet' : 'Save Wallet',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
