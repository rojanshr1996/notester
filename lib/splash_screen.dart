import 'dart:async';

import 'package:custom_widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:notester/utils/app_colors.dart';
import 'package:notester/view/route/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isAuthenticated = false;
  @override
  void initState() {
    super.initState();
    Future.delayed((const Duration(seconds: 1)), () {
      if (mounted) {
        Utilities.removeNamedStackActivity(context, Routes.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cDarkBlueAccent,
      body: LayoutBuilder(builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Image.asset(
                  'assets/notesterLogoTransparent.png',
                  height: constraints.maxHeight * 0.5,
                  fit: BoxFit.fitHeight,
                  filterQuality: FilterQuality.none,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
