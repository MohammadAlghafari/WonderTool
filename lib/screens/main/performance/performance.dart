import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:wonder_tool/connectors/data.dart';
import 'package:wonder_tool/connectors/user.dart';
import 'package:wonder_tool/helpers/constants.dart';
import 'package:wonder_tool/models/performance.dart';
import 'package:wonder_tool/models/reward.dart';
import 'package:wonder_tool/screens/main/performance/widgets/header.dart';
import 'package:wonder_tool/screens/main/performance/widgets/hours_worked_by_week_chart.dart';
import 'package:wonder_tool/screens/main/performance/widgets/reward_item.dart';
import 'package:wonder_tool/screens/main/performance/widgets/task_type_worked_by_week_chart.dart';
import 'package:wonder_tool/screens/main/performance/widgets/task_worked_by_week_chart.dart';
import 'package:wonder_tool/themes/colors.dart';
import 'package:wonder_tool/widgets/animation_list.dart';
import 'package:wonder_tool/widgets/loading_progress.dart';

class PerformanceScreen extends StatelessWidget {
  const PerformanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DataConnector().getRewards(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingProgressWidget();
        } else {
          if (snapshot.hasError) {
            return AutoSizeText(snapshot.error.toString());
          } else {
            final _rewards = snapshot.data as List<RewardModel>;

            return FutureBuilder(
              future: UserConnector().getUserPerformance(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingProgressWidget();
                } else {
                  if (snapshot.hasError) {
                    return AutoSizeText(snapshot.error.toString());
                  } else {
                    final _performance = snapshot.data as PerformanceModel;

                    return ListView(
                      children: [
                        HeaderPerformanceWidget(performance: _performance),
                        const SizedBox(height: 30),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: AutoSizeText(
                            'TROPHIES',
                            style: TextStyle(
                              color: grayColor,
                              fontSize: 18,
                            ),
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 120,
                          margin: const EdgeInsets.only(left: 20),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          decoration: const BoxDecoration(
                            color: lightBlackColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(defaultRaduis),
                              bottomLeft: Radius.circular(defaultRaduis),
                            ),
                          ),
                          child: AnimationLimiter(
                            child: ListView.builder(
                              itemCount: _rewards.length,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(left: 20),
                              itemBuilder: (context, index) {
                                return AnimationListWidget(
                                  index: index,
                                  isVertical: false,
                                  child: RewardItemWidget(
                                    reward: _rewards[index],
                                    userRewards: _performance.rewardsId,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        HoursWorkedByWeekChartWidget(
                          performance: _performance,
                        ),
                        const SizedBox(height: 30),
                        TaskWorkedByWeekChartWidget(
                          performance: _performance,
                        ),
                        const SizedBox(height: 30),
                        TaskTypeWorkedByWeekChartWidget(
                          performance: _performance,
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  }
                }
              },
            );
          }
        }
      },
    );
  }
}
