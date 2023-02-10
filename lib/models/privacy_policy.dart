class PrivacyPolicyModel {
  final String id;
  final String title;
  final String description;

  const PrivacyPolicyModel({
    this.id = '',
    this.title = '',
    this.description = '',
  });

  factory PrivacyPolicyModel.fromJson(Map<String, dynamic> json) =>
      PrivacyPolicyModel(
        id: json['id'] ?? "",
        title: json['title'] ?? "",
        description: json['description'] ?? "",
      );
}
