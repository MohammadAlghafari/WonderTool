import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wonder_tool/connectors/auth.dart';
import 'package:wonder_tool/helpers/constants.dart';
import 'package:wonder_tool/helpers/local_storage.dart';
import 'package:wonder_tool/helpers/public.dart';
import 'package:wonder_tool/helpers/variables.dart';
import 'package:wonder_tool/screens/auth/login.dart';
import 'package:wonder_tool/screens/main/board.dart';
import 'package:wonder_tool/screens/splash/get_start.dart';
import 'package:wonder_tool/screens/splash/splash.dart';
import 'package:wonder_tool/widgets/custom_safe_area.dart';
import 'package:wonder_tool/widgets/loading_progress.dart';

class CheckLoginScreen extends StatefulWidget {
  const CheckLoginScreen({Key? key}) : super(key: key);

  @override
  State<CheckLoginScreen> createState() => _CheckLoginScreenState();
}

class _CheckLoginScreenState extends State<CheckLoginScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkData();
    });

    super.initState();
  }

  Future<void> checkData() async {
    bool isLogin = boxStorage.read(IS_LOGIN) ?? false;

    if (isLogin) {
      getUserData();
    } else {
      Get.off(() => const LoginScreen());
    }
  }

  Future<void> getUserData() async {
    final isSuccess = await AuthConnector().getUserData();
    if (isSuccess != null) {
      if (isSuccess) {
        final _isSameDay = await checkDateIsToday(DATE_SPLASH);
        if (_isSameDay) {
          final _isSame = await checkDateIsToday(DATE_GET_STARTED);
          if (_isSame) {
            Get.off(() => const BoardScreen(indexPage: 3));
          } else {
            Get.off(() => const GetStartScreen());
          }
        } else {
          Get.off(() => const SplashScreen());
        }
      } else {
        await boxStorage.erase();
        Get.off(() => const LoginScreen());
      }
    } else {
      openAppWithInternet = false;
      Get.off(() => const BoardScreen(indexPage: 3));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const CustomSafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 25,
            vertical: paddingVertical,
          ),
          child: LoadingProgressWidget(),
        ),
      ),
    );
  }
}
