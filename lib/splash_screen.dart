import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:custom_widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notester/bloc/app_update_bloc/app_update_bloc.dart';
import 'package:notester/core/service_locator.dart';
import 'package:notester/services/notester_remote_config_service.dart';
import 'package:notester/utils/app_colors.dart';
import 'package:notester/utils/utils.dart';
import 'package:notester/view/route/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isAuthenticated = false;
  bool isNewerVersion = true;

  showAppUpdateStatus(BuildContext context) async {
    final appUpdateBloc = BlocProvider.of<AppUpdateBloc>(context);
    final appVersion = getIt.get<NotesterPackageInfo>().version;
    final appMinVersion = NotesterRemoteConfigService().getAppMinimumVersion();
    log('APP VERSION: $appVersion --> $appMinVersion');

    if (appUpdateBloc.state.showUpdateDialog == true) {
      await Future.delayed(const Duration(milliseconds: 500));

      if (Platform.isAndroid) {
        isNewerVersion = Utils.isNewerVersion(
            appVersion, appMinVersion.androidRequiredMinVersion);
      } else if (Platform.isIOS) {
        isNewerVersion = Utils.isNewerVersion(
            appVersion, appMinVersion.iosRequiredMinVersion);
      }

      log('IS NEWER VERSION: $isNewerVersion');
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      showAppUpdateStatus(context);
      navigate(context);
    });
  }

  navigate(BuildContext context) async {
    Future.delayed((const Duration(seconds: 1)), () {
      if (mounted) {
        if (isNewerVersion) {
          // Show update screen
          Utilities.removeNamedStackActivity(context, Routes.login);
        } else {
          Utilities.removeNamedStackActivity(context, Routes.appUpdateScreen);
        }
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
                  height: constraints.maxHeight * 0.4,
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
