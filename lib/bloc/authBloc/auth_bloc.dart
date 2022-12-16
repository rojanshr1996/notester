import 'package:notester/bloc/authBloc/auth_event.dart';
import 'package:notester/bloc/authBloc/auth_state.dart';
import 'package:notester/services/auth_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthServices authServices;

  AuthBloc({required this.authServices}) : super(const AuthStateUninitialized(isLoading: true)) {
    // Initialize
    on<AuthEventInitialize>((event, emit) async {
      final user = authServices.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification(isLoading: false));
      } else {
        emit(AuthStateLoggedIn(user: user, isLoading: false));
      }
    });

    // When User Presses the SignIn Button, we will send the SignInRequested Event to the AuthBloc to handle it and emit the Authenticated State if the user is authenticated
    on<AuthEventLogin>((event, emit) async {
      emit(const AuthStateLoggedOut(exception: null, isLoading: true));
      try {
        final user = await authServices.signIn(email: event.email, password: event.password);

        if (!user!.isEmailVerified) {
          emit(const AuthStateLoggedOut(exception: null, isLoading: false));
          emit(const AuthStateNeedsVerification(isLoading: false));
        } else {
          emit(const AuthStateLoggedOut(exception: null, isLoading: false));
          emit(AuthStateLoggedIn(user: user, isLoading: false));
        }
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e, isLoading: false, loadingText: "Please wait while I log you in"));
        // emit(const AuthStateLoggedOut());
      }
    });

    // When User Presses the SignUp Button, we will send the SignUpRequest Event to the AuthBloc to handle it and emit the Authenticated State if the user is authenticated
    on<AuthEventSignUp>((event, emit) async {
      emit(const AuthStateLoggedOut(exception: null, isLoading: true));
      try {
        await authServices.signUp(
            email: event.email, password: event.password, fullName: event.fullName, phoneNumber: event.phone);
        authServices.sendEmailVerification();
        emit(const AuthStateNeedsVerification(isLoading: false));
        // emit(AuthStateLoggedIn(user: result, isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateRegistering(exception: e, isLoading: false));
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
        // emit(const AuthStateLoggedOut());
      }
    });

    // When User Presses the SignOut Button, we will send the SignOutRequested Event to the AuthBloc to handle it and emit the UnAuthenticated State
    on<AuthEventLogout>((event, emit) async {
      try {
        if (authServices.currentUser != null) {
          emit(AuthStateLoggedIn(user: authServices.currentUser!, isLoading: true));
        }
        await authServices.signOut();
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e, isLoading: false));
      }
    });

    on<AuthEventSendEmailVerification>((event, emit) async {
      emit(const AuthStateLoading(isLoading: false));
      try {
        await authServices.sendEmailVerification();
        emit(state);
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e, isLoading: false));
      }
    });

    on<AuthEventForgotPassword>((event, emit) async {
      emit(const AuthStateLoggedOut(exception: null, isLoading: true));

      final email = event.email;
      if (email == null) {
        return; // user just wants to go to forgot password screen
      }

      emit(const AuthStateForgotPassword(exception: null, hasSentEmail: false, isLoading: true));
      bool didSendEmail;
      Exception? exception;
      try {
        emit(const AuthStateForgotPassword(exception: null, hasSentEmail: false, isLoading: false));

        await authServices.sendPasswordReset(email: email);
        didSendEmail = true;
        exception = null;
        emit(AuthStateForgotPassword(exception: exception, hasSentEmail: didSendEmail, isLoading: false));
      } on Exception catch (e) {
        didSendEmail = false;
        exception = e;
        emit(AuthStateForgotPassword(exception: exception, hasSentEmail: didSendEmail, isLoading: false));
      }
    });

    on<AuthEventGoogleSignIn>((event, emit) async {
      emit(const AuthStateLoggedOut(exception: null, isLoading: true));
      try {
        final user = await authServices.googleLogIn();

        if (user != null) {
          if (!user.isEmailVerified) {
            emit(const AuthStateLoggedOut(exception: null, isLoading: false));
            emit(const AuthStateNeedsVerification(isLoading: false));
          } else {
            emit(const AuthStateLoggedOut(exception: null, isLoading: false));
            emit(AuthStateLoggedIn(user: user, isLoading: false));
          }
        }
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e, isLoading: false));
      }
    });
  }
}
