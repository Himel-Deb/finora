import 'package:finora/feature/transaction/presentation/pages/transaction_list_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:finora/core/constants/app_size.dart';
import 'package:finora/core/constants/app_string.dart';
import 'package:finora/core/theme/app_colors.dart';
import 'package:finora/core/theme/app_text_style.dart';
import 'package:finora/data/local/hive/transactions_box.dart';
import 'package:finora/feature/transaction/data/models/transaction_model.dart';

class RecentTransactions extends StatefulWidget {
  const RecentTransactions({super.key});

  @override
  State<RecentTransactions> createState() => _RecentTransactionsState();
}

class _RecentTransactionsState extends State<RecentTransactions> {
  late final Future<Box<TransactionModel>> _boxFuture;

  @override
  void initState() {
    super.initState();
    _boxFuture = TransactionBox.openBox();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppStrings.recentTransactions, style: AppTextStyles.title),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TransactionListPage(),
                  ),
                );
              },
              child: const Text('See All'),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.spacingSm),

        FutureBuilder<Box<TransactionModel>>(
          future: _boxFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final box = snapshot.data!;

            return ValueListenableBuilder(
              valueListenable: box.listenable(),
              builder: (context, Box<TransactionModel> box, _) {
                final transactions = box.values.toList()
                  ..sort((a, b) => b.date.compareTo(a.date));

                if (transactions.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('No transactions yet'),
                    ),
                  );
                }

                final recentTransactions = transactions.take(3).toList();

                return Column(
                  children: recentTransactions.map((transaction) {
                    final isIncome = transaction.type == TransactionType.income;

                    return _TransactionItem(
                      title: transaction.categoryId,
                      date: transaction.date.toString().split('.')[0],
                      amount:
                          '${isIncome ? '+' : '-'}৳${(transaction.amountPaisa / 100).toStringAsFixed(2)}',
                      isIncome: isIncome,
                    );
                  }).toList(),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _TransactionItem extends StatelessWidget {
  const _TransactionItem({
    required this.title,
    required this.date,
    required this.amount,
    required this.isIncome,
  });

  final String title;
  final String date;
  final String amount;
  final bool isIncome;

  @override
  Widget build(BuildContext context) {
    final amountColor = isIncome ? AppColors.primary : AppColors.error;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spacingSm),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: amountColor.withValues(alpha: 0.12),
            child: Icon(
              isIncome
                  ? Icons.account_balance_wallet_rounded
                  : Icons.shopping_cart_rounded,
              color: amountColor,
            ),
          ),
          const SizedBox(width: AppSizes.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.body),
                Text(date, style: AppTextStyles.caption),
              ],
            ),
          ),
          SizedBox(
            width: 120,
            child: Text(
              amount,
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body.copyWith(
                color: amountColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
