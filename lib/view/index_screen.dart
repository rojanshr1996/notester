import 'package:custom_widgets/custom_widgets.dart';
import 'package:notester/bloc/authBloc/auth_bloc.dart';
import 'package:notester/bloc/authBloc/auth_state.dart';
import 'package:notester/helpers/loading/loading_screen.dart';
import 'package:notester/model/model.dart';
import 'package:notester/provider/dark_theme_provider.dart';
import 'package:notester/services/auth_services.dart';
import 'package:notester/services/cloud/cloud_note.dart';
import 'package:notester/services/cloud/firebase_cloud_storage.dart';
import 'package:notester/services/fcm_services.dart';
import 'package:notester/utils/app_colors.dart';
import 'package:notester/utils/custom_text_style.dart';
import 'package:notester/utils/dialogs/close_app_dialog.dart';
import 'package:notester/view/auth/login_screen.dart';
import 'package:notester/view/route/routes.dart';
import 'package:notester/widgets/logo_widget.dart';
import 'package:notester/widgets/settings_user_header.dart';
import 'package:notester/widgets/simple_circular_loader.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class IndexScreen extends StatefulWidget {
  const IndexScreen({Key? key}) : super(key: key);

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  late final FirebaseCloudStorage _notesService;
  late FcmServices fcmServices;
  final AuthServices _auth = AuthServices();
  String? get userId => _auth.currentUser == null ? "" : _auth.currentUser!.id;

  @override
  void initState() {
    super.initState();
    _notesService = FirebaseCloudStorage();
    fcmServices = FcmServices();
    initFcmService();
  }

  initFcmService() {
    fcmServices.requestPermission();
    fcmServices.loadFCM();
    fcmServices.listenFCM();
    fcmServices.getToken();
    FirebaseMessaging.instance.subscribeToTopic("Reminders");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldExit = await showCloseAppDialog(context);
        if (shouldExit) {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
            child: LogoWidget(height: 35),
          ),
        ),
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.isLoading) {
              LoadingScreen().show(context: context, text: state.loadingText ?? "Please wait a moment");
            } else {
              LoadingScreen().hide();
            }

            if (state is AuthStateLoggedOut) {
              Utilities.removeStackActivity(context, const LoginScreen());
            }
          },
          builder: (context, state) {
            return Consumer<DarkThemeProvider>(
              builder: (context, value, child) {
                return SizedBox(
                  width: Utilities.screenWidth(context),
                  height: Utilities.screenHeight(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        StreamBuilder(
                          stream: _notesService.userData(ownerUserId: userId!),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                              case ConnectionState.active:
                                if (snapshot.hasData) {
                                  final userData = snapshot.data as Iterable<UserModel>;
                                  return userData.isEmpty
                                      ? const SizedBox()
                                      : SettingsUserHeader(
                                          userName: "${userData.first.name}",
                                          profilePic: userData.first.profileImage ?? "",
                                          onImageTap: () {
                                            Utilities.openNamedActivity(context, Routes.enlargeImage,
                                                arguments: ImageArgs(imageUrl: userData.first.profileImage ?? ""));
                                          },
                                          onPressed: () {
                                            Utilities.openNamedActivity(context, Routes.profile,
                                                arguments: userData.first);
                                          },
                                          onSettingsTap: () {
                                            Utilities.openNamedActivity(context, Routes.settings);
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
                        const SizedBox(height: 40),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 25, right: 25),
                            child: IndexButtons(
                              title: "VIEW NOTES",
                              prefixIcon: const Icon(Icons.note_rounded, size: 55, color: AppColors.cLightShade),
                              textStyle: CustomTextStyle.headerText.copyWith(color: AppColors.cLightShade),
                              borderRadius: BorderRadius.circular(15),
                              splashBorderRadius: BorderRadius.circular(15),
                              imagePath: value.darkTheme ? "assets/notesImage.png" : "assets/notesImageLight.png",
                              buttonColor: Theme.of(context).buttonTheme.colorScheme?.primary,
                              onPressed: () => Utilities.openNamedActivity(context, Routes.notes),
                            ),
                          ),
                        ),
                        // const SizedBox(height: 30),
                        // Expanded(
                        //   child: Padding(
                        //     padding: const EdgeInsets.only(left: 25, right: 25),
                        //     child: IndexButtons(
                        //       title: "VIEW POSTS",
                        //       prefixIcon: const Icon(Icons.file_copy_rounded, size: 55, color: AppColors.cLightShade),
                        //       textStyle: CustomTextStyle.headerText.copyWith(color: AppColors.cLightShade),
                        //       borderRadius: BorderRadius.circular(15),
                        //       splashBorderRadius: BorderRadius.circular(15),
                        //       imagePath: value.darkTheme ? "assets/postImage.png" : "assets/postImageLight.png",
                        //       buttonColor: AppColors.cDarkBlue,
                        //       shadowColor: AppColors.cDarkBlue,
                        //       onPressed: () => Utilities.openNamedActivity(context, Routes.post),
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class IndexButtons extends StatelessWidget {
  final String title;
  final Color? buttonColor;
  final TextStyle? textStyle;

  final VoidCallback? onPressed;
  final BorderRadiusGeometry? borderRadius;
  final BorderRadius? splashBorderRadius;
  final Widget? prefixIcon;
  final double? buttonWidth;
  final Color? shadowColor;
  final double elevation;
  final String imagePath;

  const IndexButtons({
    Key? key,
    required this.title,
    this.buttonColor,
    this.onPressed,
    this.textStyle = const TextStyle(color: AppColors.cDarkBlueLight),
    this.borderRadius,
    this.prefixIcon,
    this.splashBorderRadius,
    this.buttonWidth,
    this.elevation = 4.0,
    this.shadowColor,
    this.imagePath = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      color: buttonColor ?? ButtonTheme.of(context).colorScheme!.primary,
      borderRadius: borderRadius,
      shadowColor: shadowColor,
      child: InkWell(
        borderRadius: splashBorderRadius,
        highlightColor: Colors.transparent,
        onTap: onPressed,
        child: ClipRRect(
          borderRadius: splashBorderRadius,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
            ),
            width: buttonWidth ?? Utilities.screenWidth(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                prefixIcon == null
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.only(right: 12, left: 12),
                        child: prefixIcon,
                      ),
                const SizedBox(height: 8),
                CustomTextBorder(
                  text: title,
                  textStyle: textStyle,
                  textBorderColor: AppColors.cDarkBlue.withOpacity(0.7),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
