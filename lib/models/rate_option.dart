class RateOptionModel {
  final String id;
  final String title;
  double value;

  RateOptionModel({
    this.id = '',
    this.title = '',
    this.value = 2,
  });

  factory RateOptionModel.fromJson(Map<String, dynamic> json) =>
      RateOptionModel(
        id: json['id'] ?? "",
        title: json['title'] ?? "",
        value: double.parse(json['value'] ?? "0"),
      );
}
