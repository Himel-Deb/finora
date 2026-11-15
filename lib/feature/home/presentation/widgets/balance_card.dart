
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:finora/core/constants/app_size.dart';
import 'package:finora/core/constants/app_string.dart';
import 'package:finora/core/theme/app_text_style.dart';
import 'package:finora/core/theme/app_colors.dart';

import 'package:finora/data/local/hive/transactions_box.dart';
import 'package:finora/feature/transaction/data/models/transaction_model.dart';

class BalanceCard extends StatefulWidget {
  const BalanceCard({super.key});

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  bool _isBalanceVisible = true;

  late Future<Box<TransactionModel>> _boxFuture;

  @override
  void initState() {
    super.initState();
    _boxFuture = TransactionBox.openBox();
  }

  String _formatAmount(int amountPaisa) {
    return '৳${(amountPaisa / 100).toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Box<TransactionModel>>(
      future: _boxFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final box = snapshot.data!;

        return ValueListenableBuilder<Box<TransactionModel>>(
          valueListenable: box.listenable(),
          builder: (context, box, child) {
            final transactions = box.values.toList();

            int totalIncome = 0;
            int totalExpense = 0;

            for (final transaction in transactions) {
              if (transaction.type == TransactionType.income) {
                totalIncome += transaction.amountPaisa;
              } else {
                totalExpense += transaction.amountPaisa;
              }
            }

            final totalBalance = totalIncome - totalExpense;

            final balanceText = _isBalanceVisible
                ? _formatAmount(totalBalance)
                : '৳••••••';

            final incomeText = _isBalanceVisible
                ? _formatAmount(totalIncome)
                : '৳••••••';

            final expenseText = _isBalanceVisible
                ? _formatAmount(totalExpense)
                : '৳••••••';

            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSizes.spacingLg),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(
                  AppSizes.radiusLg,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.totalBalance,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.onPrimary,
                        ),
                      ),
                      Icon(
                        Icons.account_balance_wallet_rounded,
                        color: AppColors.onPrimary,
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSizes.spacingSm),

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          balanceText,
                          style: AppTextStyles.heading.copyWith(
                            color: AppColors.onPrimary,
                          ),
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          setState(() {
                            _isBalanceVisible = !_isBalanceVisible;
                          });
                        },
                        icon: Icon(
                          _isBalanceVisible
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded,
                          color: AppColors.onPrimary,
                        ),
                        tooltip: _isBalanceVisible
                            ? 'Hide balance'
                            : 'Show balance',
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSizes.spacingLg),

                  Divider(
                    color: AppColors.onPrimary.withValues(alpha: 0.3),
                  ),

                  const SizedBox(height: AppSizes.spacingSm),

                  Row(
                    children: [
                      Expanded(
                        child: _BalanceSummary(
                          title: 'Income',
                          amount: incomeText,
                          icon: Icons.trending_up_rounded,
                        ),
                      ),

                      const SizedBox(width: AppSizes.spacingMd),

                      Expanded(
                        child: _BalanceSummary(
                          title: 'Expense',
                          amount: expenseText,
                          icon: Icons.trending_down_rounded,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _BalanceSummary extends StatelessWidget {
  const _BalanceSummary({
    required this.title,
    required this.amount,
    required this.icon,
  });

  final String title;
  final String amount;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: AppSizes.iconSize,
              color: AppColors.onPrimary,
            ),
            const SizedBox(width: AppSizes.spacingXs),
            Flexible(
              child: Text(
                title,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.onPrimary,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSizes.spacingXs),

        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            amount,
            style: AppTextStyles.title.copyWith(
              color: AppColors.onPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
