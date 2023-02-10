import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wonder_tool/connectors/data.dart';
import 'package:wonder_tool/helpers/constants.dart';
import 'package:wonder_tool/helpers/local_storage.dart';
import 'package:wonder_tool/helpers/public.dart';
import 'package:wonder_tool/models/wisdom.dart';
import 'package:wonder_tool/screens/main/board.dart';
import 'package:wonder_tool/screens/splash/get_start.dart';
import 'package:wonder_tool/themes/styles.dart';
import 'package:wonder_tool/widgets/custom_safe_area.dart';
import 'package:wonder_tool/widgets/loading_progress.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late Animation<double> fadeAnimation;
  late AnimationController animationController;
  late Timer timer;

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(animationController);
    animationController.forward();

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    timer.cancel();

    super.dispose();
  }

  void _setTimer() {
    timer = Timer(
      const Duration(seconds: 5),
      () => goToNextPage(),
    );
  }

  void goToNextPage() async {
    final _isSame = await checkDateIsToday(DATE_GET_STARTED);
    if (_isSame) {
      Get.off(() => const BoardScreen(indexPage: 3));
    } else {
      Get.off(() => const GetStartScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: paddingHorizontal,
            vertical: paddingVertical,
          ),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => goToNextPage(),
            child: FutureBuilder(
              future: DataConnector().getWisdom(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingProgressWidget();
                } else {
                  if (snapshot.hasError) {
                    return AutoSizeText(snapshot.error.toString());
                  } else if (!snapshot.hasData) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Get.off(() => const BoardScreen(indexPage: 3));
                    });

                    return const SizedBox();
                  } else {
                    final _wisdom = snapshot.data as WisdomModel?;

                    if (_wisdom == null) {
                      return const AutoSizeText("Some Error");
                    }

                    _setTimer();

                    return AnimatedBuilder(
                      animation: animationController,
                      builder: (context, child) => FadeTransition(
                        opacity: fadeAnimation,
                        child: ListView(
                          children: [
                            AutoSizeText(
                              _wisdom.text,
                              style: bigTitleWhiteStyle,
                              maxLines: 4,
                            ),
                            const SizedBox(height: 50),
                            AutoSizeText(
                              "- ${_wisdom.auther}",
                              style: meduimWhiteStyle,
                              maxLines: 1,
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
        ),
      ),
    );
  }
}
