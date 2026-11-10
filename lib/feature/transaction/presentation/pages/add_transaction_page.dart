import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:finora/feature/transaction/data/models/transaction_model.dart';
import 'package:finora/feature/transaction/data/repositories/transaction_repository_impl.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  TransactionType _type = TransactionType.expense;
  String _categoryId = 'food';
  String _walletId = 'cash';

  Future<void> _saveTransaction() async {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.parse(_amountController.text);

    final transaction = TransactionModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      amountPaisa: (amount * 100).round(),
      type: _type,
      categoryId: _categoryId,
      walletId: _walletId,
      date: DateTime.now(),
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
    );

    try {
      await context
          .read<TransactionRepositoryImpl>()
          .addTransaction(transaction);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaction saved successfully')),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
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
                  if (value != null) {
                    setState(() => _type = value);
                  }
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
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
                value: _categoryId,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'food', child: Text('Food')),
                  DropdownMenuItem(value: 'transport', child: Text('Transport')),
                  DropdownMenuItem(value: 'shopping', child: Text('Shopping')),
                  DropdownMenuItem(value: 'salary', child: Text('Salary')),
                  DropdownMenuItem(value: 'other', child: Text('Other')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _categoryId = value);
                  }
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _walletId,
                decoration: const InputDecoration(
                  labelText: 'Wallet',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'cash', child: Text('Cash')),
                  DropdownMenuItem(value: 'bank', child: Text('Bank')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _walletId = value);
                  }
                },
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
                onPressed: _saveTransaction,
                child: const Text('Save Transaction'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}