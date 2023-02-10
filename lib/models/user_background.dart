class UserBackgroundModel {
  final String text;
  final String image;

  const UserBackgroundModel({
    this.text = '',
    this.image = '',
  });

  factory UserBackgroundModel.fromJson(Map<String, dynamic> json) =>
      UserBackgroundModel(
        text: json['display_text'] ?? "",
        image: json['employees_general_background'] ?? "",
      );
}
