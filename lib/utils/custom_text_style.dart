import 'package:notester/utils/app_colors.dart';
import 'package:notester/utils/constants.dart';
import 'package:flutter/widgets.dart';

class CustomTextStyle {
  CustomTextStyle._();

  static const title = TextStyle(fontSize: 28, fontWeight: black, color: AppColors.cBlack, letterSpacing: 0.5);
  static const titleAccent =
      TextStyle(fontSize: 28, fontWeight: black, color: AppColors.cBlueAccent, letterSpacing: 0.5);
  static const titleLight = TextStyle(fontSize: 28, color: AppColors.cLight, fontWeight: black, letterSpacing: 0.5);
  static const titlePrimary =
      TextStyle(fontSize: 28, color: AppColors.cDarkBlue, fontWeight: black, letterSpacing: 0.5);
  static const titleWhite = TextStyle(fontSize: 28, color: AppColors.cWhite, fontWeight: black, letterSpacing: 0.5);

  static const largeHeaderText = TextStyle(fontSize: 24, color: AppColors.cBlack, fontWeight: bold);
  static const largeHeaderTextAccent = TextStyle(fontSize: 24, color: AppColors.cBlueAccent, fontWeight: bold);
  static const largeHeaderTextPrimary = TextStyle(fontSize: 24, color: AppColors.cDarkBlue, fontWeight: bold);
  static const largeHeaderTextLight = TextStyle(fontSize: 24, color: AppColors.cLight, fontWeight: bold);
  static const largeHeaderTextWhite = TextStyle(fontSize: 24, color: AppColors.cWhite, fontWeight: bold);

  static const headerText = TextStyle(fontSize: 20, color: AppColors.cBlack, fontWeight: bold);
  static const headerTextAccent = TextStyle(fontSize: 20, color: AppColors.cBlueAccent, fontWeight: bold);
  static const headerTextLight = TextStyle(fontSize: 20, color: AppColors.cLight, fontWeight: bold);
  static const headerTextPrimary = TextStyle(fontSize: 20, color: AppColors.cDarkBlue, fontWeight: bold);
  static const headerTextWhite = TextStyle(fontSize: 20, color: AppColors.cWhite, fontWeight: bold);
  static const headerTextDanger = TextStyle(fontSize: 20, color: AppColors.cRed, fontWeight: bold);

  static const subtitleText = TextStyle(fontSize: 16, color: AppColors.cBlack, fontWeight: semibold);
  static const subtitleTextAccent = TextStyle(fontSize: 16, color: AppColors.cBlueAccent, fontWeight: semibold);
  static const subtitleTextLight = TextStyle(fontSize: 16, color: AppColors.cLight, fontWeight: semibold);
  static const subtitleTextPrimary = TextStyle(fontSize: 16, color: AppColors.cDarkBlue, fontWeight: semibold);
  static const subtitleTextWhite = TextStyle(fontSize: 16, color: AppColors.cWhite, fontWeight: semibold);
  static const subtitleTextDanger = TextStyle(fontSize: 16, color: AppColors.cRed, fontWeight: semibold);

  static const bodyText = TextStyle(color: AppColors.cBlack, fontWeight: regular);
  static const bodyTextBold = TextStyle(fontWeight: semibold, color: AppColors.cBlack);
  static const bodyTextAccent = TextStyle(color: AppColors.cBlueAccent);
  static const bodyTextAccentBold = TextStyle(color: AppColors.cBlueAccent, fontWeight: semibold);
  static const bodyTextLight = TextStyle(color: AppColors.cLight);
  static const bodyTextLightBold = TextStyle(fontWeight: semibold, color: AppColors.cLight);
  static const bodyTextPrimary = TextStyle(color: AppColors.cDarkBlue);
  static const bodyTextBoldPrimary = TextStyle(fontWeight: semibold, color: AppColors.cDarkBlue);
  static const bodyTextWhite = TextStyle(color: AppColors.cWhite);
  static const bodyTextDanger = TextStyle(color: AppColors.cRed);

  static const largeText = TextStyle(fontSize: 18, color: AppColors.cBlack, fontWeight: regular);
  static const largeTextBold = TextStyle(fontSize: 18, fontWeight: semibold, color: AppColors.cBlack);
  static const largeTextAccent = TextStyle(fontSize: 18, fontWeight: semibold, color: AppColors.cBlueAccent);
  static const largeTextLight = TextStyle(fontSize: 18, color: AppColors.cLight);
  static const largeTextLightBold = TextStyle(fontSize: 18, fontWeight: semibold, color: AppColors.cLight);
  static const largeTextPrimary = TextStyle(fontSize: 18, color: AppColors.cDarkBlue);
  static const largeTextPrimaryBold = TextStyle(fontSize: 18, color: AppColors.cDarkBlue, fontWeight: semibold);
  static const largeTextWhite = TextStyle(fontSize: 18, color: AppColors.cWhite);
  static const largeTextDanger = TextStyle(fontSize: 18, color: AppColors.cRed);

