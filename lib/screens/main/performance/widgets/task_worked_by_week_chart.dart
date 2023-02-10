import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wonder_tool/helpers/constants.dart';
import 'package:wonder_tool/models/daily_hours.dart';
import 'package:wonder_tool/models/performance.dart';
import 'package:wonder_tool/themes/colors.dart';

class TaskWorkedByWeekChartWidget extends StatelessWidget {
  final PerformanceModel performance;

  const TaskWorkedByWeekChartWidget({Key? key, required this.performance})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AutoSizeText(
            'TASKS WORKED',
            style: TextStyle(
              color: grayColor,
              fontSize: 18,
            ),
            maxLines: 1,
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: lightBlackColor,
                borderRadius: BorderRadius.circular(defaultRaduis),
              ),
              child: SizedBox(
                height: 250,
                width: performance.dailyTaskTypeWork.length < 6
                    ? Get.width * 0.8
                    : 50.0 * performance.dailyTaskTypeWork.length,
                child: SfCartesianChart(
                  primaryYAxis: NumericAxis(
                    numberFormat: NumberFormat.decimalPattern(),
                  ),
                  primaryXAxis: CategoryAxis(
                    interval: 1,
                    isVisible: true,
                    labelIntersectAction: AxisLabelIntersectAction.wrap,
                    title: AxisTitle(
                      text: 'Working tasks by hour',
                      textStyle: const TextStyle(
                        color: primaryColor,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  series: <ChartSeries<DailyHoursModel, String>>[
                    StackedColumnSeries<DailyHoursModel, String>(
                      color: blueColor,
                      dataSource: performance.dailyTaskWork,xAxisName: 'tasks',
                      yAxisName: 'value',
                      xValueMapper: (d, _) => d.title,
                      yValueMapper: (d, _) => (d.hours + (d.minutes / 60)),
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                        textStyle: TextStyle(
                          fontSize: 10,
                        ),
                      ),
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
