class Photo {
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  const Photo(
      {required this.albumId, required this.id, required this.title, required this.url, required this.thumbnailUrl});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      albumId: json['albumId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
    );
  }
}

// class Posts {
//   final int userId;
//   final int id;
//   final String title;
//   final String body;

//   const Posts({required this.userId, required this.id, required this.title, required this.body});

//   factory Posts.fromJson(Map<String, dynamic> json) {
//     return Posts(
//       userId: json['userId'] as int,
//       id: json['id'] as int,
//       title: json['title'] as String,
//       body: json['body'] as String,
//     );
//   }
// }

class ImageArgs {
  final String imageUrl;

  ImageArgs({required this.imageUrl});
}

class Args {
  final String fileUrl;
  final String fileName;

  Args({required this.fileUrl, this.fileName = ""});
}
