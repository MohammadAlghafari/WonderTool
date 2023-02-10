import 'package:wonder_tool/controllers/selected_task.dart';
import 'package:wonder_tool/helpers/local_storage.dart';
import 'package:wonder_tool/helpers/public.dart';
import 'package:wonder_tool/models/task.dart';
import 'package:wonder_tool/models/task_delivered.dart';
import 'package:wonder_tool/apis/api.dart';
import 'package:wonder_tool/apis/urls.dart';
import 'package:get/get.dart';

class TaskConnector {
  final _api = ApiService();

  Future<List<TaskDeiveredModel>> getTasksReviewDelivered() async {
    List<TaskDeiveredModel> _tasks = [];

    final params = {
      "user_id": boxStorage.read(USER_ID),
      "user_token": boxStorage.read(TOKEN),
    };

    final response = await _api.getApi(
      url: GET_REVIEW_TASKS_DELIVERED,
      params: params,
    );
    if (response != null) {
      final res = response.data;

      if (res['result'] == 1) {
        final data = res['data'] as List;

        for (var d in data) {
          _tasks.add(TaskDeiveredModel.fromJson(d));
        }
      } else {
        showErrorSnackBar(res['message']);
      }
    }

    return _tasks;
  }

  Future<List<TaskDeiveredModel>> getTasksFeedbackDelivered() async {
    List<TaskDeiveredModel> _tasks = [];

    final params = {
      "user_id": boxStorage.read(USER_ID),
      "user_token": boxStorage.read(TOKEN),
    };

    final response = await _api.getApi(
      url: GET_FEEDBACK_TASKS_DELIVERED,
      params: params,
    );
    if (response != null) {
      final res = response.data;

      if (res['result'] == 1) {
        final data = res['data'] as List;

        for (var d in data) {
          _tasks.add(TaskDeiveredModel.fromJson(d));
        }
      } else {
        showErrorSnackBar(res['message']);
      }
    }

    return _tasks;
  }

  Future<List<TaskModel>> getUserTasks() async {
    final _selectedTaskController = Get.find<SelectedTaskController>();

    List<TaskModel> _tasks = [];

    final params = {
      "user_id": boxStorage.read(USER_ID),
      "user_token": boxStorage.read(TOKEN),
      "date_now": DateTime.now().toString(),
    };

    final response = await _api.getApi(url: GET_TASKS_USER_URL, params: params);
    if (response != null) {
      final res = response.data;

      if (res['result'] == 1) {
        final data = res['data']['tasks'] as List;

        for (var d in data) {
          _tasks.add(TaskModel.fromJson(d));
        }

        if ((res['data']['is_working'] ?? "0") == 1) {
          final t = _tasks
              .firstWhereOrNull((t) => t.id == (res['data']['task_id'] ?? "0"));
          if (t != null) {
            final historyIdRunning =
                int.parse(res['data']['history_id'] ?? "0");
            final _typeTask = res['data']['working_type'] ?? "";

            String hours = res['data']['working_hours'] ?? "";
            String minutes = res['data']['working_minutes'] ?? "";
            String seconds = res['data']['working_seconds'] ?? "";

            String totalTime = "$hours:$minutes:$seconds";

            final _subTask = SubTaskModel(
              historyId: historyIdRunning,
              totalTime: totalTime,
              totalTimeMillisecond: res['data']['mls_working'] ?? 0,
            );

            _selectedTaskController.selectTaskRunning(t, _subTask, _typeTask);
          }
        }
      } else {
        showErrorSnackBar(res['message']);
      }
    }

    return _tasks;
  }

  Future<bool> togglePinTask(String taskId) async {
    bool _isSuccess = false;

    final body = {
      "user_id": boxStorage.read(USER_ID),
      "user_token": boxStorage.read(TOKEN),
      "task_id": taskId,
    };

    final response = await _api.postApi(url: PIN_TASKS_URL, body: body);
    if (response != null) {
      final res = response.data;

      if (res['result'] == 1) {
        _isSuccess = true;
      } else {
        showErrorSnackBar(res['message']);
      }
    }

    return _isSuccess;
  }

  Future<bool> deliveryTask(String taskId) async {
    bool _isSuccess = false;

    final body = {
      "user_id": boxStorage.read(USER_ID),
      "user_token": boxStorage.read(TOKEN),
      "task_id": taskId,
    };

    final response = await _api.postApi(url: DELIVERY_TASKS_URL, body: body);
    if (response != null) {
      final res = response.data;

      if (res['result'] == 1) {
        _isSuccess = true;
      } else {
        showErrorSnackBar(res['message']);
      }
    }

    return _isSuccess;
  }

  Future<SubTaskModel?> startTimerTask(String taskId, String type) async {
    SubTaskModel? _subTask;

    final body = {
      "user_id": boxStorage.read(USER_ID),
      "user_token": boxStorage.read(TOKEN),
      "task_id": taskId,
      "start_datetime": DateTime.now().toString(),
      "type": type,
    };

    final response = await _api.postApi(url: UPDATE_TASK_URL, body: body);
    if (response != null) {
      final res = response.data;

      if (res['result'] == 1) {
        String hours = res['data']['working_hours'] ?? "";
        String minutes = res['data']['working_minutes'] ?? "";
        String seconds = res['data']['working_seconds'] ?? "";

        String totalTime = "$hours:$minutes:$seconds";
        int historyId = res['history_id'] ?? 0;
        int totalTimeM = res['data']['mls_working'] ?? 0;

        _subTask = SubTaskModel(
          historyId: historyId,
          totalTime: totalTime,
          totalTimeMillisecond: totalTimeM,
        );
      } else {
        showErrorSnackBar(res['message']);
      }
    }

    return _subTask;
  }

  Future<SubTaskModel?> stopTimerTask(
    String taskId,
    int historyId,
    String type,
  ) async {
    SubTaskModel? _sub;

    final body = {
      "user_id": boxStorage.read(USER_ID),
      "user_token": boxStorage.read(TOKEN),
      "task_id": taskId,
      "end_datetime": DateTime.now().toString(),
      "history_id": historyId,
      "type": type,
    };

    final response = await _api.postApi(url: UPDATE_TASK_URL, body: body);
    if (response != null) {
      final res = response.data;

      if (res['result'] == 1) {
        String hours = res['data']['working_hours'] ?? "";
        String minutes = res['data']['working_minutes'] ?? "";
        String seconds = res['data']['working_seconds'] ?? "";

        String _totalTime = "$hours:$minutes:$seconds";
        int _totalTimeM = res['data']['mls_working'] ?? 0;

        _sub = SubTaskModel(
          historyId: historyId,
          totalTime: _totalTime,
          totalTimeMillisecond: _totalTimeM,
        );
      } else {
        showErrorSnackBar(res['message']);
      }
    }

    return _sub;
  }
}
