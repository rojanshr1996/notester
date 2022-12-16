import 'package:notester/utils/dialogs/generic_dialog.dart';
import 'package:flutter/widgets.dart';

Future<bool> showCloseAppDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: "Exit Application",
    content: "Are you sure you want to exit the application?",
    optionsBuilder: () => {"Cancel": false, "Exit": true},
  ).then((value) => value ?? false);
}
