import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notester/utils/app_colors.dart';

class TextHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final double? paddingHeight;
  final TextAlign? textAlign;
  final Widget? titleWidget;
  final Widget? subtitleWidget;
  final TextOverflow? textOverflow;
  const TextHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.textOverflow,
    this.titleStyle,
    this.subtitleStyle,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.paddingHeight,
    this.textAlign,
    this.titleWidget,
    this.subtitleWidget,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      children: [
        titleWidget ??
            Text(
              title,
              style: titleStyle ?? appTheme.textTheme.headlineMedium,
              softWrap: true,
              textAlign: textAlign,
              overflow: textOverflow,
            ),
        ((subtitle != null || subtitleWidget != null)
            ? SizedBox(height: paddingHeight ?? 15.h)
            : const SizedBox.shrink()),
        subtitleWidget ??
            (subtitle == null
                ? const SizedBox()
                : Text(
                    subtitle!,
                    style: subtitleStyle ??
                        appTheme.textTheme.bodyMedium
                            ?.copyWith(color: AppColors.cBlack),
                    softWrap: true,
                    textAlign: textAlign,
                  )),
      ],
    );
  }
}
