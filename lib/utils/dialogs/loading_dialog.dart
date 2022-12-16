// import 'package:custom_widgets/custom_widgets.dart';
// import 'package:notester/widgets/simple_circular_loader.dart';
// import 'package:flutter/material.dart';

// typedef CloseDialog = void Function();

// CloseDialog showLoadingDialog({required BuildContext context, required String text}) {
//   final dialog = AlertDialog(
//     content: Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         const SimpleCircularLoader(),
//         const SizedBox(height: 10),
//         Text(text),
//       ],
//     ),
//   );

//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (context) => dialog,
//   );

//   return () => Utilities.closeActivity(context);
// }
