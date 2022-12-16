import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

// When the user signing in with email and password this event is called and the [AuthServices] is called to sign in the user
class AuthEventLogin extends AuthEvent {
  final String email;
  final String password;

  const AuthEventLogin(this.email, this.password);
}

// When the user signing up with email and password this event is called and the [AuthServices] is called to sign up the user
class AuthEventSignUp extends AuthEvent {
  final String fullName;
  final String email;
  final String password;
  final String phone;

  const AuthEventSignUp(this.fullName, this.email, this.password, this.phone);
}

// When the user signing out this event is called and the [AuthServices] is called to sign out the user
class AuthEventLogout extends AuthEvent {
  const AuthEventLogout();
}

class AuthEventShouldRegister extends AuthEvent {
  const AuthEventShouldRegister();
}

class AuthEventSendEmailVerification extends AuthEvent {
  const AuthEventSendEmailVerification();
}

class AuthEventGoogleSignIn extends AuthEvent {
  const AuthEventGoogleSignIn();
}

class AuthEventForgotPassword extends AuthEvent {
  final String? email;
  const AuthEventForgotPassword({this.email});
}
