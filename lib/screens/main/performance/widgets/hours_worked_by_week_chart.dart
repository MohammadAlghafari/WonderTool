import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wonder_tool/helpers/constants.dart';
import 'package:wonder_tool/models/daily_hours.dart';
import 'package:wonder_tool/models/performance.dart';
import 'package:wonder_tool/themes/colors.dart';

class HoursWorkedByWeekChartWidget extends StatelessWidget {
  final PerformanceModel performance;

  const HoursWorkedByWeekChartWidget({Key? key, required this.performance})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AutoSizeText(
            'HOURS WORKED',
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AutoSizeText(
                  'Daily Average',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 15,
                  ),
                  maxLines: 1,
                ),
                const SizedBox(height: 5),
                AutoSizeText(
                  performance.avgTime,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: primaryColor,
                  ),
                  maxLines: 1,
                ),
                const SizedBox(height: 5),
                SizedBox(
                  height: 250,
                  child: SfCartesianChart(
                    primaryYAxis: NumericAxis(
                      numberFormat: NumberFormat.compact(),
                    ),
                    primaryXAxis: CategoryAxis(
                      interval: 1,
                      labelRotation: -45,
                      visibleMaximum: 6,
                      title: AxisTitle(
                        text: 'Working days by hour',
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
                        dataSource: performance.dailyWork,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
