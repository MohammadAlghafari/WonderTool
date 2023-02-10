import 'package:wonder_tool/models/daily_hours.dart';

class PerformanceModel {
  final double rate;
  final String avgTime;
  final String workStart;
  final String nickname;
  final List<String> rewardsId;
  final List<DailyHoursModel> dailyWork;
  final List<DailyHoursModel> dailyTaskWork;
  final List<DailyHoursTaskTypeModel> dailyTaskTypeWork;

  PerformanceModel({
    this.rate = 0,
    this.avgTime = '',
    this.nickname = '',
    this.workStart = '',
    this.rewardsId = const [],
    this.dailyWork = const [],
    this.dailyTaskWork = const [],
    this.dailyTaskTypeWork = const [],
  });
}
