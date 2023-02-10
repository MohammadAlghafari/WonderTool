import 'package:get/get.dart';
import 'package:wonder_tool/controllers/user.dart';
import 'package:wonder_tool/helpers/local_storage.dart';
import 'package:wonder_tool/helpers/public.dart';
import 'package:wonder_tool/models/daily_hours.dart';
import 'package:wonder_tool/models/performance.dart';
import 'package:wonder_tool/apis/api.dart';
import 'package:wonder_tool/apis/urls.dart';

class UserConnector {
  final _api = ApiService();
  final userController = Get.find<UserController>();

  Future<PerformanceModel> getUserPerformance() async {
    late PerformanceModel _userPerformance;

    final params = {
      "user_id": boxStorage.read(USER_ID),
      "user_token": boxStorage.read(TOKEN),
    };

    final response =
        await _api.getApi(url: GET_USER_PERFORMANCE_URL, params: params);
    if (response != null) {
      final res = response.data;

      if (res['result'] == 1) {
        final data = res['data'];

        List<String> rewards = data['user_achivement'].cast<String>();

        final dailyData = data['daily_works'] ?? [];
        List<DailyHoursModel> dailyWork = [];

        for (var d in dailyData) {
          dailyWork.add(DailyHoursModel.fromJson(d));
        }

        final dailyTaskData = data['tasks_works'] ?? [];
        List<DailyHoursModel> dailyTaskWork = [];

        for (var d in dailyTaskData) {
          dailyTaskWork.add(DailyHoursModel.fromJsonTaskWork(d));
        }

        final dailyTaskTypeData = data['type_tasks_works'] ?? [];
        List<DailyHoursTaskTypeModel> dailyTaskTypeWork = [];

        for (var d in dailyTaskTypeData) {
          dailyTaskTypeWork.add(DailyHoursTaskTypeModel.fromJson(d));
        }

        _userPerformance = PerformanceModel(
          dailyWork: dailyWork,
          dailyTaskWork: dailyTaskWork,
          dailyTaskTypeWork: dailyTaskTypeWork,
          rewardsId: rewards,
          rate: double.parse(data['user_rating'] ?? "0.0"),
          nickname: data['nickname'] ?? '',
          avgTime:
              "${data['avg_working_hours'] ?? 0}h ${data['avg_working_minutes'] ?? 0}m",
          workStart: "${data['from_date'] ?? 0} ${data['from_namedate'] ?? ''}",
        );
      } else {
        showErrorSnackBar(res['message']);
      }
    }

    return _userPerformance;
  }

  Future<bool> updateStatus(bool val) async {
    bool _isSuccess = false;

    final params = {
      "user_token": boxStorage.read(TOKEN),
      "user_id": boxStorage.read(USER_ID),
      "status": val ? 1 : 0,
    };

    final response =
        await _api.getApi(url: UPDATE_USER_STATUS_URL, params: params);
    if (response != null) {
      final res = response.data;

      if (res['result'] == 1) {
        _isSuccess = true;
      }
    }

    return _isSuccess;
  }
}
