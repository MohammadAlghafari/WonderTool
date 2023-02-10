import 'package:wonder_tool/helpers/local_storage.dart';
import 'package:wonder_tool/helpers/public.dart';
import 'package:wonder_tool/models/comment.dart';
import 'package:wonder_tool/models/news.dart';
import 'package:wonder_tool/apis/api.dart';
import 'package:wonder_tool/apis/urls.dart';

class NewsConnector {
  final _api = ApiService();

  Future<List<NewsModel>> getNews(int from) async {
    List<NewsModel> _news = [];

    final params = {
      "user_token": boxStorage.read(TOKEN),
      "user_id": boxStorage.read(USER_ID),
      "limit": COUNT_NEWS,
      "offset": from,
    };

    final response = await _api.getApi(url: GET_NEWS_URL, params: params);
    if (response != null) {
      final res = response.data;

      if (res['result'] == 1) {
        final data = res['data'] as List;

        for (var d in data) {
          _news.add(NewsModel.fromJson(d));
        }
      } else {
        showErrorSnackBar(res['message']);
      }
    }

    return _news;
  }

  Future<bool> addNew(String text, String? image, String? video) async {
    bool _isSuccess = false;

    final body = {
      "user_token": boxStorage.read(TOKEN),
      "user_id": boxStorage.read(USER_ID),
      "description": text,
    };

    if (image != null) {
      body['main_img'] = image;
    }

    if (video != null) {
      body['video_link'] = video;
    }

    final response = await _api.postApi(url: ADD_NEWS_URL, body: body);
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

  Future<bool> toggleLikeNew(bool isLike, String newsId) async {
    bool _isSuccess = false;

    final body = {
      "user_token": boxStorage.read(TOKEN),
      "user_id": boxStorage.read(USER_ID),
      "news_id": newsId,
      "flag": isLike ? 0 : 1,
    };

    final response = await _api.postApi(url: LIKE_NEWS_URL, body: body);
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

  Future<List<CommentModel>> getCommentsNews(int from, String newsId) async {
    List<CommentModel> _comments = [];

    final params = {
      "user_token": boxStorage.read(TOKEN),
      "user_id": boxStorage.read(USER_ID),
      "news_id": newsId,
      "limit": COUNT_COMMENTS,
      "offset": from,
    };

    final response = await _api.getApi(url: GET_COMMENTS_URL, params: params);
    if (response != null) {
      final res = response.data;

      if (res['result'] == 1) {
        final data = res['data'] as List;

        for (var d in data) {
          _comments.add(CommentModel.fromJson(d));
        }
      } else {
        showErrorSnackBar(res['message']);
      }
    }

    return _comments;
  }

  Future<bool> addComment(String newsId, String text) async {
    bool _isSuccess = false;

    final body = {
      "user_token": boxStorage.read(TOKEN),
      "user_id": boxStorage.read(USER_ID),
      "news_id": newsId,
      "comment": text,
    };

    final response = await _api.postApi(url: ADD_COMMENT_URL, body: body);
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
