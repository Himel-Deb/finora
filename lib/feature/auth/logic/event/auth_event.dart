import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckUserStatus extends AuthEvent {}

class RegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;

  const RegisterRequested({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, email, password];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class LogoutRequested extends AuthEvent {}


class UpdateProfileRequested extends AuthEvent {
  final String name;
  final String email;
  final String? photoPath;

  const UpdateProfileRequested({
    required this.name,
    required this.email,
    this.photoPath,
  });

  @override
  List<Object?> get props => [name, email, photoPath];
}