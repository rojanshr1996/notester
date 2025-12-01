import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final BoxFit? boxFit;
  final String? path;
  const LogoWidget(
      {super.key, this.height, this.width, this.boxFit, this.path});

  @override
  Widget build(BuildContext context) {
    // final themeProvider = context.watch<DarkThemeProvider>();
    return Image.asset(
      path ?? "assets/notesterLogoTransparent.png",
      height: height,
      width: width,
      fit: boxFit,
    );
  }
}
