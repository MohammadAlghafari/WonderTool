import 'package:get/get.dart';

final RegExp nameExp = RegExp(r'^[A-za-z ]+$');

String? validateName(String value) {
  if (value.isEmpty) {
    return "Please Fill this field";
  }

  if (value.length < 4) {
    return "Please put more than 4 characters";
  }
  if (!nameExp.hasMatch(value)) {
    return "Please put only characters";
  }
  return null;
}

String? validateEmail(String value) {
  if (value.isEmpty) {
    return "Please Fill this field";
  }
  if (!GetUtils.isEmail(value.trim())) {
    return "Please put a valid email";
  }
  return null;
}

String? validatePassword(String value) {
  if (value.isEmpty) return "Please Fill this field";
  if (value.length < 6) return "Please put more than 6 characters";
  return null;
}

String? validateMobile(String value) {
  if (value.isEmpty) {
    return "Please Fill this field";
  }
  return null;
}

String? validateInput(String value) {
  if (value.isEmpty) {
    return "Please Fill this field";
  }
  return null;
}

bool validateYoutubeUrl(String url) {
  final RegExp exp = RegExp(
      r'^((?:https?:)?\/\/)?((?:www|m)\.)?((?:youtube(-nocookie)?\.com|youtu.be))(\/(?:[\w\-]+\?v=|embed\/|v\/)?)([\w\-]+)(\S+)?$');

  if (exp.hasMatch(url)) {
    return true;
  }
  return false;
}
