import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:wonder_tool/connectors/data.dart';
import 'package:wonder_tool/screens/main/menu/drawer.dart';
import 'package:wonder_tool/themes/colors.dart';
import 'package:wonder_tool/widgets/custom_app_bar.dart';
import 'package:wonder_tool/widgets/custom_safe_area.dart';
import 'package:wonder_tool/widgets/loading_progress.dart';

import '../../../../helpers/public.dart';

class BluPrintScreen extends StatelessWidget {
  const BluPrintScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return CustomSafeArea(
      child: Scaffold(
        endDrawer: const CustomDrawerWidget(),
        appBar: customeAppBar(
          title: 'BlüPrint',
          hasBack: true,
        ),
        body: FutureBuilder(
          future: DataConnector().getBluPrint(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingProgressWidget();
            } else {
              if (snapshot.hasError) {
                return AutoSizeText(snapshot.error.toString());
              } else {
                final data = snapshot.data as String?;
                if (data != null) {
                  return Html(
                    data: data,
                    onLinkTap: (url, context, attributes, element) =>
                        openLink(url!),
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
                  );
                } else {
                  return const SizedBox();
                }
              }
            }
          },
        ),
      ),
    );
  }
}
