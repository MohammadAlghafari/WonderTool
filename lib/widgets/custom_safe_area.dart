import 'package:flutter/material.dart';
import 'package:wonder_tool/themes/colors.dart';

class CustomSafeArea extends StatelessWidget {
  final Widget child;

  const CustomSafeArea({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: secondColor,
      child: SafeArea(
        child: child,
      ),
    );
  }
}
