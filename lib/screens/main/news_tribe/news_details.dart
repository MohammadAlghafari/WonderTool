import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:wonder_tool/connectors/news.dart';
import 'package:wonder_tool/controllers/news.dart';
import 'package:wonder_tool/helpers/constants.dart';
import 'package:wonder_tool/helpers/public.dart';
import 'package:wonder_tool/models/news.dart';
import 'package:wonder_tool/screens/main/menu/drawer.dart';
import 'package:wonder_tool/screens/main/news_tribe/comments.dart';
import 'package:wonder_tool/apis/urls.dart';
import 'package:wonder_tool/themes/colors.dart';
import 'package:wonder_tool/widgets/custom_app_bar.dart';
import 'package:wonder_tool/widgets/custom_safe_area.dart';
import 'package:wonder_tool/widgets/hero_raduis.dart';
import 'package:wonder_tool/widgets/loading_progress.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class NewsDetailsScreen extends GetView<NewsController> {
  final NewsModel post;

  const NewsDetailsScreen({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _newsConnector = NewsConnector();
    YoutubePlayerController? _youtubePlayerController;

    if (post.video.isNotEmpty) {
      _youtubePlayerController = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(post.video)!,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
        ),
      );
    }

    String postDate = DateFormat("d MMM").format(post.date!);

    bool toggleLike(bool isLike) {
      _newsConnector.toggleLikeNew(isLike, post.id);
      controller.toogleLikeNew(post.id);

      return !isLike;
    }

    return CustomSafeArea(
      child: Scaffold(
        endDrawer: const CustomDrawerWidget(),
        appBar: customeAppBar(
          title: "News & Events",
          hasBack: true,
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          children: [
            Row(
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Hero(
                      createRectTween: (begin, end) =>
                          MaterialRectCenterArcTween(begin: begin, end: end),
                      tag: "user_prof${post.id}",
                      child: RadialExpansion(
                        maxRadius: 128,
                        child: post.user!.image.isEmpty
                            ? Image.asset(
                                "assets/images/user.png",
                                fit: BoxFit.cover,
                              )
                            : CachedNetworkImage(
                                imageUrl: "$BASE_IMAGE_URL${post.user!.image}",
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
                const SizedBox(width: 15),
                Row(
                  children: [
                    AutoSizeText(
                      "${post.user!.firstName} ${post.user!.lastName}",
                      style: const TextStyle(
                        color: primaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: CircleAvatar(
                        radius: 2,
                        backgroundColor: grayColor,
                      ),
                    ),
                    AutoSizeText(
                      postDate,
                      style: const TextStyle(color: grayColor, fontSize: 15),
                      maxLines: 1,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Html(
              onLinkTap: (url, context, attributes, element) => openLink(url!),
              data: post.description,
              style: {
                "body": Style(
                  color: primaryColor,
                ),
              },
            ),
            const SizedBox(height: 20),
            if (post.video.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(defaultRaduis),
                child: YoutubePlayer(
                  controller: _youtubePlayerController!,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: blueColor,
                  bottomActions: [
                    const SizedBox(width: 14.0),
                    CurrentPosition(),
                    const SizedBox(width: 8.0),
                    ProgressBar(isExpanded: true),
                    RemainingDuration(),
                    const PlaybackSpeedButton(),
                  ],
                ),
              ),
            if (post.image.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(defaultRaduis),
                child: Hero(
                  tag: "news_img${post.id}",
                  child: CachedNetworkImage(
                    imageUrl: "$BASE_IMAGE_URL${post.image}",
                    fit: BoxFit.cover,
                    errorWidget: (ctx, error, _) => Image.asset(
                      "assets/images/launch.png",
                    ),
                    placeholder: (context, url) =>
                        const LoadingProgressWidget(),
                  ),
                ),
              ),
            if (post.image.isNotEmpty || post.video.isNotEmpty)
              const SizedBox(height: 20),
            const SizedBox(height: 10),
            GetBuilder<NewsController>(
              builder: (controller) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      LikeButton(
                        isLiked: post.isLiked,
                        size: 20,
                        circleColor: const CircleColor(
                          start: Color(0xff00ddff),
                          end: Color(0xff0099cc),
                        ),
                        bubblesColor: const BubblesColor(
                          dotPrimaryColor: Color.fromARGB(255, 241, 241, 241),
                          dotSecondaryColor: Color.fromARGB(255, 200, 200, 200),
                        ),
                        likeBuilder: (bool isLiked) {
                          return Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? blueColor : primaryColor,
                            size: 18,
                          );
                        },
                        likeCountPadding: const EdgeInsets.only(
                          left: 5,
                        ),
                        countBuilder: (count, isLiked, text) {
                          Widget result = AutoSizeText(
                            text,
                            style: const TextStyle(
                              color: primaryColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          );

                          return result;
                        },
                        likeCount: post.numberLikes,
                        onTap: (val) async => toggleLike(val),
                      ),
                      const SizedBox(width: 20),
                      InkWell(
                        onTap: () => Get.to(
                          () => CommentsScreen(newsId: post.id),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/comment.svg",
                              width: 15,
                              height: 15,
                            ),
                            const SizedBox(width: 8),
                            AutoSizeText(
                              post.numberComments.toString(),
                              style: const TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                          ],
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
    );
  }
}
