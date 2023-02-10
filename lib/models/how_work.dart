class HowItWorkModel {
  final String image;
  final String title;
  final String description;

  HowItWorkModel({
    required this.image,
    required this.title,
    required this.description,
  });

  factory HowItWorkModel.fromJson(Map<String, dynamic> json) => HowItWorkModel(
        image: json['main_img'] ?? "",
        title: json['title'] ?? "",
        description: json['description'] ?? "",
      );
}
