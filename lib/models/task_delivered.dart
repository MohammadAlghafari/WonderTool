class TaskDeiveredModel {
  final String id;
  final String name;
  final String userId;
  final String taskUserId;
  final String nickname;
  final String firstName;
  final String lastName;
  final String deliveryDate;
  final String clientName;
  bool isAccepted;
  bool isDelivered;
  bool isRead;
  final bool isSupervisor;

  TaskDeiveredModel({
    this.id = '',
    this.clientName = '',
    this.deliveryDate = '',
    this.firstName = '',
    this.isAccepted = false,
    this.isDelivered = false,
    this.isRead = false,
    this.lastName = '',
    this.taskUserId = '',
    this.name = '',
    this.nickname = '',
    this.userId = '',
    this.isSupervisor = false,
  });

  factory TaskDeiveredModel.fromJson(Map<String, dynamic> json) =>
      TaskDeiveredModel(
        id: json['task_id'] ?? "",
        taskUserId: json['task_user_id'] ?? "",
        name: json['task_name'] ?? "",
        clientName: json['client_name'] ?? "",
        deliveryDate: json['delivery_date'] ?? "",
        firstName: json['user_first_name'] ?? "",
        isAccepted: (json['is_accepted'] ?? "0") == "1",
        isDelivered: (json['is_delivered'] ?? "0") == "1",
        isRead: int.parse((json['is_read'] ?? "0").toString()) == 1,
        lastName: json['user_last_name'] ?? "",
        nickname: json['user_nickname'] ?? "",
        userId: json['user_id'] ?? "",
        isSupervisor: (json['is_supervisor'] ?? "0").toString() == "1",
      );
}
