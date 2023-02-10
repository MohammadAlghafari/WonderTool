import 'package:flutter/material.dart';
import 'dart:math' show sqrt2;

class RadialExpansion extends StatelessWidget {
  final double maxRadius;
  final double clipRectSize;
  final Widget child;

  const RadialExpansion(
      {Key? key, required this.maxRadius, required this.child, th})
      : clipRectSize = 2.0 * (maxRadius / sqrt2),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Center(
        child: SizedBox(
          width: clipRectSize,
          height: clipRectSize,
          child: ClipRect(
            child: child,
          ),
        ),
      ),
    );
  }
}