  static const smallText = TextStyle(fontSize: 12, color: AppColors.cBlack, fontWeight: regular);
  static const smallTextBold = TextStyle(fontSize: 12, fontWeight: semibold, color: AppColors.cBlack);
  static const smallTextAccent = TextStyle(fontSize: 12, color: AppColors.cBlueAccent);
  static const smallTextLight = TextStyle(fontSize: 12, color: AppColors.cLight);
  static const smallTextLightBold = TextStyle(fontSize: 12, fontWeight: semibold, color: AppColors.cLight);
  static const smallTextPrimary = TextStyle(fontSize: 12, color: AppColors.cDarkBlue);
  static const smallTextPrimaryBold = TextStyle(fontSize: 12, color: AppColors.cDarkBlue, fontWeight: semibold);
  static const smallTextWhite = TextStyle(fontSize: 12, color: AppColors.cWhite);
  static const smallTextDanger = TextStyle(fontSize: 12, color: AppColors.cRed);

  static const extraSmallText = TextStyle(fontSize: 10, color: AppColors.cBlack);
  static const extraSmallTextBold = TextStyle(fontSize: 10, fontWeight: semibold, color: AppColors.cBlack);
  static const extraSmallTextAccent = TextStyle(fontSize: 10, color: AppColors.cBlueAccent);
  static const extraSmallTextAccentBold =
      TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.cBlueAccent);
  static const extraSmallTextLight = TextStyle(fontSize: 10, color: AppColors.cWhite);
  static const extraSmallTextLightBold = TextStyle(fontSize: 10, fontWeight: semibold, color: AppColors.cWhite);
  static const extraSmallTextPrimary = TextStyle(fontSize: 10, color: AppColors.cDarkBlue);
  static const extraSmallTextPrimaryBold = TextStyle(fontSize: 10, fontWeight: semibold, color: AppColors.cDarkBlue);
  static const extraSmallTextWhite = TextStyle(fontSize: 10, color: AppColors.cWhite);
  static const extraSmallTextDanger = TextStyle(fontSize: 10, color: AppColors.cRed);

  static const hintLargeText = TextStyle(fontSize: 24, color: AppColors.cGrey, fontWeight: bold);
  static const hintText = TextStyle(fontSize: 16, color: AppColors.cGrey);
  static const hintTextLight = TextStyle(fontSize: 16, color: AppColors.cDarkBlueLight);
  static const hintTextBold = TextStyle(fontSize: 16, color: AppColors.cGrey, fontWeight: bold);
  static const hintbodyText = TextStyle(color: AppColors.cGrey);
  static const hintbodyTextBold = TextStyle(color: AppColors.cGrey, fontWeight: bold);
  static const hintSmallText = TextStyle(fontSize: 12, color: AppColors.cGrey);
  static const hintSmallTextBold = TextStyle(fontSize: 12, color: AppColors.cGrey, fontWeight: bold);
  static const hintExtraSmall = TextStyle(fontSize: 10, color: AppColors.cGrey);
  static const hintExtraSmallBold = TextStyle(fontSize: 10, color: AppColors.cGrey, fontWeight: bold);

  static const fadedText = TextStyle(fontSize: 16, color: AppColors.cFadedBlue, fontWeight: regular);
  static const fadedTextBold = TextStyle(fontSize: 16, color: AppColors.cFadedBlue, fontWeight: bold);
  static const fadedTextNormal = TextStyle(color: AppColors.cFadedBlue, fontWeight: regular);
  static const fadedBodyTextBold = TextStyle(color: AppColors.cFadedBlue, fontWeight: bold);
  static const fadedSmallText = TextStyle(fontSize: 12, color: AppColors.cFadedBlue);
  static const fadedSmallTextBold = TextStyle(fontSize: 12, color: AppColors.cFadedBlue, fontWeight: bold);
  static const fadedExtraSmall = TextStyle(fontSize: 10, color: AppColors.cFadedBlue);
  static const fadedExtraSmallBold = TextStyle(fontSize: 10, color: AppColors.cFadedBlue, fontWeight: bold);
}
