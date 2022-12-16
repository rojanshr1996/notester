import 'package:notester/model/model.dart';
import 'package:equatable/equatable.dart';

abstract class PostsState extends Equatable {
  const PostsState();
  @override
  List<Object?> get props => [];
}

class LoadingPostState extends PostsState {
  @override
  List<Object?> get props => [];
}

class LoadedPostState extends PostsState {
  final List<Posts>? posts;
  const LoadedPostState({this.posts});
  @override
  List<Object?> get props => [posts];
}

class FailedLoadPostState extends PostsState {
  final String? error;
  const FailedLoadPostState({this.error});

  @override
  List<Object?> get props => [];
}
