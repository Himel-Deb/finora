
import 'package:finora/core/constants/app_size.dart';
import 'package:finora/core/constants/app_string.dart';
import 'package:finora/core/theme/app_text_style.dart';
import 'package:finora/core/widgets/primary_button.dart';
import 'package:finora/feature/home/presentation/pages/home_view.dart';
import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/app_colors.dart';


class PaylanceApp extends StatelessWidget {
  const PaylanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
       home: HomeView(),
      // Scaffold(
      //   body: Center(
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         const Icon(
      //           Icons.account_balance_wallet_rounded,
      //           size: 72,
      //           color: AppColors.primary,
      //         ),
      //         Text(
      //           AppStrings.appName,
      //           style: AppTextStyles.heading,
      //         ),
      //         const SizedBox(height: 8),
      //         Text(
      //           AppStrings.appTagline,
      //           style: AppTextStyles.caption,
      //         ),

      //          SizedBox(height: AppSizes.spacingLg),

      //         PrimaryButton(
      //           text: AppStrings.getStarted, 
      //         onPressed: (){
      //           debugPrint("get started button click");
      //         }
              
      //         )
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
