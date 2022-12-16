import 'package:flutter/material.dart';

class SafeAreaHeader extends StatelessWidget {
  final Widget child;
  final Color? color;
  final bool? top;
  final bool? bottom;
  final bool? left;
  final bool? right;

  const SafeAreaHeader({Key? key, required this.child, this.color, this.top, this.bottom, this.left, this.right})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: color ?? Theme.of(context).primaryColor,
      child: SafeArea(
        top: top ?? true,
        right: right ?? true,
        left: left ?? true,
        bottom: bottom ?? true,
        child: child,
      ),
    );
  }
}
