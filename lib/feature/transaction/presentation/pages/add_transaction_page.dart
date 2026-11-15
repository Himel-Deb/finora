
import 'package:finora/feature/categories/data/repositories.dart/category_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:finora/feature/transaction/data/models/transaction_model.dart';
import 'package:finora/feature/transaction/data/repositories/transaction_repository_impl.dart';

import 'package:finora/feature/categories/data/models/category_model.dart';
import 'package:finora/feature/wallet/data/models/wallet_model.dart';
import 'package:finora/feature/wallet/data/repositories/wallet_repository_impl.dart';

class AddTransactionPage extends StatefulWidget {
  final TransactionModel? transaction;
  final TransactionType? initialType;

  const AddTransactionPage({
    super.key,
    this.transaction,
    this.initialType,
  });

  @override
  State<AddTransactionPage> createState() =>
      _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();

  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  final _categoryRepository = CategoryRepositoryImpl();
  final _walletRepository = WalletRepositoryImpl();

  TransactionType _type = TransactionType.expense;

  List<CategoryModel> _categories = [];
  List<WalletModel> _wallets = [];

  String? _categoryId;
  String? _walletId;

  bool _isLoading = true;
  bool _isSaving = false;

  bool get _isEditing => widget.transaction != null;

  @override
  void initState() {
    super.initState();

    final transaction = widget.transaction;

    if (transaction != null) {
      _type = transaction.type;

      _amountController.text =
          (transaction.amountPaisa / 100).toStringAsFixed(2);

      _noteController.text = transaction.note ?? '';

      _categoryId = transaction.categoryId;
      _walletId = transaction.walletId;
    } else {
      _type = widget.initialType ?? TransactionType.expense;
    }

    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final categories =
          await _categoryRepository.getAllCategories();

      final wallets =
          await _walletRepository.getAllWallets();

      if (!mounted) return;

      setState(() {
        _categories = categories;
        _wallets = wallets;

        if (_isEditing) {
          final matchingCategory = _categories.any(
            (category) =>
                category.id == widget.transaction!.categoryId &&
                category.isIncome == (_type == TransactionType.income),
          );

          _categoryId = matchingCategory
              ? widget.transaction!.categoryId
              : (_availableCategories.isNotEmpty
                  ? _availableCategories.first.id
                  : null);

          final matchingWallet = _wallets.any(
            (wallet) => wallet.id == widget.transaction!.walletId,
          );

          _walletId = matchingWallet
              ? widget.transaction!.walletId
              : (_wallets.isNotEmpty ? _wallets.first.id : null);
        } else {
          _categoryId = _availableCategories.isNotEmpty
              ? _availableCategories.first.id
              : null;

          _walletId =
              _wallets.isNotEmpty ? _wallets.first.id : null;
        }

        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  List<CategoryModel> get _availableCategories {
    final filtered = _categories
        .where(
          (category) =>
              category.isIncome == (_type == TransactionType.income),
        )
        .toList();

    if (_categoryId != null &&
        !filtered.any((category) => category.id == _categoryId)) {
      final selectedCategory = _categories.where(
        (category) => category.id == _categoryId,
      );

      if (selectedCategory.isNotEmpty) {
        filtered.add(selectedCategory.first);
      }
    }

    final uniqueCategories = <String, CategoryModel>{};

    for (final category in filtered) {
      uniqueCategories[category.id] = category;
    }

    return uniqueCategories.values.toList();
  }

  Future<void> _saveTransaction() async {
    if (_isSaving) return;

    if (!_formKey.currentState!.validate()) return;

    if (_categoryId == null || _walletId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select category and wallet'),
        ),
      );
      return;
    }

    final amount = double.parse(_amountController.text);

    final transaction = TransactionModel(
      id: widget.transaction?.id ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      amountPaisa: (amount * 100).round(),
      type: _type,
      categoryId: _categoryId!,
      walletId: _walletId!,
      date: widget.transaction?.date ?? DateTime.now(),
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
    );

    setState(() {
      _isSaving = true;
    });

    try {
      final repository = context.read<TransactionRepositoryImpl>();

      if (_isEditing) {
        await repository.updateTransaction(transaction);
      } else {
        await repository.addTransaction(transaction);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing
                ? 'Transaction updated successfully'
                : 'Transaction saved successfully',
          ),
        ),
      );

      Navigator.pop(context, _isEditing);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Edit Transaction' : 'Add Transaction',
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Form(
          key: _formKey,

          child: ListView(
            children: [
              DropdownButtonFormField<TransactionType>(
                value: _type,
                decoration: const InputDecoration(
                  labelText: 'Transaction Type',
                  border: OutlineInputBorder(),
                ),

                items: const [
                  DropdownMenuItem(
                    value: TransactionType.income,
                    child: Text('Income'),
                  ),
                  DropdownMenuItem(
                    value: TransactionType.expense,
                    child: Text('Expense'),
                  ),
                ],

                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    _type = value;

                    _categoryId = _availableCategories.isNotEmpty
                        ? _availableCategories.first.id
                        : null;
                  });
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Amount (৳)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final amount = double.tryParse(value ?? '');

                  if (amount == null || amount <= 0) {
                    return 'Enter a valid amount';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _availableCategories.any(
                  (category) => category.id == _categoryId,
                )
                    ? _categoryId
                    : null,

                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),

                items: _availableCategories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category.id,
                    child: Text(category.name),
                  );
                }).toList(),

                onChanged: (value) {
                  setState(() {
                    _categoryId = value;
                  });
                },

                validator: (value) =>
                    value == null ? 'Select a category' : null,
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _wallets.any(
                  (wallet) => wallet.id == _walletId,
                )
                    ? _walletId
                    : null,

                decoration: const InputDecoration(
                  labelText: 'Wallet',
                  border: OutlineInputBorder(),
                ),

                items: _wallets.map((wallet) {
                  return DropdownMenuItem<String>(
                    value: wallet.id,
                    child: Text(wallet.name),
                  );
                }).toList(),

                onChanged: (value) {
                  setState(() {
                    _walletId = value;
                  });
                },

                validator: (value) =>
                    value == null ? 'Select a wallet' : null,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Note (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _isSaving ? null : _saveTransaction,
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        _isEditing
                            ? 'Update Transaction'
                            : 'Save Transaction',
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
