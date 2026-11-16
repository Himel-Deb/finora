import 'package:equatable/equatable.dart';
import 'package:finora/feature/auth/data/models/user_model.dart';

enum AuthStatus {
  initial,
  loading,
  registered,
  unregistered,
  authenticated,
  failure,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final UserModel? user;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        status,
        user,
        errorMessage,
      ];
}