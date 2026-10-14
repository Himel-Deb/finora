
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:finora/core/constants/app_size.dart';
import 'package:finora/core/constants/app_string.dart';
import 'package:finora/core/theme/app_colors.dart';
import 'package:finora/core/theme/app_text_style.dart';

class ExpenseOverview extends StatelessWidget {
  const ExpenseOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(
          AppSizes.radiusLg,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  AppStrings.expenseOverview,
                  style: AppTextStyles.title,
                ),
              ),
              Text(
                AppStrings.thisMonth,
                style: AppTextStyles.caption,
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spacingLg),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: SizedBox(
                  height: 140,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          centerSpaceRadius: 38,
                          sectionsSpace: 2,
                          startDegreeOffset: -90,
                          sections: [
                            PieChartSectionData(
                              value: 35,
                              color: AppColors.primary,
                              radius: 18,
                              showTitle: false,
                            ),
                            PieChartSectionData(
                              value: 20,
                              color: Colors.blue,
                              radius: 18,
                              showTitle: false,
                            ),
                            PieChartSectionData(
                              value: 15,
                              color: Colors.orange,
                              radius: 18,
                              showTitle: false,
                            ),
                            PieChartSectionData(
                              value: 12,
                              color: Colors.red,
                              radius: 18,
                              showTitle: false,
                            ),
                            PieChartSectionData(
                              value: 18,
                              color: Colors.purple,
                              radius: 18,
                              showTitle: false,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '৳19,570',
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Total',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.spacingSm),
              const Expanded(
                flex: 6,
                child: _CategoryList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryList extends StatelessWidget {
  const _CategoryList();

  @override
  Widget build(BuildContext context) {
    final categories = [
      (AppStrings.food, '35%', AppColors.primary),
      (AppStrings.transport, '20%', Colors.blue),
      (AppStrings.shopping, '15%', Colors.orange),
      (AppStrings.bills, '12%', Colors.red),
      (AppStrings.others, '18%', Colors.purple),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: categories.map((category) {
        return Padding(
          padding: const EdgeInsets.only(
            bottom: AppSizes.spacingSm,
          ),
          child: Row(
            children: [
              Container(
                width: AppSizes.spacingSm,
                height: AppSizes.spacingSm,
                decoration: BoxDecoration(
                  color: category.$3,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSizes.spacingSm),
              Expanded(
                child: Text(
                  category.$1,
                  style: AppTextStyles.caption,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                category.$2,
                style: AppTextStyles.caption,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
