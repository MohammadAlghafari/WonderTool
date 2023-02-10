import 'package:wonder_tool/models/answer.dart';

class QuestionModel {
  final String id;
  final String question;
  final List<AnswerModel> answers;

  const QuestionModel({
    this.id = '',
    this.question = '',
    this.answers = const [],
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    List<AnswerModel> _answers = [];
    for (var e in (json['answers'] as List)) {
      _answers.add(AnswerModel.fromJson(e));
    }

    return QuestionModel(
      id: json['id'] ?? "",
      question: json['question'] ?? "",
      answers: _answers,
    );
  }
}
