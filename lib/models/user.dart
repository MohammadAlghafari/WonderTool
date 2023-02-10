class UserModel {
  final String id;
  String nickname;
  String image;
  String firstName;
  String lastName;
  String email;
  String phone;
  final String barCodeLink;
  final String token;
  final String typeName;
  final int feedbackNotificationCount;
  final int reviewNotificationCount;
  final bool isTeamLeader;
  final bool isFreelancer;
  bool isOffline;

  UserModel({
    this.id = '',
    this.nickname = '',
    this.image = '',
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.phone = '',
    this.token = '',
    this.typeName = '',
    this.barCodeLink = '',
    this.feedbackNotificationCount = 0,
    this.reviewNotificationCount = 0,
    this.isTeamLeader = false,
    this.isFreelancer = true,
    this.isOffline = true,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] ?? "",
        nickname: json['nickname'] ?? "",
        image: json['profile_image'] ?? "",
        firstName: json['first_name'] ?? "",
        lastName: json['last_name'] ?? "",
        email: json['email'] ?? "",
        phone: json['phone'] ?? "",
        token: json['user_token'] ?? "",
        typeName: json['type_name'] ?? "",
        barCodeLink: json['digital_id'] ?? "",
        feedbackNotificationCount: json['feedbacks_count'] ?? 0,
        reviewNotificationCount: json['reviews_count'] ?? 0,
        isTeamLeader: ((json['type_id'] ?? "0") == "2"),
        isFreelancer: ((json['is_freelancer'] ?? "1") == "1"),
        isOffline: ((json['is_offline'] ?? "0") == "1"),
      );
}
