import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AnimationColumnWidget extends StatelessWidget {
  final bool isVertical;
  final List<Widget> children;

  const AnimationColumnWidget({
    Key? key,
    required this.isVertical,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: Column(
        children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(seconds: 1),
          childAnimationBuilder: (widget) => SlideAnimation(
            horizontalOffset: isVertical ? 0 : 50,
            verticalOffset: isVertical ? 50 : 0,
            child: FadeInAnimation(
              child: widget,
            ),
          ),
          children: children,
        ),
      ),
    );
  }
}
