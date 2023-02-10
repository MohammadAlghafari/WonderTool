import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wonder_tool/connectors/auth.dart';
import 'package:wonder_tool/helpers/constants.dart';
import 'package:wonder_tool/screens/auth/verification_code.dart';
import 'package:wonder_tool/themes/colors.dart';
import 'package:wonder_tool/themes/styles.dart';
import 'package:wonder_tool/widgets/custom_safe_area.dart';
import 'package:wonder_tool/widgets/loading_progress.dart';
import 'package:auto_size_text/auto_size_text.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _authConnector = AuthConnector();

    final _emailController = TextEditingController().obs;
    var _isDisabled = true.obs;
    var _isHideClearIcon = true.obs;
    var _isLoading = false.obs;

    Future<void> _sendCode() async {
      if (_isDisabled.value) return;

      _isLoading.value = true;
      final _isSuccess =
          await _authConnector.login(_emailController.value.text);

      _isLoading.value = false;
      if (_isSuccess) {
        Get.to(() => const VerificationCodeScreen());
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
                "Login\nwith your\nregistered\nemail",
                style: bigTitleWhiteStyle,
                maxLines: 4,
              ),
              Obx(
                () => Padding(
                  padding: const EdgeInsets.only(top: 95, bottom: 130),
                  child: TextField(
                    style: smallTextInputWhiteStyle,
                    controller: _emailController.value,
                    decoration:
                        inputStyle("Email Address", _isHideClearIcon.value, () {
                      _emailController.value.clear();
                      _isDisabled.value = true;
                    }),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        _isHideClearIcon.value = false;
                      } else {
                        _isHideClearIcon.value = true;
                      }

                      if (value.isEmpty || !GetUtils.isEmail(value)) {
                        _isDisabled.value = true;
                      } else if (GetUtils.isEmail(value)) {
                        _isDisabled.value = false;
                      }
                    },
                  ),
                ),
              ),
              Center(
                child: Obx(
                  () => _isLoading.value
                      ? const LoadingProgressWidget()
                      : ElevatedButton(
                          onPressed: _sendCode,
                          child: const AutoSizeText(
                            "Send Code",
                            maxLines: 1,
                          ),
                          style: ElevatedButton.styleFrom(
                            foregroundColor:
                                _isDisabled.value ? grayColor : secondColor,
                            backgroundColor: _isDisabled.value
                                ? lightGrayColor
                                : primaryColor,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
