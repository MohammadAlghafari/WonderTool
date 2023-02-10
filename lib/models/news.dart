import 'package:intl/intl.dart';
import 'package:wonder_tool/models/user.dart';

class NewsModel {
  final String id;
  final UserModel? user;
  final String description;
  final String image;
  final String video;
  int numberLikes;
  int numberComments;
  bool isLiked;
  final DateTime? date;

  NewsModel({
    this.id = '',
    this.description = '',
    this.date,
    this.numberLikes = 0,
    this.numberComments = 0,
    this.isLiked = false,
    this.image = '',
    this.video = '',
    this.user,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    final _user = UserModel.fromJson(json['user']);
    final dDate = DateFormat("yyyy-MM-dd hh:mm:ss")
        .parse(json['news_date_time'] ?? "1970-01-01 00:00:00");

    return NewsModel(
      id: json['id'] ?? "",
      date: dDate,
      description: json['description'] ?? "",
      image: json['image'] ?? "",
      video: json['video'] ?? "",
      isLiked: (json['is_like'] ?? 0) == 1,
      numberLikes: int.parse(json['nb_of_likes'] ?? "0"),
      numberComments: int.parse(json['nb_of_comments'] ?? "0"),
      user: _user,
    );
  }
}
