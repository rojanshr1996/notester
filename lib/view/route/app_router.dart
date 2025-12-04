import 'package:flutter/material.dart';
import 'package:notester/app_update_screen.dart';
import 'package:notester/model/model.dart';
import 'package:notester/services/cloud/cloud_note.dart';
import 'package:notester/splash_screen.dart';
import 'package:notester/view/auth/email_verify_screen.dart';
import 'package:notester/view/auth/forgot_password_view.dart';
import 'package:notester/view/auth/login_screen.dart';
import 'package:notester/view/auth/signup_screen.dart';
import 'package:notester/view/checklists/checklists_screen.dart';
import 'package:notester/view/notes/create_update_notes_view.dart';
import 'package:notester/view/scratchpad/scratchpad_screen.dart';
import 'package:notester/view/notes/notes_screen.dart';
import 'package:notester/view/notes/pdf_viewer_screen.dart';
import 'package:notester/view/profile/profile_screen.dart';
import 'package:notester/view/route/routes.dart';
import 'package:notester/view/settings/help_screen.dart';
import 'package:notester/view/settings/settings.dart';
import 'package:notester/widgets/enlarge_image.dart';

class AppRouter {
  AppRouter._();
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case Routes.appUpdateScreen:
        return MaterialPageRoute(builder: (_) {
          return const AppUpdateScreen();
        });

      case Routes.login:
        return MaterialPageRoute(
            builder: (_) => LoginScreen(message: (args is String ? args : "")));

      case Routes.register:
        return MaterialPageRoute(builder: (_) => const SignupScreen());

      case Routes.notes:
        return MaterialPageRoute(builder: (_) => const NotesScreen());

      case Routes.checklists:
        return MaterialPageRoute(builder: (_) => const ChecklistsScreen());

      case Routes.scratchpad:
        return MaterialPageRoute(builder: (_) => const ScratchpadScreen());

      case Routes.verifyEmail:
        return MaterialPageRoute(builder: (_) => const EmailVerifyScreen());

      case Routes.settings:
        return MaterialPageRoute(builder: (_) => const Settings());

      case Routes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordView());

      case Routes.createUpdateNote:
        if (args is CloudNote) {
          return MaterialPageRoute(
              builder: (_) => CreateUpdateNoteView(note: args));
        } else {
          return MaterialPageRoute(
              builder: (_) => const CreateUpdateNoteView());
        }
      // case Routes.createUpdateNote:
      //   if (args is CloudNote) {
      //     return MaterialPageRoute(builder: (_) => CreateUpdateNotesScreen(note: args));
      //   } else {
      //     return MaterialPageRoute(builder: (_) => const CreateUpdateNotesScreen());
      //   }

      case Routes.pdfView:
        if (args is Args) {
          return MaterialPageRoute(
              builder: (_) => PdfViewerScreen(arguments: args));
        }
        return errorRoute(settings);

      case Routes.enlargeImage:
        if (args is ImageArgs) {
          return MaterialPageRoute(
              builder: (context) => EnlargeImage(imageArgs: args));
        }
        return errorRoute(settings);

      case Routes.notesImage:
        if (args is ImageArgs) {
          return MaterialPageRoute(
              builder: (_) => EnlargeImage(imageArgs: args));
        }
        return errorRoute(settings);

      case Routes.profile:
        if (args is UserModel) {
          return MaterialPageRoute(
              builder: (_) => ProfileScreen(profileData: args));
        } else {
          return MaterialPageRoute(builder: (_) => const ProfileScreen());
        }

      case Routes.help:
        return MaterialPageRoute(builder: (_) => const HelpScreen());

      default:
        return errorRoute(settings);
    }
  }

  static Route<dynamic> errorRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text('No Route defined for ${settings.name}'),
        ),
      ),
    );
  }
}
