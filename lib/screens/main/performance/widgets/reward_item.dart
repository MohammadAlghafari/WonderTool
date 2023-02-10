import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wonder_tool/models/reward.dart';
import 'package:wonder_tool/themes/colors.dart';

class RewardItemWidget extends StatelessWidget {
  final RewardModel reward;
  final List<String> userRewards;

  const RewardItemWidget({
    Key? key,
    required this.reward,
    required this.userRewards,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SvgPicture.asset(
            'assets/icons/achivment.svg',
            height: 60,
            color: userRewards.contains(reward.id) ? yellowColor : grayColor,
          ),
          const SizedBox(height: 10),
          AutoSizeText(
            reward.title,
            style: const TextStyle(
              color: primaryColor,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
