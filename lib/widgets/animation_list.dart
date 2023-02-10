import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AnimationListWidget extends StatelessWidget {
  final Widget child;
  final int index;
  final bool isVertical;

  const AnimationListWidget({
    Key? key,
    required this.index,
    required this.isVertical,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: const Duration(seconds: 1),
      child: SlideAnimation(
        horizontalOffset: isVertical ? 0 : 50,
        verticalOffset: isVertical ? 50 : 0,
        child: FadeInAnimation(
          child: child,
        ),
      ),
    );
  }
}
