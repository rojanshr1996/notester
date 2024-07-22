import 'package:custom_widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notester/utils/constants.dart';
import 'package:notester/utils/utils.dart';
import 'package:notester/widgets/logo_widget.dart';
import 'package:notester/widgets/text_header.dart';

class AppUpdateScreen extends StatelessWidget {
  const AppUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraint) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LogoWidget(height: 150.h),
                  20.verticalSpace,
                  TextHeader(
                    title: 'Update Available',
                    subtitle:
                        'A new version of Notester is available. Update now to enhance your app experience. Thank you!',
                    crossAxisAlignment: CrossAxisAlignment.center,
                    subtitleStyle:
                        Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: regular,
                            ),
                    textAlign: TextAlign.center,
                  ),
                  40.verticalSpace,
                  CustomButton(
                    buttonWidth: Utilities.screenWidth(context),
                    elevation: 4,
                    title: "UPDATE",
                    borderRadius: BorderRadius.circular(10),
                    splashBorderRadius: BorderRadius.circular(10),
                    buttonColor:
                        Theme.of(context).buttonTheme.colorScheme?.primary,
                    onPressed: () {
                      Utils.launchLink(
                          urlPath:
                              'https://play.google.com/store/apps/details?id=com.rojanshr.notester');
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
