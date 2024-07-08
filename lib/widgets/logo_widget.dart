import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final BoxFit? boxFit;
  const LogoWidget({Key? key, this.height, this.width, this.boxFit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final themeProvider = context.watch<DarkThemeProvider>();
    return Image.asset(
      "assets/notesterLogoTransparent.png",
      // themeProvider.darkTheme
      //     ? "assets/appLogo.png"
      //     : "assets/appLogoLight.png",
      height: height,
      width: width,
      fit: boxFit,
    );
  }
}
