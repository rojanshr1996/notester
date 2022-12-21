import 'dart:convert';
import 'dart:developer';

import 'package:notester/model/model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class PostService {
  final String _baseurl = "https://jsonplaceholder.typicode.com";

  getPosts() async {
    try {
      final response = await http.get(Uri.parse("$_baseurl/posts"));
      // Use the compute function to run parsePhotos in a separate isolate.
      log(response.body.toString());
      return compute(parsePosts, response.body);
    } catch (e) {
      return Exception(e);
    }
  }
}

class PhotoService {
  static const _baseurl = "https://jsonplaceholder.typicode.com";

  Future<List<Photo>> fetchPhotos(http.Client client) async {
    try {
      final response = await client.get(Uri.parse("$_baseurl/photos"));
      // Use the compute function to run parsePhotos in a separate isolate.
      log(response.body.toString());
      return compute(parsePhotos, response.body);
    } catch (e) {
      rethrow;
    }
  }
}

// A function that converts a response body into a List<Photo>.
List<Photo> parsePhotos(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
}

// A function that converts a response body into a List<Posts>.
List<Posts> parsePosts(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Posts>((json) => Posts.fromJson(json)).toList();
}
