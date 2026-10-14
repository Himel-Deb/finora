
import 'package:finora/feature/home/presentation/widgets/expence_overview.dart';
import 'package:flutter/material.dart';

import 'package:finora/core/constants/app_size.dart';
import 'package:finora/core/constants/app_string.dart';
import 'package:finora/core/theme/app_text_style.dart';

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
      appBar: AppBar(
        title: Text(
          AppStrings.appName,
          style: AppTextStyles.title,
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(
          AppSizes.spacingMd,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.dashboardTitle,
              style: AppTextStyles.heading,
            ),

            const SizedBox(
              height: AppSizes.spacingSm,
            ),

            Text(
              AppStrings.dashboardSubtitle,
              style: AppTextStyles.body,
            ),

            const SizedBox(
              height: AppSizes.spacingLg,
            ),

            const BalanceCard(),

            const SizedBox(
              height: AppSizes.spacingLg,
            ),

            const QuickActions(),

            const SizedBox(
              height: AppSizes.spacingLg,
            ),

            const ExpenseOverview(),

            const SizedBox(
              height: AppSizes.spacingLg,
            ),

            const RecentTransactions(),

            const SizedBox(
              height: AppSizes.spacingLg,
            ),
          ],
        ),
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
