import 'package:wonder_tool/helpers/local_storage.dart';
import 'package:wonder_tool/helpers/public.dart';
import 'package:wonder_tool/apis/api.dart';
import 'package:wonder_tool/apis/urls.dart';
import 'package:wonder_tool/models/review.dart';

class FeedbackConnector {
  final _api = ApiService();

  Future<List<ReviewModel>> getFeedbackByTaskId(
    String taskId,
    String taskUserId,
    String submitUserId,
  ) async {
    List<ReviewModel> _reviews = [];

    final params = {
      "user_token": boxStorage.read(TOKEN),
      "user_id": boxStorage.read(USER_ID),
      "task_id": taskId,
      "task_user_id": taskUserId,
      "submit_user_id": submitUserId,
    };

    final response =
        await _api.getApi(url: GET_FEEDBACK_BY_TASK_USER, params: params);
    if (response != null) {
      final res = response.data;

      if (res['result'] == 1) {
        final data = res['data'] as List;
        for (var d in data) {
          _reviews.add(ReviewModel.fromJson(d ?? {}));
        }
      } else {
        showErrorSnackBar(res['message']);
      }
    }

    return _reviews;
  }
}
