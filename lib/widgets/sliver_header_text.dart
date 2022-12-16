import 'package:notester/utils/app_colors.dart';
import 'package:flutter/material.dart';

class SliverHeaderText extends StatelessWidget {
  final double maxHeight;
  final double minHeight;
  final int notesLength;
  final String imagePath;
  final bool fromPost;

  const SliverHeaderText({
    Key? key,
    required this.maxHeight,
    required this.minHeight,
    this.notesLength = 0,
    this.imagePath = "",
    this.fromPost = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final expandRatio = _calculateExpandRatio(constraints);
        final animation = AlwaysStoppedAnimation(expandRatio);

        return Stack(
          fit: StackFit.expand,
          children: [
            imagePath == ""
                ? Container(color: Theme.of(context).scaffoldBackgroundColor)
                : Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                  ),
            _buildTitle(animation),
          ],
        );
      },
    );
  }

  double _calculateExpandRatio(BoxConstraints constraints) {
    var expandRatio = (constraints.maxHeight - minHeight) / (maxHeight - minHeight);

    if (expandRatio > 1.0) expandRatio = 1.0;
    if (expandRatio < 0.0) expandRatio = 0.0;

    return expandRatio;
  }

  Align _buildTitle(Animation<double> animation) {
    return Align(
      alignment: AlignmentTween(begin: Alignment.bottomCenter, end: Alignment.bottomLeft).evaluate(animation),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15, left: 20, right: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fromPost ? "All Posts" : "All Notes",
              style: TextStyle(
                  fontSize: Tween<double>(begin: 18, end: 32).evaluate(animation),
                  color: AppColors.cWhite,
                  fontWeight: FontWeight.w600),
            ),
            notesLength == 0
                ? const SizedBox()
                : Text(
                    fromPost
                        ? notesLength == 1
                            ? "$notesLength post"
                            : "$notesLength posts"
                        : notesLength == 1
                            ? "$notesLength note"
                            : "$notesLength notes",
                    style: TextStyle(
                      fontSize: Tween<double>(begin: 0, end: 14).evaluate(animation),
                      color: AppColors.cLightShade,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
