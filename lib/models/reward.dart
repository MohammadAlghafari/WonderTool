class RewardModel {
  final String id;
  final String title;
  final String description;

  const RewardModel({
    this.id = '',
    this.title = '',
    this.description = '',
  });

  factory RewardModel.fromJson(Map<String, dynamic> json) => RewardModel(
        id: json['id'] ?? "",
        title: json['title'] ?? "",
        description: json['description'] ?? "",
      );
}
