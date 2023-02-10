class DailyHoursModel {
  final int hours;
  final int minutes;
  final String title;

  const DailyHoursModel({
    this.hours = 0,
    this.minutes = 0,
    this.title = '',
  });

  factory DailyHoursModel.fromJson(Map<String, dynamic> json) =>
      DailyHoursModel(
        hours: json['hours'] ?? "",
        minutes: json['minutes'] ?? "",
        title: json['day'] ?? "",
      );

  factory DailyHoursModel.fromJsonTaskWork(Map<String, dynamic> json) =>
      DailyHoursModel(
        hours: json['hours'] ?? "",
        minutes: json['minutes'] ?? "",
        title: json['task_name'] ?? "",
      );
}

class DailyHoursTaskTypeModel {
  final int generalHours;
  final int generalMinutes;
  final int meetingHours;
  final int meetingMinutes;
  final int managementHours;
  final int managementMinutes;
  final String title;

  const DailyHoursTaskTypeModel({
    this.generalHours = 0,
    this.generalMinutes = 0,
    this.meetingHours = 0,
    this.meetingMinutes = 0,
    this.managementHours = 0,
    this.managementMinutes = 0,
    this.title = '',
  });

  factory DailyHoursTaskTypeModel.fromJson(Map<String, dynamic> json) =>
      DailyHoursTaskTypeModel(
        generalHours: json['genaral_hours'] ?? "",
        generalMinutes: json['genaral_minutes'] ?? "",
        meetingHours: json['meeting_hours'] ?? "",
        meetingMinutes: json['meeting_minutes'] ?? "",
        managementHours: json['management_hours'] ?? "",
        managementMinutes: json['management_minutes'] ?? "",
        title: json['task_name'] ?? "",
      );
}
