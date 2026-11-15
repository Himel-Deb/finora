
import 'package:finora/feature/budgets/data/models/budget_model.dart';
import 'package:finora/feature/budgets/data/repositories/budget_repository_impl.dart';
import 'package:finora/feature/budgets/presentation/add_budget_page.dart';
import 'package:flutter/material.dart';

import 'package:finora/feature/categories/data/models/category_model.dart';
import 'package:finora/feature/categories/data/repositories.dart/category_repository_impl.dart';

import 'package:finora/feature/transaction/data/models/transaction_model.dart';
import 'package:finora/feature/transaction/data/repositories/transaction_repository_impl.dart';

class BudgetListPage extends StatefulWidget {
  const BudgetListPage({super.key});

  @override
  State<BudgetListPage> createState() => _BudgetListPageState();
}

class _BudgetListPageState extends State<BudgetListPage> {
  final _budgetRepository = BudgetRepositoryImpl();
  final _categoryRepository = CategoryRepositoryImpl();
  final _transactionRepository = TransactionRepositoryImpl();

  late Future<List<BudgetModel>> _budgetFuture;

  @override
  void initState() {
    super.initState();
    _loadBudgets();
  }

  void _loadBudgets() {
    _budgetFuture = _budgetRepository.getAllBudgets();
  }

  Future<int> _getSpentAmount(BudgetModel budget) async {
    final transactions =
        await _transactionRepository.getAllTransactions();

    int spent = 0;

    for (final transaction in transactions) {
      if (transaction.categoryId == budget.categoryId &&
          transaction.type == TransactionType.expense &&
          transaction.date.month == budget.month &&
          transaction.date.year == budget.year) {
        spent += transaction.amountPaisa;
      }
    }

    return spent;
  }

  String _formatMoney(int paisa) {
    return '৳ ${(paisa / 100).toStringAsFixed(2)}';
  }

  Future<void> _openAddBudget({BudgetModel? budget}) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => AddBudgetPage(budget: budget),
      ),
    );

    if (result == true && mounted) {
      setState(_loadBudgets);
    }
  }

  Future<void> _deleteBudget(BudgetModel budget) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Budget?'),
        content: const Text('Are you sure you want to delete this budget?'),
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
      await _budgetRepository.deleteBudget(budget.id);

      if (!mounted) return;

      setState(_loadBudgets);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Budget deleted')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Budgets'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddBudget(),
        backgroundColor: const Color(0xFF10B981),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: FutureBuilder<List<BudgetModel>>(
        future: _budgetFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Failed to load budgets'));
          }

          final budgets = snapshot.data ?? [];

          if (budgets.isEmpty) {
            return const Center(
              child: Text('No budgets found. Add your first budget.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: budgets.length,
            itemBuilder: (context, index) {
              final budget = budgets[index];

              return FutureBuilder(
                future: Future.wait<Object?>([
                  _categoryRepository.getCategory(budget.categoryId),
                  _getSpentAmount(budget),
                ]),
                builder: (context, dataSnapshot) {
                  if (dataSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Card(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  }

                  if (dataSnapshot.hasError || !dataSnapshot.hasData) {
                    return const SizedBox.shrink();
                  }

                  final category =
                      dataSnapshot.data![0] as CategoryModel?;
                  final spent = dataSnapshot.data![1] as int;

                  final remaining = budget.amountPaisa - spent;

                  final progress =
                      (spent / budget.amountPaisa).clamp(0.0, 1.0);

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  category?.name ?? 'Unknown Category',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                '${(progress * 100).toStringAsFixed(0)}%',
                              ),
                              PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    _openAddBudget(budget: budget);
                                  } else if (value == 'delete') {
                                    _deleteBudget(budget);
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
                            ],
                          ),
                          const SizedBox(height: 16),
                          LinearProgressIndicator(
                            value: progress,
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(10),
                            color: spent > budget.amountPaisa
                                ? Colors.red
                                : const Color(0xFF10B981),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Spent: ${_formatMoney(spent)}'),
                              Text(
                                'Budget: ${_formatMoney(budget.amountPaisa)}',
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            remaining >= 0
                                ? 'Remaining: ${_formatMoney(remaining)}'
                                : 'Overspent: ${_formatMoney(-remaining)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: remaining < 0
                                  ? Colors.red
                                  : const Color(0xFF10B981),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
