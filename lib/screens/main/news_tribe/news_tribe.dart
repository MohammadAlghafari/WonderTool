import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wonder_tool/connectors/news.dart';
import 'package:wonder_tool/controllers/news.dart';
import 'package:wonder_tool/controllers/user.dart';
import 'package:wonder_tool/helpers/constants.dart';
import 'package:wonder_tool/helpers/public.dart';
import 'package:wonder_tool/helpers/validations.dart';
import 'package:wonder_tool/models/news.dart';
import 'package:wonder_tool/screens/main/news_tribe/widgets/input_editor.dart';
import 'package:wonder_tool/screens/main/news_tribe/widgets/news_item.dart';
import 'package:wonder_tool/apis/urls.dart';
import 'package:wonder_tool/themes/colors.dart';
import 'package:wonder_tool/themes/styles.dart';
import 'package:wonder_tool/widgets/animation_list.dart';
import 'package:wonder_tool/widgets/custom_shimmer.dart';
import 'package:wonder_tool/widgets/header_refresh.dart';
import 'package:wonder_tool/widgets/loading_progress.dart';

class NewsTribeScreen extends StatefulWidget {
  const NewsTribeScreen({Key? key}) : super(key: key);

  @override
  State<NewsTribeScreen> createState() => _NewsTribeScreenState();
}

class _NewsTribeScreenState extends State<NewsTribeScreen> {
  final _newsConnector = NewsConnector();
  final _newsController = Get.find<NewsController>();
  final _userController = Get.find<UserController>();

  final TextEditingController _searchController = TextEditingController();
  final _isTypingSearch = false.obs;

  final _smartRefreshController = RefreshController(initialRefresh: false);
  final _videoUrlEditingController = TextEditingController();

  final _postData = ''.obs;
  final _typeClicked = ''.obs;
  final _isLoadingFirstTime = true.obs;
  final _isLoadingAddPost = false.obs;

  int _from = 0;
  bool isLastData = false;
  bool isFirstTime = true;

  final _image = File("").obs;

  @override
  void initState() {
    if (_userController.hasNewsNotification) {
      _userController.readNewsNotification();
    }
    _getData(true);
    super.initState();
  }

  Future<void> _getPhoto(bool isFromCamera) async {
    final image = await checkPermissionImageHelper(isFromCamera);

    if (image == null) {
      return;
    }

    _image.value = File(image.path);
    Get.back();
  }

  Future<void> _getData(bool isRefresh) async {
    if (isRefresh) {
      isLastData = false;
      isFirstTime = true;
      _isLoadingFirstTime.value = true;

      _from = 0;
      _newsController.news.clear();
    }

    if (isLastData) {
      _smartRefreshController.loadComplete();
      return;
    }

    List<NewsModel> _allNews = await _newsConnector.getNews(_from);

    _from += COUNT_NEWS;

    if (_allNews.length < COUNT_NEWS) {
      isLastData = true;
    }

    if (_isLoadingFirstTime.value) {
      _isLoadingFirstTime.value = false;
    }

    if (isFirstTime) {
      _newsController.news = _allNews;
      _newsController.allNews = _allNews;
      isFirstTime = false;
    } else {
      _newsController.news.addAll(_allNews);
      _newsController.allNews.addAll(_allNews);
    }

    _newsController.update();

    if (isRefresh) {
      _smartRefreshController.refreshCompleted();
    } else {
      _smartRefreshController.loadComplete();
    }
  }

  void _onDoneInputEditor(String text) {
    _postData.value = text;
  }

