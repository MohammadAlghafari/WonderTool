import 'package:intl/intl.dart';

class CommentModel {
  final String id;
  final String text;
  final String userImage;
  final String userId;
  final String nickname;
  final String firstName;
  final String lastName;
  final DateTime? date;

  CommentModel({
    this.id = '',
    this.text = '',
    this.date,
    this.userImage = '',
    this.userId = '',
    this.firstName = '',
    this.nickname = '',
    this.lastName = '',
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    final dDate =
        DateFormat("yyyy-MM-dd").parse(json['date'] ?? "1970-01-01 00:00:00");

    return CommentModel(
      id: json['id'] ?? "",
      text: json['description'] ?? "",
      date: dDate,
      userImage: json['profile_image'] ?? "",
      firstName: json['first_name'] ?? "",
      lastName: json['last_name'] ?? "",
      nickname: json['nickname'] ?? "",
      userId: json['user_id'] ?? "",
    );
  }
}
