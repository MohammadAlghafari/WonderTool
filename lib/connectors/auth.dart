import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:wonder_tool/controllers/user.dart';
import 'package:wonder_tool/helpers/local_storage.dart';
import 'package:wonder_tool/helpers/public.dart';
import 'package:wonder_tool/helpers/variables.dart';
import 'package:wonder_tool/models/user.dart';
import 'package:wonder_tool/apis/api.dart';
import 'package:wonder_tool/apis/urls.dart';

class AuthConnector {
  final _api = ApiService();
  final userController = Get.find<UserController>();

  Future<bool> login(String email) async {
    bool _isSuccess = false;

    String deviceToken = await FirebaseMessaging.instance.getToken() ?? "";

    final params = {
      "email": email,
      "device_token": deviceToken,
    };

    final response = await _api.getApi(url: LOGIN_URL, params: params);
    if (response != null) {
      final res = response.data;

      if (res['result'] == 1) {
        tokenVAR = res['user_token'];
        userIdVAR = res['user_id'];

        _isSuccess = true;
      } else {
        showErrorSnackBar(res['message']);
      }
    }

    return _isSuccess;
  }

  Future<bool> verifyAccount(String code) async {
    bool _isSuccess = false;

    String deviceToken = await FirebaseMessaging.instance.getToken() ?? "";

    final body = {
      "user_token": tokenVAR,
      "user_id": userIdVAR,
      "code": code,
      "device_token": deviceToken,
      // NEW
      "time_utc": DateTime.now().toUtc().toString(),
      "time_local": DateTime.now().toLocal().toString(),
      "timezone_name": DateTime.now().timeZoneName.toString(),
      "timezone_offset": DateTime.now().timeZoneOffset.toString(),
    };

    final response = await _api.postApi(url: VERIFY_ACCOUNT_URL, body: body);
    if (response != null) {
      final res = response.data;

      if (res['result'] == 1) {
        final user = UserModel.fromJson(res['data']);

        await setUserData(user);

        boxStorage.write(IS_LOGIN, true);
        _isSuccess = true;
      } else {
        showErrorSnackBar(res['message']);
      }
    }

    return _isSuccess;
  }

  Future<bool?> getUserData() async {
    bool _isSuccess = false;

    String deviceToken = await FirebaseMessaging.instance.getToken() ?? "";

    final params = {
      "user_id": boxStorage.read(USER_ID),
      "user_token": boxStorage.read(TOKEN),
      "device_token": deviceToken,
      // NEW
      "time_utc": DateTime.now().toUtc().toString(),
      "time_local": DateTime.now().toLocal().toString(),
      "timezone_name": DateTime.now().timeZoneName.toString(),
      "timezone_offset": DateTime.now().timeZoneOffset.toString(),
    };

    final response = await _api.getApi(url: GET_USER_INFO_URL, params: params);
    if (response != null) {
      final res = response.data;

      if (res['result'] == 1) {
        final user = UserModel.fromJson(res['data']);

        await setUserData(user);
        _isSuccess = true;
      } else {
        showErrorSnackBar(res['message']);
      }

      return _isSuccess;
    }

    return null;
  }

  Future<void> setUserData(UserModel u) async {
    userController.user.value = u;
    userController.feedbackNotificationCount = u.feedbackNotificationCount;
    userController.reviewNotificationCount = u.reviewNotificationCount;

    userController.hasNewsNotification = boxStorage.read(IS_READ_NEWS) ?? false;
    userController.hasTaskNotification = boxStorage.read(IS_READ_TASK) ?? false;

    await boxStorage.write(USER_ID, u.id);
    await boxStorage.write(TOKEN, u.token);

    // no  internet
    await boxStorage.write(USER_IMAGE, u.image);
    await boxStorage.write(USER_NAME, "${u.firstName} ${u.lastName}");
    await boxStorage.write(USER_NICKNAME, u.nickname);
    await boxStorage.write(USER_LINK, u.barCodeLink);
  }
}
