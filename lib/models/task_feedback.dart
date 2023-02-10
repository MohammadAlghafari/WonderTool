// class TaskFeedbackModel {
//   final String id;
//   final String name;
//   final String userId;
//   final String taskUserId;
//   final String nickname;
//   final String firstName;
//   final String lastName;
//   final String deliveryDate;
//   final String clientName;
//   bool isAccepted;
//   bool isDelivered;
//   bool isRead;
//   final int hoursSpent;
//   final int minutesSpent;
//   final int secondesSpent;

//   TaskFeedbackModel({
//     this.id = '',
//     this.clientName = '',
//     this.deliveryDate = '',
//     this.firstName = '',
//     this.isAccepted = false,
//     this.isDelivered = false,
//     this.isRead = false,
//     this.lastName = '',
//     this.taskUserId = '',
//     this.name = '',
//     this.nickname = '',
//     this.userId = '',
//     this.hoursSpent = 0,
//     this.minutesSpent = 0,
//     this.secondesSpent = 0,
//   });

//   factory TaskFeedbackModel.fromJson(Map<String, dynamic> json) =>
//       TaskFeedbackModel(
//         id: json['task_id'] ?? "",
//         taskUserId: json['task_user_id'] ?? "",
//         name: json['task_name'] ?? "",
//         clientName: json['client_name'] ?? "",
//         deliveryDate: json['delivery_date'] ?? "",
//         firstName: json['user_first_name'] ?? "",
//         isAccepted: (json['is_accepted'] ?? "0") == "1" ? true : false,
//         isDelivered: (json['is_delivered'] ?? "0") == "1" ? true : false,
//         isRead: (json['is_read'] ?? 0) == 1 ? true : false,
//         lastName: json['user_last_name'] ?? "",
//         nickname: json['user_nickname'] ?? "",
//         userId: json['user_id'] ?? "",
//         hoursSpent: (json['working_hours'] ?? 0) as int,
//         minutesSpent: (json['working_minutes'] ?? 0) as int,
//         secondesSpent: (json['working_seconds'] ?? 0) as int,
//       );
// }
