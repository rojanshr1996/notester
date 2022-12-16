import 'package:notester/model/model.dart';
import 'package:notester/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostDetailScreen extends StatelessWidget {
  final Posts post;
  const PostDetailScreen({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: CupertinoScrollbar(
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: true,
                stretch: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  title: Text(
                    post.title,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: semibold),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  titlePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                ),
                expandedHeight: 150 + MediaQuery.of(context).padding.top,
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(post.body, style: Theme.of(context).textTheme.bodyMedium),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

class ScreenArguments {
  final String title;
  final int id;

  ScreenArguments({required this.title, required this.id});
}
