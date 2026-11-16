
import 'package:finora/feature/auth/logic/state/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:finora/feature/auth/domain/repositories/auth_repository.dart';
import 'package:finora/feature/auth/logic/event/auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(const AuthState()) {
    on<CheckUserStatus>(_checkUserStatus);
    on<RegisterRequested>(_register);
    on<LoginRequested>(_login);
    on<LogoutRequested>(_logout);
    on<UpdateProfileRequested>(_updateProfile);
  }

  Future<void> _checkUserStatus(
    CheckUserStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState(status: AuthStatus.loading));

    try {
      final user = await repository.getRegisteredUser();

      if (user != null) {
        emit(AuthState(
          status: AuthStatus.registered,
          user: user,
        ));
      } else {
        emit(const AuthState(
          status: AuthStatus.unregistered,
        ));
      }
    } catch (e) {
      emit(const AuthState(
        status: AuthStatus.unregistered,
        errorMessage: 'Unable to load user',
      ));
    }
  }

  Future<void> _register(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState(status: AuthStatus.loading));

    try {
      final user = await repository.register(
        name: event.name,
        email: event.email,
        password: event.password,
      );

      emit(AuthState(
        status: AuthStatus.authenticated,
        user: user,
      ));
    } catch (e) {
      emit(AuthState(
        status: AuthStatus.unregistered,
        errorMessage: 'Registration failed',
      ));
    }
  }

  Future<void> _login(
  LoginRequested event,
  Emitter<AuthState> emit,
) async {
  final currentUser = state.user;

  emit(AuthState(
    status: AuthStatus.loading,
    user: currentUser,
  ));

  try {
    final user = await repository.login(
      email: event.email,
      password: event.password,
    );

    if (user != null) {
      emit(AuthState(
        status: AuthStatus.authenticated,
        user: user,
      ));
    } else {
      emit(AuthState(
        status: AuthStatus.registered,
        user: currentUser,
        errorMessage: 'Invalid email or password',
      ));
    }
  } catch (e) {
    emit(AuthState(
      status: AuthStatus.registered,
      user: currentUser,
      errorMessage: 'Login failed. Please try again.',
    ));
  }
}

  void _logout(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) {
    emit(AuthState(
      status: AuthStatus.registered,
      user: state.user,
    ));
  }

  Future<void> _updateProfile(
  UpdateProfileRequested event,
  Emitter<AuthState> emit,
) async {
  final currentUser = state.user;

  if (currentUser == null) {
    emit(const AuthState(
      status: AuthStatus.failure,
      errorMessage: 'User not found',
    ));
    return;
  }

  try {
    final updatedUser = currentUser.copyWith(
      name: event.name,
      email: event.email,
      photoPath: event.photoPath,
    );

    await repository.updateUser(updatedUser);

    emit(AuthState(
      status: AuthStatus.authenticated,
      user: updatedUser,
    ));
  } catch (e) {
    emit(AuthState(
      status: AuthStatus.authenticated,
      user: currentUser,
      errorMessage: 'Profile update failed: $e',
    ));
  }
}
}
