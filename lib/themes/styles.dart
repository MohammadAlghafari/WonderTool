import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:wonder_tool/themes/colors.dart';

const bigTitleWhiteStyle = TextStyle(
  fontSize: 44,
  color: primaryColor,
  fontWeight: FontWeight.w700,
  height: 1,
);

const titleWhiteAppBarStyle = TextStyle(
  fontSize: 25,
  color: primaryColor,
  fontWeight: FontWeight.w700,
  height: 1,
  letterSpacing: -0.4,
);

const meduimWhiteStyle = TextStyle(
  fontSize: 20,
  color: primaryColor,
  fontWeight: FontWeight.w600,
);

const smallTextInputWhiteStyle = TextStyle(
  fontSize: 15,
  color: primaryColor,
);

InputDecoration inputStyle(
  String hint,
  bool isHideClearIcon,
  Function() clearText,
) {
  return InputDecoration(
    contentPadding: EdgeInsets.zero,
    hintText: hint,
    hintStyle: TextStyle(
      fontSize: 17,
      color: darkGrayInputColor.withOpacity(0.6),
    ),
    filled: true,
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: lightGrayColor, width: 0.2),
    ),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: lightGrayColor, width: 0.2),
    ),
    suffix: isHideClearIcon
        ? null
        : InkWell(
            onTap: clearText,
            child: const Icon(
              Icons.cancel,
              color: grayColor,
              size: 22,
            ),
          ),
  );
}

InputDecoration profileInputStyle(
  String label,
  IconData icon,
) {
  return InputDecoration(
    contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
    label: AutoSizeText(label),
    labelStyle: const TextStyle(
      fontSize: 17,
      color: primaryColor,
      fontWeight: FontWeight.bold,
    ),
    filled: true,
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: lightGrayColor, width: 0.7),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: lightGrayColor, width: 0.7),
    ),
    disabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: lightGrayColor, width: 0.7),
    ),
    prefixIcon: Icon(
      icon,
      color: primaryColor,
    ),
  );
}

InputDecoration postInputStyle(String hint) {
  return InputDecoration(
    contentPadding: const EdgeInsets.only(left: 0, bottom: 0, top: 10),
    hintText: hint,
    hintStyle: TextStyle(
      color: primaryColor.withOpacity(0.5),
      fontSize: 16,
    ),
    filled: true,
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: lightGrayColor, width: 0.7),
    ),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: lightGrayColor, width: 0.7),
    ),
  );
}
