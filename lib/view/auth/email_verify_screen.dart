import 'dart:developer' as devtools show log;

import 'package:custom_widgets/custom_widgets.dart';
import 'package:notester/bloc/authBloc/auth_bloc.dart';
import 'package:notester/bloc/authBloc/auth_event.dart';
import 'package:notester/bloc/authBloc/auth_state.dart';
import 'package:notester/utils/app_colors.dart';
import 'package:notester/view/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmailVerifyScreen extends StatelessWidget {
  const EmailVerifyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    devtools.log("${FirebaseAuth.instance.currentUser}");
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text((FirebaseAuth.instance.currentUser?.emailVerified ?? false) ? "Welcome" : ""),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthStateLoggedOut) {
            Utilities.removeStackActivity(context, const LoginScreen());
          }
        },
        builder: (context, state) {
          // debugPrint("$state");

          return SizedBox(
            width: Utilities.screenWidth(context),
            height: Utilities.screenHeight(context),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 70,
                    width: 70,
                    decoration: const BoxDecoration(color: AppColors.cDarkBlue, shape: BoxShape.circle),
                    child: const Icon(
                      Icons.person_outline_outlined,
                      color: AppColors.cDarkBlueLight,
                      size: 38,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    FirebaseAuth.instance.currentUser == null ? "" : " ${FirebaseAuth.instance.currentUser!.email}",
                    style: Theme.of(context).textTheme.titleSmall,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "Email verification link has been sent to you email. Please verify and confirm",
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: CustomButton(
                      title: "Confirm",
                      borderRadius: BorderRadius.circular(5),
                      splashBorderRadius: BorderRadius.circular(5),
                      buttonColor: Theme.of(context).buttonTheme.colorScheme?.primary,
                      // onPressed: () => _sendEmailVerification(context),
                      onPressed: () {
                        BlocProvider.of<AuthBloc>(context).add(const AuthEventLogout());
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  OutlinedButton(
                    onPressed: () => _sendEmailVerification(context),
                    child: Text(
                      "Resend Link",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Theme.of(context).colorScheme.background),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _sendEmailVerification(context) {
    BlocProvider.of<AuthBloc>(context).add(const AuthEventSendEmailVerification());
  }
}

class IndexButtons extends StatelessWidget {
  final String title;
  final Color? buttonColor;
  final TextStyle? textStyle;

  final VoidCallback? onPressed;
  final BorderRadiusGeometry? borderRadius;
  final BorderRadius? splashBorderRadius;
  final Widget? prefixIcon;
  final double? buttonWidth;
  final Color? shadowColor;
  final double elevation;
  final String imagePath;

  const IndexButtons({
    Key? key,
    required this.title,
    this.buttonColor,
    this.onPressed,
    this.textStyle = const TextStyle(color: AppColors.cDarkBlueLight),
    this.borderRadius,
    this.prefixIcon,
    this.splashBorderRadius,
    this.buttonWidth,
    this.elevation = 2.0,
    this.shadowColor,
    this.imagePath = "assets/notesImage.png",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      color: buttonColor ?? ButtonTheme.of(context).colorScheme!.primary,
      borderRadius: borderRadius,
      shadowColor: shadowColor,
      child: InkWell(
        borderRadius: splashBorderRadius,
        highlightColor: Colors.transparent,
        onTap: onPressed,
        child: ClipRRect(
          borderRadius: splashBorderRadius,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
            ),
            width: buttonWidth ?? Utilities.screenWidth(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                prefixIcon == null
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.only(right: 12, left: 12),
                        child: prefixIcon,
                      ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: textStyle,
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
