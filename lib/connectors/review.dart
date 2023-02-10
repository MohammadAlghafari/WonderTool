import 'dart:convert';

import 'package:wonder_tool/helpers/local_storage.dart';
import 'package:wonder_tool/helpers/public.dart';
import 'package:wonder_tool/models/review.dart';
import 'package:wonder_tool/apis/api.dart';
import 'package:wonder_tool/apis/urls.dart';

class ReviewConnector {
  final _api = ApiService();

  Future<List<ReviewModel>> getReviewByTaskId(
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
        await _api.getApi(url: GET_REVIEW_BY_TASK_USER, params: params);
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

  Future<bool> addReview(ReviewModel review) async {
    bool _isSuccess = false;

    final body = {
      "user_token": boxStorage.read(TOKEN),
      "user_id": review.userId,
      "submit_user_id": boxStorage.read(USER_ID),
      "task_id": review.taskId,
      "rate_options": json.encode(review.rateOptions.map((e) => e.id).toList()),
      "rate_values":
          json.encode(review.rateOptions.map((e) => e.value.toInt()).toList()),
      "is_accepted": review.isDelivery ? 1 : 0,
      "feedback": review.feedback,
    };

    final response = await _api.postApi(url: ADD_REVIEW_URL, body: body);
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
}
