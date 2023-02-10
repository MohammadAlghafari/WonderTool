import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import 'package:wonder_tool/connectors/user.dart';
import 'package:wonder_tool/controllers/user.dart';
import 'package:wonder_tool/helpers/local_storage.dart';
import 'package:wonder_tool/helpers/public.dart';
import 'package:wonder_tool/helpers/variables.dart';
import 'package:wonder_tool/screens/main/menu/feedback/feedback.dart';
import 'package:wonder_tool/screens/main/menu/reviews/reviews.dart';
import 'package:wonder_tool/screens/main/menu/guidebook/guidebook.dart';
import 'package:wonder_tool/apis/urls.dart';
import 'package:wonder_tool/themes/colors.dart';
import 'package:wonder_tool/widgets/loading_progress.dart';

class CustomDrawerWidget extends GetView<UserController> {
  const CustomDrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userConnector = UserConnector();

    final isOffline = controller.user.value.isOffline.obs;

    String _image = openAppWithInternet
        ? controller.user.value.image
        : boxStorage.read(USER_IMAGE) ?? "";
    String _name = openAppWithInternet
        ? "${controller.user.value.firstName} ${controller.user.value.lastName}"
        : boxStorage.read(USER_NAME) ?? "";
    String _nickname = openAppWithInternet
        ? controller.user.value.nickname
        : boxStorage.read(USER_NICKNAME) ?? "";
    String _userLink = openAppWithInternet
        ? controller.user.value.barCodeLink
        : boxStorage.read(USER_LINK) ?? "";

    void changeOnlineStatus(bool newValue) async {
      final isSuccess = await userConnector.updateStatus(!newValue);

      if (isSuccess) {
        controller.user.value.isOffline = !newValue;
        isOffline.value = !newValue;
      }
    }

    return Drawer(
      backgroundColor: lightBlackColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Stack(
          children: [
            ListView(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: _image.isEmpty
                                ? Image.asset(
                                    "assets/images/user.png",
                                    fit: BoxFit.cover,
                                  )
                                : CachedNetworkImage(
                                    imageUrl: "$BASE_IMAGE_URL$_image",
                                    fit: BoxFit.cover,
                                    errorWidget: (ctx, error, _) => Image.asset(
                                      "assets/images/launch.png",
                                    ),
                                    placeholder: (context, url) =>
                                        const LoadingProgressWidget(),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        AutoSizeText(
                          _name,
                          style: const TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          maxLines: 1,
                        ),
                        if (_nickname.isNotEmpty)
                          AutoSizeText(
                            _nickname,
                            style: const TextStyle(
                              color: grayColor,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                          ),
                        const SizedBox(height: 10),
                        Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Switch(
                                  inactiveTrackColor: lightGrayColor,
                                  activeColor: blueColor,
                                  value: !isOffline.value,
                                  onChanged: changeOnlineStatus,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                !isOffline.value ? "Online" : "Offline",
                                style: const TextStyle(
                                  color: primaryColor,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                ListTile(
                  onTap: () => Get.to(() => const FeedbackScreen()),
                  leading: SvgPicture.asset("assets/icons/feedback.svg"),
                  title: const AutoSizeText(
                    "My Feedbacks",
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 18,
                    ),
                    maxLines: 1,
                  ),
                  trailing: GetBuilder<UserController>(
                    builder: (controller) => Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (controller.feedbackNotificationCount > 0)
                          Badge(
                            padding: const EdgeInsets.all(7),
                            badgeColor: redColor,
                            badgeContent: AutoSizeText(
                              "${controller.feedbackNotificationCount}",
                              style: const TextStyle(
                                color: primaryColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        const SizedBox(width: 5),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: grayColor,
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  onTap: () => Get.to(() => const ReviewsScreen()),
                  leading: SvgPicture.asset("assets/icons/reviews.svg"),
                  title: const AutoSizeText(
                    "To Review",
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 18,
                    ),
                    maxLines: 1,
                  ),
                  trailing: GetBuilder<UserController>(
                    builder: (controller) => Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (controller.reviewNotificationCount > 0)
                          Badge(
                            padding: const EdgeInsets.all(7),
                            badgeColor: redColor,
                            badgeContent: AutoSizeText(
                              "${controller.reviewNotificationCount}",
                              style: const TextStyle(
                                color: primaryColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        const SizedBox(width: 5),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: grayColor,
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  onTap: () => Get.to(() => const GuideBookScreen()),
                  leading: SvgPicture.asset("assets/icons/guidebook.svg"),
                  title: const AutoSizeText(
                    "Guidebook",
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 18,
                    ),
                    maxLines: 1,
                  ),
                  trailing: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: grayColor,
                      ),
                    ],
                  ),
                ),
                if (_userLink.isNotEmpty)
                  InkWell(
                    onTap: () async {
                      await Clipboard.setData(
                        ClipboardData(text: controller.user.value.barCodeLink),
                      );
                      showSuccessSnackBar("URL is copied");
                    },
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 230,
                          child: SfBarcodeGenerator(
                            value: _userLink,
                            symbology: QRCode(),
                            barColor: primaryColor,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            AutoSizeText(
                              "Digital ID",
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 18,
                              ),
                              maxLines: 1,
                            ),
                            SizedBox(width: 10),
                            Icon(
                              Icons.copy,
                              color: grayColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "\u00a9 Wonder8 v. $buildVersionVAR",
                    style: const TextStyle(color: grayColor, fontSize: 10),
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
