import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wonder_tool/helpers/constants.dart';
import 'package:wonder_tool/models/performance.dart';
import 'package:wonder_tool/themes/colors.dart';

class HeaderPerformanceWidget extends StatelessWidget {
  final PerformanceModel performance;

  const HeaderPerformanceWidget({
    Key? key,
    required this.performance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 160,
      child: SizedBox(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: lightBlackColor,
                  borderRadius: BorderRadius.circular(defaultRaduis),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/reward.svg',
                      color: yellowColor,
                    ),
                    const SizedBox(height: 10),
                    AutoSizeText(
                      performance.workStart,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: primaryColor,
                      ),
                      maxLines: 1,
                    ),
                    AutoSizeText(
                      performance.nickname,
                      style: const TextStyle(
                        color: primaryColor,
                        fontSize: 20,
                        height: 1,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: lightBlackColor,
                  borderRadius: BorderRadius.circular(defaultRaduis),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: RatingBar(
                        initialRating: performance.rate,
                        ignoreGestures: true,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemSize: 22,
                        itemCount: 5,
                        ratingWidget: RatingWidget(
                          full: SvgPicture.asset("assets/icons/fill_star.svg"),
                          half: SvgPicture.asset("assets/icons/half_star.svg"),
                          empty: SvgPicture.asset("assets/icons/star.svg"),
                        ),
                        itemPadding: const EdgeInsets.symmetric(horizontal: 3),
                        onRatingUpdate: (rating) {},
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: AutoSizeText(
                        "${performance.rate}/ 5",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: primaryColor,
                        ),
                        maxLines: 1,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: AutoSizeText(
                        'Global Rating',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
