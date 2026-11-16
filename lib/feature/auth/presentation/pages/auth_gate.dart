
import 'package:finora/feature/auth/logic/state/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:finora/feature/auth/logic/bloc/auth_bloc.dart';
import 'package:finora/feature/auth/presentation/pages/login_page.dart';
import 'package:finora/feature/auth/presentation/pages/register_page.dart';
import 'package:finora/feature/home/presentation/pages/home_view.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        switch (state.status) {
          case AuthStatus.initial:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );

          case AuthStatus.loading:
            
            if (state.user != null) {
              return const LoginPage();
            }

            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );

          case AuthStatus.unregistered:
            return const RegisterPage();

          case AuthStatus.registered:
            return const LoginPage();

          case AuthStatus.authenticated:
            return HomeView();

          case AuthStatus.failure:
            return const LoginPage();
        }
      },
    );
  }
}
