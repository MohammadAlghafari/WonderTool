import 'package:wonder_tool/models/rate_option.dart';

class ReviewModel {
  final String id;
  final String taskId;
  final String taskName;
  final String userId;
  final String userFirstName;
  final String userLastName;
  final String nickname;
  bool isDelivery;
  bool isRead;
  final int hoursSpent;
  final int minutesSpent;
  final int secondesSpent;
  final String clientName;
  List<RateOptionModel> rateOptions;
  final String date;
  final String feedback;
  final bool hasReview;

  ReviewModel({
    this.id = '',
    this.taskId = '',
    this.taskName = '',
    this.clientName = '',
    this.isDelivery = false,
    this.isRead = false,
    this.hoursSpent = 0,
    this.minutesSpent = 0,
    this.secondesSpent = 0,
    this.date = '',
    this.rateOptions = const [],
    this.nickname = '',
    this.userId = '',
    this.userFirstName = '',
    this.userLastName = '',
    this.feedback = '',
    this.hasReview = false,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    List<RateOptionModel> _rateOptions = [];
    final revOp = (json['reviews'] ?? []) as List;
    for (var r in revOp) {
      _rateOptions.add(RateOptionModel.fromJson(r));
    }

    return ReviewModel(
      id: json['id'] ?? "",
      hoursSpent: (json['working_hours'] ?? 0) as int,
      minutesSpent: (json['working_minutes'] ?? 0) as int,
      secondesSpent: (json['working_seconds'] ?? 0) as int,
      userId: json['user_id'] ?? "",
      nickname: json['nickname'] ?? "",
      userFirstName: json['first_name'] ?? "",
      userLastName: json['last_name'] ?? "",
      rateOptions: _rateOptions,
      feedback: json['feedback'] ?? "",
      hasReview: int.parse((json['has_review'] ?? 0).toString()) == 1,
    );
  }
}
