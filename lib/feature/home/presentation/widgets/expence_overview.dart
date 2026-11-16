
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:finora/core/constants/app_size.dart';
import 'package:finora/core/constants/app_string.dart';
import 'package:finora/core/theme/app_colors.dart';
import 'package:finora/core/theme/app_text_style.dart';

import 'package:finora/data/local/hive/transactions_box.dart';
import 'package:finora/feature/transaction/data/models/transaction_model.dart';
import 'package:finora/feature/categories/data/models/category_model.dart';
import 'package:finora/feature/categories/data/repositories.dart/category_repository_impl.dart';

class ExpenseOverview extends StatefulWidget {
  const ExpenseOverview({super.key});

  @override
  State<ExpenseOverview> createState() => _ExpenseOverviewState();
}

class _ExpenseOverviewState extends State<ExpenseOverview> {
  final _categoryRepository = CategoryRepositoryImpl();

  late Future<Box<TransactionModel>> _transactionBoxFuture;
  late Future<List<CategoryModel>> _categoryFuture;

  @override
  void initState() {
    super.initState();

    _transactionBoxFuture = TransactionBox.openBox();
    _categoryFuture = _categoryRepository.getAllCategories();
  }

  String _formatMoney(int paisa) {
    return '৳ ${(paisa / 100).toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
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

          FutureBuilder<Box<TransactionModel>>(
            future: _transactionBoxFuture,
            builder: (context, boxSnapshot) {
              if (!boxSnapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (boxSnapshot.hasError) {
                return const Text('Failed to load transactions');
              }

              final box = boxSnapshot.data!;

              return FutureBuilder<List<CategoryModel>>(
                future: _categoryFuture,
                builder: (context, categorySnapshot) {
                  if (!categorySnapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (categorySnapshot.hasError) {
                    return const Text('Failed to load categories');
                  }

                  final categories = categorySnapshot.data!;

                  return ValueListenableBuilder<Box<TransactionModel>>(
                    valueListenable: box.listenable(),
                    builder: (context, transactionBox, child) {
                      final now = DateTime.now();

                      final expenses = transactionBox.values.where((item) {
                        return item.type == TransactionType.expense &&
                            item.date.month == now.month &&
                            item.date.year == now.year;
                      });

                      final Map<String, int> categoryTotals = {};

                      for (final transaction in expenses) {
                        categoryTotals.update(
                          transaction.categoryId,
                          (value) => value + transaction.amountPaisa,
                          ifAbsent: () => transaction.amountPaisa,
                        );
                      }

                      final data = <_ExpenseCategoryData>[];

                      for (final entry in categoryTotals.entries) {
                        final category = categories.where(
                          (item) => item.id == entry.key,
                        );

                        if (category.isNotEmpty) {
                          data.add(
                            _ExpenseCategoryData(
                              name: category.first.name,
                              amount: entry.value,
                            ),
                          );
                        }
                      }

                      data.sort(
                        (a, b) => b.amount.compareTo(a.amount),
                      );

                      if (data.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text('No expenses this month'),
                          ),
                        );
                      }

                      final total = data.fold<int>(
                        0,
                        (sum, item) => sum + item.amount,
                      );

                      final colors = [
                        AppColors.primary,
                        Colors.blue,
                        Colors.orange,
                        Colors.red,
                        Colors.purple,
                        Colors.teal,
                      ];

                      return Row(
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
                                      sections: List.generate(
                                        data.length,
                                        (index) {
                                          return PieChartSectionData(
                                            value: data[index]
                                                .amount
                                                .toDouble(),
                                            color: colors[
                                                index % colors.length],
                                            radius: 18,
                                            showTitle: false,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        _formatMoney(total),
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
                          Expanded(
                            flex: 6,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(data.length, (index) {
                                final item = data[index];
                                final percentage =
                                    item.amount / total * 100;

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
                                          color: colors[
                                              index % colors.length],
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: AppSizes.spacingSm,
                                      ),
                                      Expanded(
                                        child: Text(
                                          item.name,
                                          style: AppTextStyles.caption,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        '${percentage.toStringAsFixed(0)}%',
                                        style: AppTextStyles.caption,
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ExpenseCategoryData {
  final String name;
  final int amount;

  const _ExpenseCategoryData({
    required this.name,
    required this.amount,
  });
}
