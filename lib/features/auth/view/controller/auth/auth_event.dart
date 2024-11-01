part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AuthInitialEvent extends AuthEvent {}

class SignInEvent extends AuthEvent {
  SignInEvent({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}

class SignUpEvent extends AuthEvent {
  SignUpEvent({
    required this.email,
    required this.password,
    required this.name,
  });

  final String email;
  final String password;
  final String name;
}

class SignOutEvent extends AuthEvent {}

class GetCurrentUserSessionEvent extends AuthEvent {}
