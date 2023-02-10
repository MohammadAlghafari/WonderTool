import 'package:wonder_tool/helpers/local_storage.dart';
import 'package:wonder_tool/helpers/public.dart';
import 'package:wonder_tool/models/how_work.dart';
import 'package:wonder_tool/models/notes.dart';
import 'package:wonder_tool/models/privacy_policy.dart';
import 'package:wonder_tool/models/question.dart';
import 'package:wonder_tool/models/reward.dart';
import 'package:wonder_tool/models/user_background.dart';
import 'package:wonder_tool/models/wisdom.dart';
import 'package:wonder_tool/apis/api.dart';
import 'package:wonder_tool/apis/urls.dart';

class DataConnector {
  final _api = ApiService();

  Future<WisdomModel?> getWisdom() async {
    WisdomModel? _wisdom;

    final response = await _api.getApi(url: GET_WIDSOME_URL);
    if (response != null) {
      final res = response.data;

      if (res['result'] == 1) {
        _wisdom = WisdomModel.fromJson(res['data']);
      } else {
        showErrorSnackBar(res['message']);
      }
    }

    return _wisdom;
  }

  Future<QuestionModel?> getQuestion() async {
    QuestionModel? _question;

    final response = await _api.getApi(url: GET_QUESTION_URL);
    if (response != null) {
      final res = response.data;

      if (res['result'] == 1) {
        _question = QuestionModel.fromJson(res['data']);
      } else {
        showErrorSnackBar(res['message']);
      }
    }

    return _question;
  }

  Future<bool> addAnswerQuestion(String qId, String aId) async {
    bool _isSuccess = false;

    final body = {
      "user_id": boxStorage.read(USER_ID),
      "user_token": boxStorage.read(TOKEN),
      "question_id": qId,
      "answer_id": aId,
    };

    final response =
        await _api.postApi(url: SET_ANSWER_QUESTION_URL, body: body);
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

  Future<List<RewardModel>> getRewards() async {
    List<RewardModel> _rewards = [];

    final response = await _api.getApi(url: GET_REWARDS_URL);
    if (response != null) {
      final res = response.data;

      if (res['result'] == 1) {
        final data = res['data'] as List;

        for (var d in data) {
          _rewards.add(RewardModel.fromJson(d));
        }
      } else {
        showErrorSnackBar(res['message']);
      }
    }

    return _rewards;
  }

  Future<List<PrivacyPolicyModel>> getPrivacyPolicy() async {
    List<PrivacyPolicyModel> _privacy = [];

    final response = await _api.getApi(url: GET_PRIVACY_POLICY_URL);
    if (response != null) {
      final res = response.data;

      if (res['result'] == 1) {
        final data = res['data'] as List;

        for (var d in data) {
          _privacy.add(PrivacyPolicyModel.fromJson(d));
        }
      } else {
        showErrorSnackBar(res['message']);
      }
    }

    return _privacy;
  }

  Future<String?> getBluPrint() async {
    String? data;

    final response = await _api.getApi(url: GET_BLUPRINT_URL);
    if (response != null) {
      final res = response.data;

      if (res['result'] == 1) {
        data = res['data'];
      } else {
        showErrorSnackBar(res['message']);
      }
    }

    return data;
  }

  Future<UserBackgroundModel?> getUserBackground() async {
    UserBackgroundModel? data;

    final params = {
      "user_id": boxStorage.read(USER_ID),
      "user_token": boxStorage.read(TOKEN),
    };

    final response =
        await _api.getApi(url: GET_USER_BACKGROUND_URL, params: params);
    if (response != null) {
      final res = response.data;

      if (res['result'] == 1) {
        data = UserBackgroundModel.fromJson(res['data'] ?? {});
      } else {
        showErrorSnackBar(res['message']);
      }
    }

    return data;
  }

  Future<List<NoteModel>> getNotes() async {
    List<NoteModel> _notes = [];

    final response = await _api.getApi(url: GET_WONDERIAN_NOTES);
    if (response != null) {
      final res = response.data;

      if (res['result'] == 1) {
        final data = res['data'] as List;

        for (var d in data) {
          _notes.add(NoteModel.fromJson(d));
        }
      } else {
        showErrorSnackBar(res['message']);
      }
    }

    return _notes;
  }

  Future<String> getTribeImage() async {
    String _image = '';

    final response = await _api.getApi(url: GET_TRIBE_IMAGE_URL);
    if (response != null) {
      final res = response.data;

      if (res['result'] == 1) {
        _image = res['default_img'] ?? "";
      } else {
        showErrorSnackBar(res['message']);
      }
    }

    return _image;
  }

  Future<String?> getTextLetter3dObject() async {
    String? _text;

    final response = await _api.getApi(url: GET_TEXT_LETTER_URL);
    if (response != null) {
      final res = response.data;

      if (res['result'] == 1) {
        _text = res['data']['text'] ?? "";
      } else {
        showErrorSnackBar(res['message']);
      }
    }

    return _text;
  }

  Future<List<HowItWorkModel>> getHowToWork() async {
    List<HowItWorkModel> _data = [];

    final response = await _api.getApi(url: GET_HOW_WORK_URL);
    if (response != null) {
      final res = response.data;

      if (res['result'] == 1) {
        final _dataJson = res['data'] as List;

        for (var d in _dataJson) {
          _data.add(HowItWorkModel.fromJson(d));
        }
      } else {
        showErrorSnackBar(res['message']);
      }
    }

    return _data;
  }
}
