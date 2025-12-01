import 'dart:developer';

import 'package:custom_widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:notester/utils/app_colors.dart';
import 'package:notester/utils/constants.dart';
import 'package:notester/utils/custom_text_style.dart';
import 'package:notester/widgets/custom_text_enter_field.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  HelpScreenState createState() => HelpScreenState();
}

class HelpScreenState extends State<HelpScreen> {
  final TextEditingController _helpController = TextEditingController();

  @override
  void dispose() {
    _helpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RemoveFocus(
      child: Scaffold(
        appBar: AppBar(
          elevation: 4,
          shadowColor: Theme.of(context).colorScheme.shadow,
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text("Help & Support"),
        ),
        body: SizedBox(
          height: Utilities.screenHeight(context),
          width: Utilities.screenWidth(context),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        children: [
                          const SizedBox(height: 50),
                          ListTile(
                            title: Text(
                              "Need some help?",
                              style: Theme.of(context).textTheme.displayLarge,
                              textAlign: TextAlign.center,
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Text(
                                "Send us your queries and we will try to get back to you as soon as possible. Thank You!",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                        color: AppColors.cGrey,
                                        fontWeight: medium),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          const SizedBox(height: 35),
                          Padding(
                            padding: const EdgeInsets.only(left: 12, right: 12),
                            child: Stack(
                              children: [
                                Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .shadow,
                                          blurRadius: 8,
                                          offset: const Offset(0, 3)),
                                    ],
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                                CustomTextEnterField(
                                  textEditingController: _helpController,
                                  label: Text("How can we help you?",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                  textInputType: TextInputType.emailAddress,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  hintStyle: CustomTextStyle.hintTextLight,
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.cBlueShade)),
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                  disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(0)),
                                  focusedErrorBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.cRedAccent)),
                                  errorBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.cRedAccent)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: CustomButton(
                    title: "SUBMIT",
                    borderRadius: BorderRadius.circular(5),
                    buttonColor: Theme.of(context).colorScheme.primary,
                    onPressed: () {
                      if (_helpController.text.isNotEmpty) {
                        send();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> send() async {
    final Email email = Email(
      body: _helpController.text,
      subject: "Help with the app",
      recipients: ["rojan.shr1996@gmail.com"],
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      log(error.toString());
    }

    if (!mounted) return;
  }
}
