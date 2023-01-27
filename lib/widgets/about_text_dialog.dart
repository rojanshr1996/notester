import 'package:flutter/material.dart';

class AboutTextDialog extends StatelessWidget {
  const AboutTextDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Notester",
              style: Theme.of(context).textTheme.displayLarge?.copyWith(height: 1.5),
            ),
            const SizedBox(height: 10),
            Text(
              "Notester is a simple note-taking application that makes it easy to take notes and access them from anywhere with an internet connection. If you're looking for a simple and efficient way to take notes, notester is the perfect tool for you. Notester is easy to use and can help you take notes quickly and easily. It's also perfect for taking notes on any topic. You can also add image and file to the notes. Plus, notester is free to use, so you can start taking notes today!",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
            )
          ],
        ),
      ),
    );
  }
}
