// class FeedbackModel {
//   final String id;
//   final String taskId;
//   final String taskName;
//   final String clientTaskName;
//   final String taskDeadLine;
//   final String date;
//   final String feedback;
//   final bool isNew;
//   final String userNickname;
//   final String userFirstName;
//   final String userLastName;
//   final String clientTaskUserId;

//   const FeedbackModel({
//     this.id = '',
//     this.taskId = '',
//     this.taskName = '',
//     this.clientTaskName = '',
//     this.taskDeadLine = "",
//     this.date = '',
//     this.isNew = false,
//     this.feedback = '',
//     this.userNickname = '',
//     this.userFirstName = '',
//     this.userLastName = '',
//     this.clientTaskUserId = '',
//   });

//   factory FeedbackModel.fromJson(Map<String, dynamic> json) => FeedbackModel(
//         id: json['feedback_id'] ?? "",
//         taskName: json['task_name'] ?? "",
//         clientTaskName: json['client_name'] ?? "",
//         date: json['submit_date'] ?? "",
//         feedback: json['feedback'] ?? "",
//         isNew: (json['is_new'] ?? "0") == "1",
//         taskDeadLine: json['delivery_date'] ?? "",
//         taskId: json['task_id'] ?? "",
//         userFirstName: json['user_first_name'] ?? "",
//         userLastName: json['user_last_name'] ?? "",
//         userNickname: json['user_nickname'] ?? "",
//         clientTaskUserId: json['client_task_user_id'] ?? "",
//       );

//   factory FeedbackModel.fromJsonForReview(Map<String, dynamic> json) =>
//       FeedbackModel(
//         id: json['id'] ?? "",
//         taskName: json[''] ?? "",
//         clientTaskName: json[''] ?? "",
//         date: json['submit_date'] ?? "",
//         feedback: json['text'] ?? "",
//         isNew: (json[''] ?? "0") == "1",
//         taskDeadLine: json[''] ?? "",
//         taskId: json[''] ?? "",
//         userFirstName: json['first_name'] ?? "",
//         userLastName: json['last_name'] ?? "",
//         userNickname: json['nickname'] ?? "",
//         clientTaskUserId: json[''] ?? "",
//       );
// }
