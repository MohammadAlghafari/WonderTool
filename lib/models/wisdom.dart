class WisdomModel {
  final String text;
  final String auther;

  const WisdomModel({
    this.text = '',
    this.auther = '',
  });

  factory WisdomModel.fromJson(Map<String, dynamic> json) => WisdomModel(
        text: json['name'] ?? "",
        auther: json['text'] ?? "",
      );
}
