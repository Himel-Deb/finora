
import 'package:finora/feature/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:finora/core/constants/app_string.dart';
import 'package:finora/core/theme/app_theme.dart';

import 'package:finora/feature/auth/data/repositories/auth_repository_impl.dart';
import 'package:finora/feature/auth/domain/repositories/auth_repository.dart';
import 'package:finora/feature/auth/logic/bloc/auth_bloc.dart';
import 'package:finora/feature/auth/logic/event/auth_event.dart';

import 'package:finora/feature/transaction/data/repositories/transaction_repository_impl.dart';

class PaylanceApp extends StatelessWidget {
  const PaylanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => TransactionRepositoryImpl(),
        ),
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(),
        ),
      ],
      child: BlocProvider(
        create: (context) => AuthBloc(
          context.read<AuthRepository>(),
        )..add(CheckUserStatus()),
        child: MaterialApp(
          title: AppStrings.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}