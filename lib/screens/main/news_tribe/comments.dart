import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wonder_tool/connectors/news.dart';
import 'package:wonder_tool/controllers/news.dart';
import 'package:wonder_tool/helpers/public.dart';
import 'package:wonder_tool/models/comment.dart';
import 'package:wonder_tool/screens/main/menu/drawer.dart';
import 'package:wonder_tool/screens/main/news_tribe/widgets/comment_item.dart';
import 'package:wonder_tool/apis/urls.dart';
import 'package:wonder_tool/themes/colors.dart';
import 'package:wonder_tool/widgets/animation_list.dart';
import 'package:wonder_tool/widgets/custom_app_bar.dart';
import 'package:wonder_tool/widgets/custom_safe_area.dart';
import 'package:get/get.dart';
import 'package:wonder_tool/widgets/custom_shimmer.dart';
import 'package:wonder_tool/widgets/header_refresh.dart';

class CommentsScreen extends StatefulWidget {
  final String newsId;

  const CommentsScreen({
    Key? key,
    required this.newsId,
  }) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final _newsController = Get.find<NewsController>();
  final _newsConnector = NewsConnector();

  final _smartRefreshController = RefreshController(initialRefresh: true);
  final _commentEdittingController = TextEditingController();

  int _from = 0;
  bool isLastData = false;
  bool isFirstTime = true;

  final _isLoadingFirstTime = true.obs;
  final _isLoadingAddComment = false.obs;

  final _comments = <CommentModel>[].obs;

  Future<void> _getData(bool isRefresh) async {
    List<CommentModel> _allComments = [];

    if (isRefresh) {
      isLastData = false;
      _isLoadingFirstTime.value = true;
      _from = 0;

      _allComments.clear();
      _comments.clear();
    }

    _allComments = await _newsConnector.getCommentsNews(_from, widget.newsId);

    _from += COUNT_COMMENTS;

    if (_allComments.length < COUNT_COMMENTS) {
      isLastData = true;
      _smartRefreshController.loadNoData();
    }

    if (_isLoadingFirstTime.value) {
      _isLoadingFirstTime.value = false;
    }

    if (isFirstTime) {
      _comments.value = _allComments;
      isFirstTime = false;
    } else {
      _comments.addAll(_allComments);
    }

    if (isRefresh) {
      _smartRefreshController.refreshCompleted();
    } else {
      _smartRefreshController.loadComplete();
    }
  }

  void _addComment() async {
    if (_commentEdittingController.text.isEmpty) {
      return;
    }

    _isLoadingAddComment.value = true;

    final isSuccess = await _newsConnector.addComment(
      widget.newsId,
      _commentEdittingController.text,
    );

    _isLoadingAddComment.value = false;

    if (isSuccess) {
      _newsController.addComment(widget.newsId);

      Get.back();
      showSuccessSnackBar("Your comments has been added successfully");
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
      child: Scaffold(
        endDrawer: const CustomDrawerWidget(),
        appBar: customeAppBar(
          title: "Comments",
          hasBack: true,
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanDown: (_) {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Stack(
            children: [
              SmartRefresher(
                controller: _smartRefreshController,
                enablePullUp: true,
                header: const CustomHeaderRefreshWidget(),
                footer: CustomFooter(
                  builder: (context, status) {
                    return const Center(child: SizedBox());
                  },
                  height: 0,
                ),
                physics: const ScrollPhysics(),
                onRefresh: () async {
                  await _getData(true);
                },
                onLoading: () async {
                  await _getData(false);
                },
                child: Obx(
                  () => _isLoadingFirstTime.value
                      ? const CustomShimmerWidget(isComment: true)
                      : AnimationLimiter(
                          child: ListView.builder(
                            itemCount: _comments.length,
                            shrinkWrap: true,
                            reverse: true,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 20,
                            ),
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return AnimationListWidget(
                                index: index,
                                isVertical: true,
                                child: CommentItemWidget(
                                  comment: _comments[index],
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: TextFormField(
                  style: const TextStyle(
                    color: primaryColor,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    fillColor: lightBlackColor,
                    filled: true,
                    hintText: "Add comment...",
                    hintStyle: const TextStyle(
                      fontSize: 15,
                      color: primaryColor,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(width: 0),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(width: 0),
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Obx(
                        () => _isLoadingAddComment.value
                            ? const CircularProgressIndicator(
                                color: primaryColor,
                              )
                            : InkWell(
                                onTap: _addComment,
                                child: const Icon(
                                  Icons.send_outlined,
                                  color: primaryColor,
                                ),
                              ),
                      ),
                    ),
                  ),
                  controller: _commentEdittingController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
