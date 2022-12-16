import 'package:notester/bloc/postBloc/post_event.dart';
import 'package:notester/bloc/postBloc/post_state.dart';
import 'package:notester/services/post_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  PostsBloc(PostService postService) : super(LoadingPostState()) {
    on<LoadPostEvent>(
      (event, emit) async {
        emit(LoadingPostState());
        try {
          final posts = await postService.getPosts();
          emit(LoadedPostState(posts: posts));
        } catch (e) {
          debugPrint("THIS IS THE ERRR: $e");
          emit(FailedLoadPostState(error: "$e"));
        }
      },
    );
  }
}
