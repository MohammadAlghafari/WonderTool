import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wonder_tool/helpers/local_storage.dart';
import 'package:wonder_tool/helpers/public.dart';
import 'package:wonder_tool/screens/main/board.dart';
import 'package:wonder_tool/screens/main/work/start.dart';
import 'package:wonder_tool/themes/colors.dart';
import 'package:wonder_tool/themes/styles.dart';

class GetStartScreen extends StatelessWidget {
  const GetStartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _checkIfToday(int indexPage) async {
      final _isSameDay = await checkDateEvery7Days(DATE_QUESTION);
      if (_isSameDay) {
        Get.off(() => BoardScreen(indexPage: indexPage));
      } else {
        Get.off(() => StartWorkScreen(indexPage: indexPage));
      }
    }

    return SafeArea(
      bottom: false,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 6,
              child: InkWell(
                onTap: () => _checkIfToday(3),
                child: Container(
                  alignment: Alignment.center,
                  color: secondColor,
                  child: const AutoSizeText(
                    "Start Work",
                    maxLines: 1,
                    style: bigTitleWhiteStyle,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: InkWell(
                onTap: () => _checkIfToday(1),
                child: Container(
                  alignment: Alignment.center,
                  color: blueColor,
                  child: const AutoSizeText(
                    "Check on\nmy tribe",
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: bigTitleWhiteStyle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
