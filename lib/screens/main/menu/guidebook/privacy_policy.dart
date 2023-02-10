import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wonder_tool/connectors/data.dart';
import 'package:wonder_tool/models/privacy_policy.dart';
import 'package:wonder_tool/screens/main/menu/drawer.dart';
import 'package:wonder_tool/screens/main/menu/guidebook/privacy_policy_details.dart';
import 'package:wonder_tool/themes/colors.dart';
import 'package:wonder_tool/widgets/custom_app_bar.dart';
import 'package:wonder_tool/widgets/custom_safe_area.dart';
import 'package:wonder_tool/widgets/loading_progress.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
      child: Scaffold(
        endDrawer: const CustomDrawerWidget(),
        appBar: customeAppBar(
          title: 'Internal policies',
          hasBack: true,
        ),
        body: FutureBuilder(
          future: DataConnector().getPrivacyPolicy(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingProgressWidget();
            } else {
              if (snapshot.hasError) {
                return AutoSizeText(snapshot.error.toString());
              } else {
                final data = snapshot.data as List<PrivacyPolicyModel>;

                return ListView.builder(
                  itemCount: data.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 20,
                  ),
                  itemBuilder: (context, index) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.circle,
                          color: primaryColor,
                          size: 8,
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () => Get.to(
                            () => PrivacyPolicyDetailsScreen(
                              privacy: data[index],
                            ),
                            transition: Transition.rightToLeft,
                          ),
                          child: Text(
                            data[index].title,
                            style: const TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 17,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
