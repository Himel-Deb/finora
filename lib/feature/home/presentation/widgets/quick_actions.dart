
import 'package:flutter/material.dart';

import 'package:finora/core/constants/app_size.dart';
import 'package:finora/core/constants/app_string.dart';
import 'package:finora/core/theme/app_colors.dart';
import 'package:finora/core/theme/app_text_style.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.quickActions,
          style: AppTextStyles.title,
        ),
        const SizedBox(height: AppSizes.spacingMd),
        Row(
          children: [
            Expanded(
              child: _QuickActionItem(
                label: AppStrings.addTransaction,
                icon: Icons.add_rounded,
                color: AppColors.primary,
                onTap: () {},
              ),
            ),
            Expanded(
              child: _QuickActionItem(
                label: AppStrings.addIncome,
                icon: Icons.arrow_downward_rounded,
                color: AppColors.textSecondary,
                onTap: () {},
              ),
            ),
            Expanded(
              child: _QuickActionItem(
                label: AppStrings.addExpense,
                icon: Icons.arrow_upward_rounded,
                color: AppColors.error,
                onTap: () {},
              ),
            ),
            Expanded(
              child: _QuickActionItem(
                label: AppStrings.transfer,
                icon: Icons.swap_horiz_rounded,
                color: AppColors.textPrimary,
                onTap: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  const _QuickActionItem({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(
        AppSizes.radiusLg,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSizes.spacingSm,
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: AppSizes.spacingXl,
              backgroundColor: color.withValues(alpha: 0.12),
              child: Icon(
                icon,
                color: color,
                size: AppSizes.iconSize,
              ),
            ),
            const SizedBox(height: AppSizes.spacingSm),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }
}
