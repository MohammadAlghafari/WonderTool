import 'package:intl/intl.dart';

class SubTaskModel {
  int historyId;
  String totalTime;
  int totalTimeMillisecond;

  SubTaskModel({
    this.historyId = 0,
    this.totalTime = '',
    this.totalTimeMillisecond = 0,
  });
}

class TaskModel {
  final String id;
  final DateTime? deadLineDate;
  final String totalTime;
  final String deadLineTime;
  final String name;
  final String clientName;
  final bool isPin;
  final bool isCompleted;
  bool isNew;

  TaskModel({
    this.id = '',
    this.deadLineDate,
    this.totalTime = '',
    this.deadLineTime = '',
    this.name = '',
    this.clientName = '',
    this.isPin = false,
    this.isCompleted = false,
    this.isNew = false,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    final dDate = DateFormat("yyyy-MM-dd hh:mm:ss")
        .parse(json['delivery_date'] ?? "1970-01-01 00:00:00");

    final totalT =
        "${json['working_hours']}:${json['working_minutes']}:${json['working_seconds']}";

    final deadLineT = "${json['out_of_hours']}:${json['out_of_minutes']}";

    bool isPined = (json['isPined'] ?? "0") == "1";
    bool isCompleted = (json['isDelivered'] ?? "0") == "1";

    return TaskModel(
      id: json['id'] ?? "",
      deadLineDate: dDate,
      totalTime: totalT,
      deadLineTime: deadLineT,
      isCompleted: isCompleted,
      isPin: isPined,
      name: json['title'] ?? "",
      clientName: json['client_name'] ?? "",
      isNew: (json['is_new'] ?? "0") == "1",
    );
  }

  factory TaskModel.fromJsonFromFeedback(
    Map<String, dynamic> json,
    bool isPending,
  ) =>
      TaskModel(
        id: json['task_id'] ?? "",
        name: json['task_name'] ?? "",
        clientName: json['client_name'] ?? "",
        isCompleted: !isPending,
      );
}
