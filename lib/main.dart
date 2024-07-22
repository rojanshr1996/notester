import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notester/bloc/app_update_bloc/app_update_bloc.dart';
import 'package:notester/bloc/authBloc/auth_bloc.dart';
import 'package:notester/core/service_locator.dart';
import 'package:notester/provider/dark_theme_provider.dart';
import 'package:notester/services/auth_services.dart';
import 'package:notester/services/fcm_services.dart';
import 'package:notester/services/notester_remote_config_service.dart';
import 'package:notester/utils/app_colors.dart';
import 'package:notester/view/route/app_router.dart';
import 'package:notester/view/route/routes.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    initServiceLocator();
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await NotesterRemoteConfigService.initialize();
    await getIt.get<NotesterPackageInfo>().initialize();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
    runApp(const MyApp());
  }, (error, stackTrace) {
    log('This is a pure Dart error: $error --> $stackTrace');
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthServices()),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => themeChangeProvider),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AuthBloc(
                authServices: RepositoryProvider.of<AuthServices>(context),
              ),
            ),
            BlocProvider(create: (context) => AppUpdateBloc()),
          ],
          child: Consumer<DarkThemeProvider>(
            builder: (context, value, child) {
              return ScreenUtilInit(
                designSize: const Size(450, 962),
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Notester',
                  onGenerateRoute: AppRouter.onGenerateRoute,
                  themeMode: value.darkTheme ? ThemeMode.dark : ThemeMode.light,
                  theme: value.darkTheme
                      ? ThemeClass.darkTheme
                      : ThemeClass.lightTheme,
                  darkTheme: value.darkTheme
                      ? ThemeClass.darkTheme
                      : ThemeClass.darkTheme,
                  initialRoute: Routes.splash,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
