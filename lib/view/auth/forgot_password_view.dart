import 'package:custom_widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notester/bloc/authBloc/auth_bloc.dart';
import 'package:notester/bloc/authBloc/auth_event.dart';
import 'package:notester/bloc/authBloc/auth_state.dart';
import 'package:notester/helpers/loading/loading_screen.dart';
import 'package:notester/utils/constants.dart';
import 'package:notester/utils/custom_text_style.dart';
import 'package:notester/utils/dialogs/error_dialog.dart';
import 'package:notester/utils/dialogs/password_reset_email_sent_dialog.dart';
import 'package:notester/view/route/routes.dart';
import 'package:notester/widgets/custom_text_enter_field.dart';
import 'package:notester/widgets/logo_widget.dart';
import 'package:notester/widgets/safe_area_header.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    _emailController.addListener(() {
      // setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Utilities.removeNamedStackActivity(context, Routes.login);
        return true;
      },
      child: SafeAreaHeader(
        child: RemoveFocus(
          child: Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            body: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) async {
                if (state.isLoading) {
                  LoadingScreen().show(
                      context: context,
                      text: state.loadingText ?? "Please wait a moment");
                } else {
                  LoadingScreen().hide();
                }
                if (state is AuthStateForgotPassword) {
                  if (state.hasSentEmail) {
                    showPasswordResetDialog(context).then((value) {
                      _emailController.clear();
                      Utilities.removeNamedStackActivity(context, Routes.login);
                    });
                  }
                  if (state.exception != null) {
                    await showErrorDialog(
                        context, "Password Reset failed. Please try again.");
                  }
                }
              },
              builder: (context, state) {
                return SizedBox(
                  height: Utilities.screenHeight(context),
                  width: Utilities.screenWidth(context),
                  child: Stack(
                    children: [
                      Positioned(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(15))),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            child: LogoWidget(height: 28),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 40, 10, 40),
                                child: Text(
                                  "FORGOT PASSWORD?",
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                              Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(30),
                                      child: Text(
                                        "If you forgot your password, enter your email and we will send you a password reset link.",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(fontWeight: medium),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 24, right: 24),
                                      child: Stack(
                                        children: [
                                          Container(
                                            height: 48,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .shadow,
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 3)),
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          CustomTextEnterField(
                                            textEditingController:
                                                _emailController,
                                            label: Text("Email Address",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium),
                                            textInputType:
                                                TextInputType.emailAddress,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                            hintStyle:
                                                CustomTextStyle.hintTextLight,
                                            validator: (value) => validateEmail(
                                                context: context,
                                                value: value!),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 60),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 30, right: 30),
                                child: CustomButton(
                                  title: "SEND RESET LINK",
                                  borderRadius: BorderRadius.circular(10),
                                  splashBorderRadius: BorderRadius.circular(10),
                                  buttonColor: Theme.of(context)
                                      .buttonTheme
                                      .colorScheme
                                      ?.primary,
                                  onPressed: () => _sendResetLink(context),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 24, right: 24, top: 10),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: TextButton(
                                    onPressed: () {
                                      // Utilities.closeActivity(context);

                                      Utilities.removeNamedStackActivity(
                                          context, Routes.login);
                                    },
                                    child: Text(
                                      "Go Back",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                              fontWeight: semibold),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _sendResetLink(context) {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      BlocProvider.of<AuthBloc>(context)
          .add(AuthEventForgotPassword(email: _emailController.text));
      // showPasswordResetDialog(context);
    }
  }
}
