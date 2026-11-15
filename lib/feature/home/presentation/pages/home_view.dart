
import 'package:flutter/material.dart';

import 'package:finora/core/constants/app_size.dart';
import 'package:finora/core/constants/app_string.dart';
import 'package:finora/core/theme/app_text_style.dart';

import 'package:finora/feature/transaction/presentation/pages/transaction_list_page.dart';
import 'package:finora/feature/categories/presentation/pages/category_list_page.dart';
import 'package:finora/feature/home/presentation/pages/more_page.dart';
import 'package:finora/feature/home/presentation/widgets/expence_overview.dart';

import '../widgets/balance_card.dart';
import '../widgets/quick_actions.dart';
import '../widgets/recent_transactions.dart';
import '../widgets/home_bottom_nav.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex == 0
          ? AppBar(
              title: Text(
                AppStrings.appName,
                style: AppTextStyles.title,
              ),
            )
          : null,

      body: IndexedStack(
        index: _currentIndex,
        children: [
          // Home
          SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.dashboardTitle,
                  style: AppTextStyles.heading,
                ),
                const SizedBox(height: AppSizes.spacingSm),
                Text(
                  AppStrings.dashboardSubtitle,
                  style: AppTextStyles.body,
                ),
                const SizedBox(height: AppSizes.spacingLg),
                const BalanceCard(),
                const SizedBox(height: AppSizes.spacingLg),
                const QuickActions(),
                const SizedBox(height: AppSizes.spacingLg),
                const ExpenseOverview(),
                const SizedBox(height: AppSizes.spacingLg),
                const RecentTransactions(),
                const SizedBox(height: AppSizes.spacingLg),
              ],
            ),
          ),

          // Transactions
          const TransactionListPage(),

          // Categories
          const CategoryListPage(),

          // More
          const MorePage(),
        ],
      ),

      bottomNavigationBar: HomeBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
