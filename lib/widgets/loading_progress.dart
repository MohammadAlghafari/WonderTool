import 'package:flutter/material.dart';
import 'package:wonder_tool/themes/colors.dart';

class LoadingProgressWidget extends StatelessWidget {
  const LoadingProgressWidget({Key? key, this.color = primaryColor}) : super(key: key);
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator(color: color,));
  }
}
