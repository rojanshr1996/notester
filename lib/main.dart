import 'package:notester/bloc/authBloc/auth_bloc.dart';
import 'package:notester/provider/dark_theme_provider.dart';
import 'package:notester/services/auth_services.dart';
import 'package:notester/services/fcm_services.dart';
import 'package:notester/utils/app_colors.dart';
import 'package:notester/view/route/app_router.dart';
import 'package:notester/view/route/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
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
    themeChangeProvider.darkTheme = await themeChangeProvider.darkThemePreference.getTheme();
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
            BlocProvider(create: (context) => AuthBloc(authServices: RepositoryProvider.of<AuthServices>(context)))
          ],
          child: Consumer<DarkThemeProvider>(
            builder: (context, value, child) {
              return MaterialApp(
                useInheritedMediaQuery: true,
                debugShowCheckedModeBanner: false,
                title: 'Notester',
                onGenerateRoute: AppRouter.onGenerateRoute,
                themeMode: value.darkTheme ? ThemeMode.dark : ThemeMode.light,
                theme: value.darkTheme ? ThemeClass.darkTheme : ThemeClass.lightTheme,
                darkTheme: value.darkTheme ? ThemeClass.darkTheme : ThemeClass.darkTheme,
                initialRoute: Routes.splash,
              );
            },
          ),
        ),
      ),
    );
  }
}
