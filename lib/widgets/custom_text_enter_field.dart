import 'package:custom_widgets/custom_widgets.dart';
import 'package:notester/provider/dark_theme_provider.dart';
import 'package:notester/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomTextEnterField extends StatelessWidget {
  final TextEditingController? textEditingController;
  final String? hintText;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Function()? onTap;
  final Function(String)? onFormSubmitted;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int? maxLines;
  final bool? enabled;
  final bool autofocus;
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? enabledBorder;
  final InputBorder? disabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final InputBorder? focusedErrorBorder;
  final int? maxLength;
  final bool? filled;
  final Color? fillColor;
  final TextStyle? hintStyle;
  final TextStyle? style;
  final TextStyle? errorStyle;
  final TextCapitalization textCapitalization;
  final Widget? label;

  const CustomTextEnterField({
    Key? key,
    this.textEditingController,
    this.hintText,
    this.textInputType,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.suffixIcon,
    this.maxLines = 1,
    this.prefixIcon,
    this.enabled = true,
    this.autofocus = false,
    this.onTap,
    this.contentPadding = const EdgeInsets.all(12),
    this.enabledBorder,
    this.disabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.focusedErrorBorder,
    this.onFormSubmitted,
    this.textInputAction,
    this.maxLength,
    this.filled = false,
    this.fillColor,
    this.hintStyle = const TextStyle(color: CustomColor.cgrey),
    this.style,
    this.textCapitalization = TextCapitalization.none,
    this.errorStyle = const TextStyle(color: CustomColor.cred),
    this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<DarkThemeProvider>();

    return TextFormField(
      enabled: enabled,
      maxLength: maxLength,
      onChanged: onChanged,
      obscureText: obscureText,
      controller: textEditingController,
      autofocus: autofocus,
      autocorrect: false,
      validator: validator,
      enableSuggestions: false,
      keyboardType: textInputType,
      textInputAction: textInputAction,
      maxLines: maxLines,
      onTap: onTap,
      onFieldSubmitted: onFormSubmitted,
      textCapitalization: textCapitalization,
      style: style,
      decoration: InputDecoration(
        label: label,
        fillColor: fillColor,
        filled: filled,
        contentPadding: contentPadding,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        hintText: hintText,
        errorStyle: errorStyle,
        focusedBorder: focusedBorder ??
            OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.cBlueShade),
                borderRadius: BorderRadius.circular(10)),
        enabledBorder: enabledBorder ??
            OutlineInputBorder(
                borderSide: BorderSide(
                    color: themeProvider.darkTheme
                        ? AppColors.transparent
                        : AppColors.cFadedBlue),
                borderRadius: BorderRadius.circular(10)),
        disabledBorder: disabledBorder ??
            OutlineInputBorder(borderRadius: BorderRadius.circular(0)),
        focusedErrorBorder: focusedErrorBorder ??
            OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.cRed),
                borderRadius: BorderRadius.circular(10)),
        errorMaxLines: 2,
        errorBorder: errorBorder ??
            OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.cRed),
                borderRadius: BorderRadius.circular(10)),
        hintStyle: hintStyle,
      ),
    );
  }
}
