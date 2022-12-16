import 'package:flutter/material.dart';

class SimpleCircularLoader extends StatelessWidget {
  /// Species the color of the circular loader
  final Color? color;

  /// The width of the line used to draw the circle.
  final double strokeWidth;

  /// The amount of space by which to inset the child.
  final EdgeInsetsGeometry? padding;

  /// Creates a circular progress indicator.
  final Color? backgroundColor;

  final double? buttonSize;

  const SimpleCircularLoader(
      {Key? key, this.color, this.strokeWidth = 6.0, this.padding, this.backgroundColor, this.buttonSize})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    Color colors = Theme.of(context).colorScheme.background;
    return Padding(
      padding: padding ?? const EdgeInsets.all(4.0),
      child: SizedBox(
        height: buttonSize,
        width: buttonSize,
        child: CircularProgressIndicator(color: colors, strokeWidth: strokeWidth, backgroundColor: backgroundColor),
      ),
    );
  }
}
