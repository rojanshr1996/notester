import 'package:notester/model/auth_user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AuthState extends Equatable {
  final bool isLoading;
  final String? loadingText;
  const AuthState({required this.isLoading, this.loadingText});

  @override
  List<Object?> get props => [];
}

// When the user presses the signin or signup button the state is changed to loading first and then to Authenticated.
class AuthStateLoading extends AuthState {
  const AuthStateLoading({required bool isLoading})
      : super(isLoading: isLoading);
  @override
  List<Object?> get props => [];
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized({required bool isLoading})
      : super(isLoading: isLoading);
  @override
  List<Object?> get props => [];
}

// When the user is authenticated the state is changed to Authenticated.
class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn({required bool isLoading, required this.user})
      : super(isLoading: isLoading);

  @override
  List<Object?> get props => [];
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification({required bool isLoading})
      : super(isLoading: isLoading);

  @override
  List<Object?> get props => [];
}

class AuthStateLoggedOut extends AuthState {
  final Exception? exception;

  const AuthStateLoggedOut(
      {required this.exception, required bool isLoading, String? loadingText})
      : super(isLoading: isLoading, loadingText: loadingText);

  @override
  List<Object?> get props => [exception, isLoading];
}

class AuthStateRegistering extends AuthState {
  final Exception exception;

  const AuthStateRegistering({required bool isLoading, required this.exception})
      : super(isLoading: isLoading);
  @override
  List<Object?> get props => [];
}

class AuthStateForgotPassword extends AuthState with EquatableMixin {
  final Exception? exception;
  final bool hasSentEmail;

  const AuthStateForgotPassword(
      {required bool isLoading,
      required this.exception,
      required this.hasSentEmail})
      : super(isLoading: isLoading);
  @override
  List<Object?> get props => [exception, isLoading, hasSentEmail];
}
