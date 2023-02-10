import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wonder_tool/themes/colors.dart';

class SliderObjectsWidget extends StatelessWidget {
  final Function(int) onClick;

  const SliderObjectsWidget({
    Key? key,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _currentIndicator = 0.obs;
    final _sliderController = CarouselController();

    List<Widget> _items = const [
      SizedBox(),
      SizedBox(),
      SizedBox(),
      SizedBox(),
      SizedBox(),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CarouselSlider(
          carouselController: _sliderController,
          items: _items,
          options: CarouselOptions(
            height: Get.height * 0.6,
            disableCenter: true,
            viewportFraction: 1,
            enlargeCenterPage: false,
            enableInfiniteScroll: true,
            initialPage: 0,
            onPageChanged: (index, reason) {
              onClick(index + 2);
              _currentIndicator.value = index;
            },
          ),
        ),
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _items.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _sliderController.animateToPage(entry.key),
                child: Container(
                  width: 12.0,
                  height: 12.0,
                  margin: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 4.0,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndicator.value == entry.key
                        ? blueColor
                        : grayColor,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
