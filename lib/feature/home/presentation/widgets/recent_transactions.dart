import 'package:flutter/material.dart';

import 'package:finora/core/constants/app_size.dart';
import 'package:finora/core/constants/app_string.dart';
import 'package:finora/core/theme/app_colors.dart';
import 'package:finora/core/theme/app_text_style.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppStrings.recentTransactions, style: AppTextStyles.title),
            TextButton(onPressed: () {}, child: const Text('See All')),
          ],
        ),
        const SizedBox(height: AppSizes.spacingSm),
        const _TransactionItem(
          title: 'Groceries',
          date: 'Today, 10:30 AM',
          amount: '-৳850.00',
          icon: Icons.shopping_cart_rounded,
          isIncome: false,
        ),
        const _TransactionItem(
          title: 'Salary',
          date: 'Yesterday, 08:00 AM',
          amount: '+৳25,000.00',
          icon: Icons.account_balance_wallet_rounded,
          isIncome: true,
        ),
        const _TransactionItem(
          title: 'Transport',
          date: 'Yesterday, 08:15 AM',
          amount: '-৳400.00',
          icon: Icons.directions_bus_rounded,
          isIncome: false,
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
    required this.icon,
    required this.isIncome,
  });

  final String title;
  final String date;
  final String amount;
  final IconData icon;
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
            child: Icon(icon, color: amountColor),
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
          const SizedBox(width: AppSizes.spacingSm),

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
