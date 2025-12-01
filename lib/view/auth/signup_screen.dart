import 'package:custom_widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notester/bloc/authBloc/auth_bloc.dart';
import 'package:notester/bloc/authBloc/auth_event.dart';
import 'package:notester/bloc/authBloc/auth_state.dart';
import 'package:notester/helpers/loading/loading_screen.dart';
import 'package:notester/services/auth_exceptions.dart';
import 'package:notester/utils/app_colors.dart';
import 'package:notester/utils/constants.dart';
import 'package:notester/utils/custom_text_style.dart';
import 'package:notester/utils/dialogs/error_dialog.dart';
import 'package:notester/view/route/routes.dart';
import 'package:notester/widgets/custom_text_enter_field.dart';
import 'package:notester/widgets/logo_widget.dart';
import 'package:notester/widgets/safe_area_header.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late ValueNotifier<bool> _obscureText;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  void toggle() {
    // Add your super logic here!
    _obscureText.value = !_obscureText.value;
  }

  @override
  void initState() {
    _obscureText = ValueNotifier<bool>(true);
    _passwordController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _obscureText.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeAreaHeader(
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
              if (state is AuthStateRegistering) {
                if (state.exception is EmailInUseAuthException) {
                  await showErrorDialog(context, "Email is already in use");
                } else if (state.exception is WrongPasswordAuthException) {
                  await showErrorDialog(context, "Wrong password");
                } else if (state.exception is GenericAuthException) {
                  await showErrorDialog(context, "Failed to register");
                }
              }

              if (state is AuthStateLoggedIn) {
                if (!context.mounted) return;
                Utilities.removeNamedStackActivity(context, Routes.notes);
              }
            },
            builder: (context, state) {
              if (state is AuthStateLoggedOut) {
                // Displaying the sign up form if the user is not authenticated

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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 2),
                            child: LogoWidget(height: 50.h),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 40, 10, 60),
                                child: Text("CREATE NEW ACCOUNT",
                                    style:
                                        Theme.of(context).textTheme.titleLarge),
                              ),
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 24, right: 24),
                                      child: CustomTextEnterField(
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        textEditingController: _nameController,
                                        label: Text("Full Name",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium),
                                        textInputType: TextInputType.text,
                                        fillColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        filled: true,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                        hintStyle:
                                            CustomTextStyle.hintTextLight,
                                        validator: (value) => validateField(
                                            context: context,
                                            value: value!,
                                            fieldName: "Name"),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 24, right: 24),
                                      child: CustomTextEnterField(
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        textEditingController: _emailController,
                                        label: Text("Email Address",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium),
                                        textInputType:
                                            TextInputType.emailAddress,
                                        fillColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        filled: true,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                        hintStyle:
                                            CustomTextStyle.hintTextLight,
                                        validator: (value) => validateEmail(
                                            context: context, value: value!),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 24, right: 24),
                                      child: CustomTextEnterField(
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        textEditingController: _phoneController,
                                        label: Text("Phone Number",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium),
                                        textInputType: TextInputType.phone,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                        hintStyle:
                                            CustomTextStyle.hintTextLight,
                                        fillColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        filled: true,
                                        validator: (value) => validateField(
                                            context: context,
                                            value: value!,
                                            fieldName: "Phone",
                                            maxCharacter: 10,
                                            minCharacter: 7),
                                        suffixIcon: const Icon(Icons.phone,
                                            color: AppColors.cDarkBlue),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 24, right: 24),
                                          child: ValueListenableBuilder(
                                            valueListenable: _obscureText,
                                            builder: (context, value, child) =>
                                                CustomTextEnterField(
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              textEditingController:
                                                  _passwordController,
                                              label: Text("Password",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                              textInputType:
                                                  TextInputType.visiblePassword,
                                              obscureText: _obscureText.value,
                                              hintStyle:
                                                  CustomTextStyle.hintTextLight,
                                              fillColor: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              filled: true,
                                              validator: (value) =>
                                                  validatePassword(
                                                      context: context,
                                                      value: value!),
                                              suffixIcon: _passwordController
                                                      .text.isEmpty
                                                  ? const SizedBox()
                                                  : IconButton(
                                                      onPressed: toggle,
                                                      icon: _obscureText.value
                                                          ? const Icon(
                                                              Icons.visibility,
                                                              color: AppColors
                                                                  .cDarkBlue)
                                                          : const Icon(
                                                              Icons
                                                                  .visibility_off,
                                                              color: AppColors
                                                                  .cDarkBlue),
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 60),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 24, right: 24),
                                child: CustomButton(
                                  title: "SIGN UP",
                                  elevation: 4,
                                  borderRadius: BorderRadius.circular(10),
                                  splashBorderRadius: BorderRadius.circular(10),
                                  buttonColor: Theme.of(context)
                                      .buttonTheme
                                      .colorScheme
                                      ?.primary,
                                  onPressed: () =>
                                      _createAccountWithEmailAndPassword(
                                          context),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 24, right: 24, top: 10),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: TextButton(
                                    onPressed: () {
                                      Utilities.closeActivity(context);
                                      // context.read<AuthBloc>().add(const AuthEventLogout());
                                    },
                                    child: Text(
                                      "Already registered? Sign In",
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
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  void _createAccountWithEmailAndPassword(context) {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      BlocProvider.of<AuthBloc>(context).add(
        AuthEventSignUp(
          _nameController.text,
          _emailController.text,
          _passwordController.text,
          _phoneController.text,
        ),
      );
    }
  }
}
