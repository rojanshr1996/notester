import 'package:notester/model/model.dart';
import 'package:notester/services/post_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostCubit extends Cubit<List<Posts>?> {
  PostCubit() : super(null);

  final _postService = PostService();

  void getPosts() async => emit(await _postService.getPosts());
  void clearPosts() async => emit([]);
}
