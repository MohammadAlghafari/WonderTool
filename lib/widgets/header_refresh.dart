import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wonder_tool/themes/colors.dart';

class CustomHeaderRefreshWidget extends StatelessWidget {
  const CustomHeaderRefreshWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const WaterDropMaterialHeader(
      color: secondColor,
      backgroundColor: darkGrayColor,
      distance: 30,
    );
  }
}