  void _addPost() async {
    if (_postData.value.isEmpty) {
      showErrorSnackBar("Please put a text");
      return;
    }

    _isLoadingAddPost.value = true;

    String? image;
    if (_typeClicked.value == TYPE_IMAGE && _image.value.path.isNotEmpty) {
      image = imageToBase64Helper(_image.value);
    }

    String? video;
    if (_typeClicked.value == TYPE_YOUTUBE_URL &&
        _videoUrlEditingController.text.isNotEmpty) {
      if (!validateYoutubeUrl(_videoUrlEditingController.text)) {
        showErrorSnackBar("Please Put a valid youtube URL");
        _isLoadingAddPost.value = false;
        return;
      }

      video = _videoUrlEditingController.text.trim();
    }

    final _isSuccess =
        await _newsConnector.addNew(_postData.value, image, video);

    _isLoadingAddPost.value = false;

    if (_isSuccess) {
      _image.value = File('');
      _postData.value = '';
      _videoUrlEditingController.clear();
      _typeClicked.value = TYPE_TEXT;

      _getData(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: NestedScrollView(
        controller: ScrollController(initialScrollOffset: 50),
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: secondColor,
              elevation: 0,
              centerTitle: false,
              floating: true,
              actions: const [
                SizedBox(),
              ],
              flexibleSpace: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Obx(
                  () => Row(
                    children: [
                      const Icon(
                        Icons.search,
                        color: primaryColor,
                        size: 30,
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: TextFormField(
                          controller: _searchController,
                          style: smallTextInputWhiteStyle,
                          maxLines: 1,
                          decoration: inputStyle(
                            "Search..",
                            !_isTypingSearch.value,
                            () {
                              _searchController.clear();
                              _isTypingSearch.value = false;
                              _newsController.news = _newsController.allNews;
                              _newsController.update();
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                          ),
                          onChanged: (value) {
                            if (value.trim().isEmpty) {
                              _isTypingSearch.value = false;
                              _newsController.news = _newsController.allNews;
                            } else {
                              _isTypingSearch.value = true;
                              _newsController.news = _newsController.allNews
                                  .where((element) =>
                                      element.user!.firstName
                                          .toLowerCase()
                                          .contains(value.toLowerCase()) ||
                                      element.user!.lastName
                                          .toLowerCase()
                                          .contains(value.toLowerCase()) ||
                                      element.description
                                          .toLowerCase()
                                          .contains(value.toLowerCase()))
                                  .toList();
                            }
                            _newsController.update();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: SmartRefresher(
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
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: GetX<UserController>(
                        builder: (controller) => SizedBox(
                          height: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: controller.user.value.image.isEmpty
                                ? Image.asset(
                                    "assets/images/user.png",
                                    fit: BoxFit.cover,
                                  )
                                : CachedNetworkImage(
                                    imageUrl:
                                        "$BASE_IMAGE_URL${controller.user.value.image}",
                                    fit: BoxFit.cover,
                                    errorWidget: (ctx, error, _) => Image.asset(
                                      "assets/images/user.png",
                                    ),
                                    placeholder: (context, url) => Image.asset(
                                      "assets/images/user.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Flexible(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            onTap: () async {
                              await Get.bottomSheet(
                                InputEditorWidget(
                                  onDone: _onDoneInputEditor,
                                  data: _postData.value,
                                ),
                                isScrollControlled: true,
                                backgroundColor:
                                    const Color.fromARGB(255, 18, 18, 18),
                                enableDrag: false,
                                ignoreSafeArea: false,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                ),
                              );
                              SystemChannels.textInput.invokeMethod('TextInput.hide');
                            },
                            title: Obx(
                              () => AutoSizeText(
                                _postData.value.isEmpty
                                    ? "What's Happening?"
                                    : _postData.value,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: _postData.value.isEmpty
                                      ? primaryColor.withOpacity(0.5)
                                      : primaryColor,
                                  fontSize: 20,
                                ),
                                maxLines: 2,
                              ),
                            ),
                          ),
                          const Divider(
                            color: lightGrayColor,
                            height: 0.5,
                          ),
                          Obx(
                            () => Column(
                              children: [
                                SizedBox(
                                  height: _typeClicked.value == TYPE_IMAGE
                                      ? 20
                                      : _typeClicked.value == TYPE_YOUTUBE_URL
                                          ? 10
                                          : 0,
                                ),
                                _typeClicked.value == TYPE_IMAGE
                                    ? InkWell(
                                        onTap: () => pickImageHelper(
                                            _getPhoto, false, null),
                                        child: Container(
                                          height: 100,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: lightBlackColor,
                                            borderRadius: BorderRadius.circular(
                                              defaultRaduis,
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              defaultRaduis,
                                            ),
                                            child: _image.value.path.isEmpty
                                                ? const Center(
                                                    child: Icon(
                                                      Icons.add,
                                                      color: primaryColor,
                                                    ),
                                                  )
                                                : Image.file(
                                                    _image.value,
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                        ),
                                      )
                                    : _typeClicked.value == TYPE_YOUTUBE_URL
                                        ? TextField(
                                            style: const TextStyle(
                                              color: primaryColor,
                                              fontSize: 16,
                                            ),
                                            controller:
                                                _videoUrlEditingController,
                                            decoration: postInputStyle(
                                              "https://youtu.be/...",
                                            ),
                                          )
                                        : const SizedBox(),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  _typeClicked.value = TYPE_TEXT;
                                },
                                child: SvgPicture.asset(
                                  "assets/icons/text.svg",
                                  color: lightGrayColor.withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(width: 13),
                              InkWell(
                                onTap: () {
                                  _typeClicked.value = TYPE_IMAGE;
                                },
                                child: SvgPicture.asset(
                                  "assets/icons/gallery.svg",
                                  width: 20,
                                ),
                              ),
                              const SizedBox(width: 13),
                              InkWell(
                                onTap: () {
                                  _typeClicked.value = TYPE_YOUTUBE_URL;
                                },
                                child: Icon(
                                  Icons.video_camera_back_outlined,
                                  color: lightGrayColor.withOpacity(0.7),
                                ),
                              ),
                              const Spacer(),
                              Obx(
                                () => _isLoadingAddPost.value
                                    ? const LoadingProgressWidget()
                                    : ElevatedButton(
                                        onPressed: _addPost,
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 25,
                                            vertical: 0,
                                          ),
                                          textStyle: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        child: const AutoSizeText(
                                          "Post",
                                          maxLines: 1,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Divider(
                height: 2,
                thickness: 1,
                color: grayColor.withOpacity(0.5),
              ),
              Obx(
                () => _isLoadingFirstTime.value
                    ? const CustomShimmerWidget(isComment: false)
                    : GetBuilder<NewsController>(
                        init: NewsController(),
                        builder: (controller) => AnimationLimiter(
                          child: ListView.separated(
                            itemCount: controller.news.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            separatorBuilder: (_, __) => Divider(
                              height: 2,
                              thickness: 1,
                              color: grayColor.withOpacity(0.5),
                            ),
                            itemBuilder: (context, index) {
                              return AnimationListWidget(
                                index: index,
                                isVertical: true,
                                child: NewsItemWidget(
                                  post: controller.news[index],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _smartRefreshController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
