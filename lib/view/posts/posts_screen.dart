import 'package:notester/cubit/post_cubit.dart';
import 'package:notester/model/model.dart';
import 'package:notester/view/posts/posts_bloc_screen.dart';
import 'package:notester/widgets/no_data_widget.dart';
import 'package:notester/widgets/simple_circular_loader.dart';
import 'package:notester/widgets/sliver_header_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  double top = 0.0;

  final _controller = ScrollController();

  double get maxHeight => 200 + MediaQuery.of(context).padding.top;

  double get minHeight => 120;

  void _snapAppbar() {
    final scrollDistance = maxHeight - minHeight;

    if (_controller.offset > 0 && _controller.offset < scrollDistance) {
      final double snapOffset = _controller.offset / scrollDistance > 0.5 ? scrollDistance : 0;

      Future.microtask(
          () => _controller.animateTo(snapOffset, duration: const Duration(milliseconds: 200), curve: Curves.easeIn));
    }
  }

  @override
  Widget build(BuildContext context) {
    // context.read<PostCubit>().getPosts();
    final postCubit = BlocProvider.of<PostCubit>(context);
    postCubit.getPosts();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => const PostsBlocScreen(title: "Bloc instead of cubit"))),
        // onPressed: () => postCubit.clearPosts(),
        child: const Icon(Icons.clear),
      ),
      body: Center(
        child: BlocBuilder<PostCubit, List<Posts>?>(
          builder: (context, posts) {
            if (posts == null) {
              return const Center(
                child: SimpleCircularLoader(),
              );
            }
            if (posts.isEmpty) {
              return const Center(
                child: Text("No posts available"),
              );
            }
            return NotificationListener<ScrollEndNotification>(
              onNotification: (_) {
                _snapAppbar();
                return false;
              },
              child: CupertinoScrollbar(
                controller: _controller,
                child: CustomScrollView(
                  controller: _controller,
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      stretch: true,
                      centerTitle: false,
                      flexibleSpace: SliverHeaderText(
                        maxHeight: maxHeight,
                        minHeight: minHeight,
                        notesLength: posts.length,
                      ),
                      expandedHeight: maxHeight - MediaQuery.of(context).padding.top,
                    ),
                    if (posts.isNotEmpty)
                      PostsList(posts: posts)
                    else
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: NoDataWidget(title: "No data"),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class PostsList extends StatelessWidget {
  const PostsList({Key? key, required this.posts}) : super(key: key);

  final List<Posts> posts;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text(posts[index].title),
            subtitle: Text(posts[index].body),
          ),
        );
      },
    );
  }
}
