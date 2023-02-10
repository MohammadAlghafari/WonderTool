import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:wonder_tool/connectors/auth.dart';
import 'package:wonder_tool/helpers/constants.dart';
import 'package:wonder_tool/helpers/local_storage.dart';
import 'package:wonder_tool/helpers/public.dart';
import 'package:wonder_tool/screens/main/board.dart';
import 'package:wonder_tool/screens/splash/get_start.dart';
import 'package:wonder_tool/screens/splash/splash.dart';
import 'package:wonder_tool/themes/colors.dart';
import 'package:wonder_tool/themes/styles.dart';
import 'package:wonder_tool/widgets/custom_safe_area.dart';
import 'package:wonder_tool/widgets/loading_progress.dart';
import 'package:auto_size_text/auto_size_text.dart';

class VerificationCodeScreen extends StatelessWidget {
  const VerificationCodeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _authConnector = AuthConnector();
    final _isLoading = false.obs;

    Future<void> _verify(String code) async {
      _isLoading.value = true;
      bool isSuccess = await _authConnector.verifyAccount(code);

      _isLoading.value = false;

      if (isSuccess) {
        final _isSameDay = await checkDateIsToday(DATE_SPLASH);
        if (_isSameDay) {
          final _isSame = await checkDateIsToday(DATE_GET_STARTED);
          if (_isSame) {
            Get.offAll(() => const BoardScreen(indexPage: 3));
          } else {
            Get.offAll(() => const GetStartScreen());
          }
        } else {
          Get.offAll(() => const SplashScreen());
        }
      }
    }

    return CustomSafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: paddingHorizontal,
            vertical: paddingVertical,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AutoSizeText(
                "Enter the\nCode sent\nto your email",
                maxLines: 3,
                style: bigTitleWhiteStyle,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 100, horizontal: 50),
                child: PinCodeTextField(
                  appContext: context,
                  length: 4,
                  textStyle: const TextStyle(
                    color: primaryColor,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                  keyboardType: TextInputType.number,
                  pinTheme: PinTheme(
                    activeColor: lightGrayColor,
                    inactiveColor: grayColor,
                    selectedColor: primaryColor,
                  ),
                  cursorHeight: 30,
                  onChanged: (value) {},
                  onCompleted: _verify,
                  animationCurve: Curves.bounceInOut,
                  animationDuration: const Duration(milliseconds: 100),
                ),
              ),
              const SizedBox(height: 40),
              if (_isLoading.value) const LoadingProgressWidget()
            ],
          ),
        ),
      ),
    );
  }
}
