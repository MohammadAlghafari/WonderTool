import 'package:get/get.dart';
import 'package:wonder_tool/models/news.dart';

class NewsController extends GetxController {
  List<NewsModel> news = [];
  List<NewsModel> allNews = [];

  void toogleLikeNew(String newsId) {
    final r = news.firstWhereOrNull((element) => element.id == newsId);
    if (r != null) {
      if (r.isLiked) {
        r.numberLikes--;
      } else {
        r.numberLikes++;
      }

      r.isLiked = !r.isLiked;

      update();
    }
  }

  void addComment(String newsId) {
    final r = news.firstWhereOrNull((element) => element.id == newsId);
    if (r != null) {
      r.numberComments++;

      update();
    }
  }
}
