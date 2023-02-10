import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:wonder_tool/controllers/user.dart';
import 'package:wonder_tool/screens/main/menu/guidebook/blu_print.dart';
import 'package:wonder_tool/screens/main/menu/guidebook/wonderian_note.dart';
import 'package:wonder_tool/screens/main/menu/guidebook/privacy_policy.dart';
import 'package:wonder_tool/screens/splash/how_works.dart';
import 'package:wonder_tool/themes/colors.dart';
import 'package:wonder_tool/widgets/custom_app_bar.dart';
import 'package:wonder_tool/widgets/custom_safe_area.dart';
import 'package:auto_size_text/auto_size_text.dart';

class GuideBookScreen extends GetView<UserController> {
  const GuideBookScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
      child: Scaffold(
        appBar:
            customeAppBar(title: 'Guidebook', showDrawer: false, hasBack: true),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 10),
          children: [
            ListTile(
              onTap: () => Get.to(() => const WonderianNotesScreen()),
              leading: const Icon(
                Icons.menu_book_rounded,
                color: lightGrayColor,
              ),
              title: const AutoSizeText(
                "Wonderian Notes",
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: grayColor,
              ),
            ),
            const Divider(
              color: lightGrayColor,
              thickness: 1,
            ),
            ListTile(
              onTap: () => Get.to(() => const PrivacyPolicyScreen()),
              leading: const Icon(
                Icons.privacy_tip_outlined,
                color: lightGrayColor,
              ),
              title: const AutoSizeText(
                "Policies And Guidelines",
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: grayColor,
              ),
            ),
            const Divider(
              color: lightGrayColor,
              thickness: 1,
            ),
            ListTile(
              onTap: () {
                if (controller.user.value.isFreelancer) {
                  return;
                }

                Get.to(() => const HowItWorksScreen());
              },
              leading: const Icon(
                Icons.contact_support_outlined,
                color: lightGrayColor,
              ),
              title: const AutoSizeText(
                "How It Works: App Demo",
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: grayColor,
              ),
            ),
            const Divider(
              color: lightGrayColor,
              thickness: 1,
            ),
            ListTile(
              onTap: () {
                if (controller.user.value.isFreelancer) {
                  return;
                }

                Get.to(() => const BluPrintScreen());
              },
              leading: SvgPicture.asset(
                "assets/icons/ruler.svg",
                color: lightGrayColor,
                width: 25,
                height: 25,
              ),
              title: const AutoSizeText(
                "BlüPrint",
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: grayColor,
              ),
            ),
            const Divider(
              color: lightGrayColor,
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }
}
