import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart' as handler;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wonder_tool/helpers/local_storage.dart';
import 'package:wonder_tool/screens/splash/how_works.dart';
import 'package:wonder_tool/themes/colors.dart';

void showErrorSnackBar(String message) {
  Get.snackbar(
    message,
    '',
    backgroundColor: primaryColor,
    snackPosition: SnackPosition.BOTTOM,
  );
}

void showSuccessSnackBar(String message) {
  Get.snackbar(
    message,
    '',
    backgroundColor: blueColor,
    snackPosition: SnackPosition.BOTTOM,
    colorText: primaryColor,
  );
}

void pickImageHelper(
  Function(bool) onPickImage,
  bool hasRemove,
  Function()? onRemoveImage,
) async {
  await Get.bottomSheet(
    SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const AutoSizeText(
              "Choose From",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
              maxLines: 1,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () => onPickImage(false),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/images/gallery.png",
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 5),
                      const AutoSizeText(
                        "Gallery",
                        style: TextStyle(
                          fontSize: 14,
                          color: primaryColor,
                        ),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => onPickImage(true),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/images/camera.png",
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 5),
                      const AutoSizeText(
                        "Camera",
                        style: TextStyle(
                          fontSize: 14,
                          color: primaryColor,
                        ),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                if (hasRemove)
                  InkWell(
                    onTap: onRemoveImage,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/images/remove.png",
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 5),
                        const AutoSizeText(
                          "Remove",
                          style: TextStyle(
                            fontSize: 14,
                            color: primaryColor,
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    ),
    backgroundColor: lightBlackColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    ),
  );
}

Future<File?> checkPermissionImageHelper(bool isFromCamera) async {
  var status = isFromCamera
      ? await handler.Permission.camera.status
      : await handler.Permission.photos.status;

  if (status.isGranted || status.isDenied) {
    final image = await ImagePicker().pickImage(
      source: isFromCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 50,
    );

    if (image != null) {
      return File(image.path);
    }

    return null;
  } else {
    await Get.defaultDialog(
      title: isFromCamera ? "Camera Permission" : "Gallery Permission",
      content: AutoSizeText(
        isFromCamera
            ? "This app needs access to Camera"
            : "This app needs to access to Gallery",
        maxLines: 2,
      ),
      actions: [
        TextButton(
          child: const AutoSizeText(
            "Deny",
            maxLines: 1,
          ),
          onPressed: () => Get.back(),
        ),
        TextButton(
          child: const AutoSizeText(
            "Open Settings",
            maxLines: 1,
          ),
          onPressed: () => handler.openAppSettings(),
        ),
      ],
    );

    return null;
  }
}

String imageToBase64Helper(File file) {
  List<int> imageBytes = file.readAsBytesSync();
  String base64 = base64Encode(imageBytes);
  return "data:image/jpeg;base64,$base64";
}

void showIntroIsFirstTime() async {
  bool isFristTime = boxStorage.read(IS_FIRST_TIME) ?? true;

  if (isFristTime) {
    boxStorage.write(IS_FIRST_TIME, false);

    Timer(const Duration(seconds: 35), () {
      Get.to(
        () => const HowItWorksScreen(),
        transition: Transition.downToUp,
      );
    });
  }
}

void openLink(String link) async {
  final Uri url;
  if (link.contains('pdf') && Platform.isAndroid) {
    url = Uri.parse('https://docs.google.com/gview?embedded=true&url=$link');
  } else {
    url = Uri.parse(link);
  }
  if (await canLaunchUrl(url)) {
    await launchUrl(
      url,
    );
  } else {
    print("Could not launch $url");
  }
}

Future<bool> checkDateIsToday(String keyStorage) async {
  bool isSameDay = false;

  String date = boxStorage.read(keyStorage) ?? "";
  if (date.isEmpty) {
    final _format = DateFormat("yyyy-MM-dd").format(DateTime.now());
    await boxStorage.write(keyStorage, _format);
  } else {
    final _now = DateTime.now();
    final _today = DateTime(_now.year, _now.month, _now.day);

    final _date = DateFormat("yyyy-MM-dd").parse(date);
    final _aDate = DateTime(_date.year, _date.month, _date.day);

    if (_aDate == _today) {
      isSameDay = true;
    } else {
      final _format = DateFormat("yyyy-MM-dd").format(DateTime.now());
      await boxStorage.write(keyStorage, _format);
    }
  }

  return isSameDay;
}

Future<bool> checkDateEvery7Days(String keyStorage) async {
  bool isSameWeek = false;

  String date = boxStorage.read(keyStorage) ?? "";
  if (date.isEmpty) {
    final _format = DateFormat("yyyy-MM-dd").format(DateTime.now());
    await boxStorage.write(keyStorage, _format);
  } else {
    final _now = DateTime.now();
    final _today = DateTime(_now.year, _now.month, _now.day);

    final _date = DateFormat("yyyy-MM-dd").parse(date);
    final _aDate = DateTime(_date.year, _date.month, _date.day);

    final days = _today.difference(_aDate).inDays;

    if (days <= 7) {
      isSameWeek = true;
    } else {
      final _format = DateFormat("yyyy-MM-dd").format(DateTime.now());
      await boxStorage.write(keyStorage, _format);
    }
  }

  return isSameWeek;
}
