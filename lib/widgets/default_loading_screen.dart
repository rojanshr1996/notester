import 'package:flutter/material.dart';
import 'package:notester/widgets/simple_circular_loader.dart';
import 'package:notester/widgets/sliver_header_text.dart';

class DefaultLoadingScreen extends StatelessWidget {
  final double maxHeight;
  final double minHeight;
  final bool fromPosts;
  final List<Widget>? actions;

  const DefaultLoadingScreen({
    Key? key,
    required this.maxHeight,
    required this.minHeight,
    this.fromPosts = false,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverAppBar(
          pinned: true,
          stretch: true,
          centerTitle: false,
          flexibleSpace: SliverHeaderText(
            maxHeight: maxHeight,
            minHeight: minHeight,
            onlyShowFavorite: false,
          ),
          expandedHeight: maxHeight - MediaQuery.of(context).padding.top,
          actions: actions,
        ),
        const SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: SimpleCircularLoader(),
          ),
        ),
      ],
    );
  }
}
