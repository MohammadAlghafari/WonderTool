class AnswerModel {
  final String id;
  final String text;

  const AnswerModel({
    this.id = '',
    this.text = '',
  });

  factory AnswerModel.fromJson(Map<String, dynamic> json) => AnswerModel(
        id: json['id'] ?? "",
        text: json['answer_title'] ?? "",
      );
}
