import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wonder_tool/controllers/user.dart';
import 'package:wonder_tool/apis/urls.dart';
import 'package:wonder_tool/themes/colors.dart';
import 'package:wonder_tool/themes/styles.dart';
import 'package:wonder_tool/widgets/loading_progress.dart';

AppBar customeAppBar({required String title, bool? showDrawer, bool? hasBack}) {
  final userController = Get.find<UserController>();

  var userProfile = Builder(
    builder: (context) => InkWell(
      onTap: () => Scaffold.of(context).openEndDrawer(),
      child: SizedBox(
        width: 40,
        height: 40,
        child: Obx(
          () => ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: userController.user.value.image.isEmpty
                ? Image.asset(
                    "assets/images/user.png",
                    fit: BoxFit.cover,
                  )
                : CachedNetworkImage(
                    imageUrl:
                        "$BASE_IMAGE_URL${userController.user.value.image}",
                    fit: BoxFit.cover,
                    errorWidget: (ctx, error, _) => Image.asset(
                      "assets/images/launch.png",
                    ),
                    placeholder: (context, url) =>
                        const LoadingProgressWidget(),
                  ),
          ),
        ),
      ),
    ),
  );

  return AppBar(
    backgroundColor: secondColor,
    elevation: 0,
    toolbarHeight: 85,
    centerTitle: false,
    actions: const [
      SizedBox(),
    ],
    leading: const SizedBox(),
    flexibleSpace: Container(
      padding: const EdgeInsets.only(right: 20, left: 10, bottom: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (hasBack != null)
            InkWell(
              onTap: () => Get.back(),
              child: const Icon(
                Icons.arrow_back_ios_rounded,
                color: primaryColor,
                size: 30,
              ),
            ),
          Padding(
            padding: EdgeInsets.only(left: hasBack != null ? 20 : 10),
            child: title.contains("Performance")
                ? Text.rich(
                    TextSpan(
                      text: title,
                      children: const [
                        TextSpan(
                          text: " (Beta)",
                          style: TextStyle(color: grayColor),
                        ),
                      ],
                    ),
                    style: titleWhiteAppBarStyle,
                  )
                : AutoSizeText(
                    title,
                    style: titleWhiteAppBarStyle,
                    maxLines: 1,
                  ),
          ),
          // title == "Work"
          //     ? const Expanded(child: SearchBarWorkWidget())
          //     : const Spacer(),
          const Spacer(),
          if (showDrawer == null)
            GetBuilder<UserController>(builder: (controller) {
              int count = controller.feedbackNotificationCount +
                  controller.reviewNotificationCount;

              return count > 0
                  ? Badge(
                      badgeColor: redColor,
                      position: BadgePosition.topEnd(top: -10, end: -8),
                      badgeContent: AutoSizeText(
                        "$count",
                        style: const TextStyle(
                          color: primaryColor,
                          fontSize: 16,
                        ),
                      ),
                      child: userProfile,
                    )
                  : userProfile;
            }),
        ],
      ),
    ),
  );
}
