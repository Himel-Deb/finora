import 'package:finora/feature/transaction/logic/event/transaction_list_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:finora/feature/transaction/data/models/transaction_model.dart';
import 'package:finora/feature/transaction/logic/bloc/transaction_list_bloc.dart';
import 'package:finora/feature/transaction/logic/states/transaction_list_state.dart';

class TransactionListPage extends StatefulWidget {
  const TransactionListPage({super.key});

  @override
  State<TransactionListPage> createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  String _selectedFilter = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TransactionListBloc(context.read())..add(const LoadTransactions()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Transactions')),
        body: BlocBuilder<TransactionListBloc, TransactionListState>(
          builder: (context, state) {
            if (state.status == TransactionListStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == TransactionListStatus.failure) {
              return Center(
                child: Text(state.errorMessage ?? 'Something went wrong'),
              );
            }

            final filteredTransactions = state.transactions.where((
              transaction,
            ) {
              final matchesSearch =
                  transaction.categoryId.toLowerCase().contains(_searchQuery) ||
                  (transaction.note ?? '').toLowerCase().contains(_searchQuery);

              final matchesFilter =
                  _selectedFilter == 'All' ||
                  (_selectedFilter == 'Income' &&
                      transaction.type == TransactionType.income) ||
                  (_selectedFilter == 'Expense' &&
                      transaction.type == TransactionType.expense);

              return matchesSearch && matchesFilter;
            }).toList();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search transactions...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      ),
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase();
                      });
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: ['All', 'Income', 'Expense'].map((filter) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            label: Text(filter),
                            selected: _selectedFilter == filter,
                            onSelected: (_) {
                              setState(() {
                                _selectedFilter = filter;
                              });
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 12),

                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<TransactionListBloc>().add(
                        const LoadTransactions(),
                      );
                    },
                    child: filteredTransactions.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: const [
                              SizedBox(height: 150),
                              Center(child: Text('No transactions found')),
                            ],
                          )
                        : ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: filteredTransactions.length,
                            itemBuilder: (context, index) {
                              final transaction = filteredTransactions[index];

                              final isIncome =
                                  transaction.type == TransactionType.income;

                              return ListTile(
                                leading: CircleAvatar(
                                  child: Icon(
                                    isIncome
                                        ? Icons.arrow_downward
                                        : Icons.arrow_upward,
                                    color: isIncome ? Colors.green : Colors.red,
                                  ),
                                ),
                                title: Text(transaction.categoryId),
                                subtitle: Text(
                                  transaction.note ?? 'No description',
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${isIncome ? '+' : '-'}৳${(transaction.amountPaisa / 100).toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: isIncome
                                            ? Colors.green
                                            : Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                      ),
                                      onPressed: () async {
                                        final confirmed = await showDialog<bool>(
                                          context: context,
                                          builder: (dialogContext) {
                                            return AlertDialog(
                                              title: const Text(
                                                'Delete Transaction?',
                                              ),
                                              content: const Text(
                                                'Are you sure you want to delete this transaction?',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(
                                                      dialogContext,
                                                      false,
                                                    );
                                                  },
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(
                                                      dialogContext,
                                                      true,
                                                    );
                                                  },
                                                  child: const Text('Delete'),
                                                ),
                                              ],
                                            );
                                          },
                                        );

                                        if (confirmed == true &&
                                            context.mounted) {
                                          context
                                              .read<TransactionListBloc>()
                                              .add(
                                                DeleteTransaction(
                                                  transaction.id,
                                                ),
                                              );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
