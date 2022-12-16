import 'package:notester/utils/dialogs/generic_dialog.dart';
import 'package:flutter/widgets.dart';

Future<void> showErrorDialog(BuildContext context, String text) {
  return showGenericDialog(
    context: context,
    title: "An error occured",
    content: text,
    optionsBuilder: () => {'Ok': null},
  );
}
