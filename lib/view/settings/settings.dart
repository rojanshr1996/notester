import 'dart:developer';

import 'package:custom_widgets/custom_widgets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notester/bloc/authBloc/auth_bloc.dart';
import 'package:notester/bloc/authBloc/auth_event.dart';
import 'package:notester/bloc/authBloc/auth_state.dart';
import 'package:notester/core/service_locator.dart';
import 'package:notester/model/model.dart';
import 'package:notester/provider/dark_theme_provider.dart';
import 'package:notester/services/auth_services.dart';
import 'package:notester/services/cloud/cloud_note.dart';
import 'package:notester/services/cloud/firebase_cloud_storage.dart';
import 'package:notester/services/notester_remote_config_service.dart';
import 'package:notester/utils/constants.dart';
import 'package:notester/utils/dialogs/logout_dialog.dart';
import 'package:notester/view/auth/login_screen.dart';
import 'package:notester/view/route/routes.dart';
import 'package:notester/widgets/about_text_dialog.dart';
import 'package:notester/widgets/logo_widget.dart';
import 'package:notester/widgets/settings_user_header.dart';
import 'package:notester/widgets/simple_circular_loader.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _light = false;
  late final FirebaseCloudStorage _notesService;
  final AuthServices _auth = AuthServices();
  String? get userId => _auth.currentUser == null ? "" : _auth.currentUser!.id;

  onToggleDarkMode(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context, listen: false);

    setState(() {
      _light = !_light;
    });

    themeChange.darkTheme = _light;
  }

  @override
  void initState() {
    super.initState();
    _notesService = FirebaseCloudStorage();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final appVersion = getIt.get<NotesterPackageInfo>().versionWithoutBuild;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 4,
        shadowColor: Theme.of(context).colorScheme.shadow,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Settings"),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthStateLoggedOut) {
            Utilities.removeStackActivity(context, const LoginScreen());
          }
        },
        builder: (context, state) {
          return SizedBox(
            height: Utilities.screenHeight(context),
            width: Utilities.screenWidth(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          StreamBuilder(
                            stream:
                                _notesService.userData(ownerUserId: userId!),
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                case ConnectionState.active:
                                  if (snapshot.hasData) {
                                    final userData =
                                        snapshot.data as Iterable<UserModel>;
                                    return userData.isEmpty
                                        ? const SizedBox()
                                        : SettingsUserHeader(
                                            userName: "${userData.first.name}",
                                            profilePic:
                                                userData.first.profileImage ??
                                                    "",
                                            onImageTap: () {
                                              Utilities.openNamedActivity(
                                                  context, Routes.enlargeImage,
                                                  arguments: ImageArgs(
                                                      imageUrl: userData.first
                                                              .profileImage ??
                                                          ""));
                                            },
                                            onPressed: () {
                                              Utilities.openNamedActivity(
                                                  context, Routes.profile,
                                                  arguments: userData.first);
                                            },
                                            onSettingsTap: () {
                                              Utilities.openNamedActivity(
                                                  context, Routes.settings);
                                            },
                                          );
                                  } else {
                                    return const SizedBox(
                                      height: 70,
                                      width: 70,
                                    );
                                  }

                                default:
                                  return const Center(
                                    child: SimpleCircularLoader(),
                                  );
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(15)),
                            child: ListTile(
                              leading: Icon(
                                themeChange.darkTheme
                                    ? Icons.dark_mode
                                    : Icons.light_mode,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              onTap: () => onToggleDarkMode(context),
                              title: Text(
                                "Dark Mode",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              trailing: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Switch(
                                    value: themeChange.darkTheme,
                                    onChanged: (value) {
                                      themeChange.darkTheme = value;
                                    },
                                    activeThumbColor:
                                        Theme.of(context).colorScheme.surface,
                                  )),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(15)),
                            child: ListTile(
                              leading: Icon(
                                Icons.info_outline,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (_) {
                                    return const AboutTextDialog();
                                  },
                                );
                              },
                              title: Text(
                                "About",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(15)),
                            child: ListTile(
                              leading: Icon(
                                Icons.help_outline,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              onTap: () {
                                Utilities.openNamedActivity(
                                    context, Routes.help);
                              },
                              title: Text(
                                "Help & Support",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(15)),
                            child: ListTile(
                              leading: Icon(
                                Icons.privacy_tip_outlined,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              onTap: () {
                                openPrivacyPolicy(url: privacyPolicyUrl);
                              },
                              title: Text(
                                "Privacy Policy",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(15)),
                            child: ListTile(
                              leading: Icon(
                                Icons.file_copy_outlined,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              onTap: () {
                                openPrivacyPolicy(url: termsUrl);
                              },
                              title: Text(
                                "Terms and Condition",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(15)),
                            child: ListTile(
                              leading: Icon(
                                Icons.logout,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              onTap: () async {
                                final shouldLogOut =
                                    await showLogoutDialog(context);
                                log(shouldLogOut.toString());
                                if (shouldLogOut) {
                                  final sharedPreferences =
                                      await SharedPreferences.getInstance();
                                  sharedPreferences.setBool(
                                      "notificationSent", false);
                                  FirebaseMessaging.instance
                                      .unsubscribeFromTopic("Reminders");
                                  if (!context.mounted) return;
                                  BlocProvider.of<AuthBloc>(context)
                                      .add(const AuthEventLogout());
                                }
                              },
                              title: Text(
                                "Logout",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15))),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      leading: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: LogoWidget(
                          path: "assets/notesterIcon.png",
                          width: 50,
                          boxFit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        appName.toUpperCase(),
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: Theme.of(context).hintColor),
                      ),
                      subtitle: Text(
                        "Version $appVersion",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Theme.of(context).hintColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> openPrivacyPolicy({required String url}) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }
}
