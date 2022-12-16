import 'package:notester/provider/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LogoWidget extends StatelessWidget {
  final double? height;
  final double? width;
  const LogoWidget({Key? key, this.height, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<DarkThemeProvider>();
    return Image.asset(
      themeProvider.darkTheme ? "assets/appLogo.png" : "assets/appLogoLight.png",
      height: height,
      width: width,
    );
  }
}
