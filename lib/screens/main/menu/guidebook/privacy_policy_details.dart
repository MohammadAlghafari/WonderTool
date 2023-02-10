import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:wonder_tool/helpers/public.dart';
import 'package:wonder_tool/models/privacy_policy.dart';
import 'package:wonder_tool/screens/main/menu/drawer.dart';
import 'package:wonder_tool/themes/colors.dart';
import 'package:wonder_tool/widgets/custom_app_bar.dart';
import 'package:wonder_tool/widgets/custom_safe_area.dart';

class PrivacyPolicyDetailsScreen extends StatelessWidget {
  final PrivacyPolicyModel privacy;

  const PrivacyPolicyDetailsScreen({
    Key? key,
    required this.privacy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
      child: Scaffold(
        endDrawer: const CustomDrawerWidget(),
        appBar: customeAppBar(
          title: privacy.title,
          hasBack: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 20,
          ),
          child: Html(
            data: privacy.description,
            onLinkTap: (url, context, attributes, element) => openLink(url!),
            customRenders: {
              tableMatcher(): tableRender(),
            },
            style: {
              "body": Style(
                color: primaryColor,
              ),
              "table": Style(
                border: Border.all(color: primaryColor, width: 0.5),
              ),
              "th": Style(
                border: Border.all(color: primaryColor, width: 0.5),
              ),
              "td": Style(
                border: Border.all(color: primaryColor, width: 0.5),
              ),
            },
          ),
        ),
      ),
    );
  }
}
