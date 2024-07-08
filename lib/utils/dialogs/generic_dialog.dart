import 'package:custom_widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:notester/utils/constants.dart';

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder optionsBuilder,
}) {
  final options = optionsBuilder();

  return showDialog<T>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          title,
          style: Theme.of(context).textTheme.displayLarge,
        ),
        content: Text(
          content,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        actions: options.keys.map((optionTitle) {
          final T value = options[optionTitle];
          return TextButton(
            onPressed: () {
              if (value != null) {
                Utilities.returnDataCloseActivity(context, value);
              } else {
                Utilities.closeActivity(context);
              }
            },
            child: Text(
              optionTitle,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: medium),
            ),
          );
        }).toList(),
      );
    },
  );
}
