import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wonder_tool/helpers/constants.dart';
import 'package:wonder_tool/models/daily_hours.dart';
import 'package:wonder_tool/models/performance.dart';
import 'package:wonder_tool/themes/colors.dart';

class TaskTypeWorkedByWeekChartWidget extends StatelessWidget {
  final PerformanceModel performance;

  const TaskTypeWorkedByWeekChartWidget({Key? key, required this.performance})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AutoSizeText(
            'TYPES TASKS WORKED',
            style: TextStyle(
              color: grayColor,
              fontSize: 18,
            ),
            maxLines: 1,
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color: lightBlackColor,
              borderRadius: BorderRadius.circular(defaultRaduis),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                height: 250,
                width: performance.dailyTaskTypeWork.length < 6
                    ? Get.width * 0.8
                    : 50.0 * performance.dailyTaskTypeWork.length,
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(
                    interval: 1,
                    isVisible: true,
                    labelIntersectAction: AxisLabelIntersectAction.wrap,
                  ),
                  legend: Legend(
                    isVisible: true,
                    position: LegendPosition.bottom,
                    textStyle: const TextStyle(
                      color: primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  series: <ChartSeries<DailyHoursTaskTypeModel, String>>[
                    ColumnSeries<DailyHoursTaskTypeModel, String>(
                      dataSource: performance.dailyTaskTypeWork,
                      xValueMapper: (d, _) => d.title,
                      yValueMapper: (d, _) =>
                          (d.managementHours + (d.managementMinutes / 60)),
                      name: "Managemenet",
                      color: Colors.amber,
                    ),
                    ColumnSeries<DailyHoursTaskTypeModel, String>(
                      dataSource: performance.dailyTaskTypeWork,
                      xValueMapper: (d, _) => d.title,
                      yValueMapper: (d, _) =>
                          (d.generalHours + (d.generalMinutes / 60)),
                      name: "General",
                      color: Colors.blue,
                    ),
                    ColumnSeries<DailyHoursTaskTypeModel, String>(
                      dataSource: performance.dailyTaskTypeWork,
                      xValueMapper: (d, _) => d.title,
                      yValueMapper: (d, _) =>
                          (d.meetingHours + (d.meetingMinutes / 60)),
                      name: "Meeting",
                      color: Colors.deepOrange,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
