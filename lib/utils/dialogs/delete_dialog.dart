import 'package:notester/utils/dialogs/generic_dialog.dart';
import 'package:flutter/widgets.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: "Delete",
    content: "Are you sure you want to delete this item?",
    optionsBuilder: () => {"Cancel": false, "Yes": true},
  ).then((value) => value ?? false);
}
