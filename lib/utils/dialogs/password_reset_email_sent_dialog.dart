import 'package:notester/utils/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showPasswordResetDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: "Password Reset",
    content: "We have sent a password reset link in your email. Please check for more information.",
    optionsBuilder: () => {"OK": null},
  );
}
