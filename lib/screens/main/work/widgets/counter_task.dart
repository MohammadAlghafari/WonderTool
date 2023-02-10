import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:wonder_tool/helpers/constants.dart';
import 'package:wonder_tool/models/task.dart';
import 'package:wonder_tool/controllers/selected_task.dart';
import 'package:wonder_tool/themes/colors.dart';
import 'package:get/get.dart';

class CounterTaskWidget extends StatefulWidget {
  final TaskModel task;
  final int index;
  final bool searchVisible;

  const CounterTaskWidget({
    Key? key,
    required this.task,
    required this.index,
    required this.searchVisible,
  }) : super(key: key);

  @override
  State<CounterTaskWidget> createState() => _CounterTaskWidgetState();
}

class _CounterTaskWidgetState extends State<CounterTaskWidget>
    with SingleTickerProviderStateMixin {
  final controller = Get.find<SelectedTaskController>();
  final _isLoadingTimer = false.obs;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 1000),
    vsync: this,
  )..forward();

  late final Animation<Offset> _bounceAnimation = Tween<Offset>(
    begin: const Offset(0.0, 0.0),
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.bounceIn,
  ));

  late final Animation<double> _scaleAnimation =
      Tween<double>(begin: 0.3, end: 1).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  ));

  @override
  void dispose() {
    _controller.removeListener(() {});
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String date = DateFormat('MMM, d, yyyy').format(widget.task.deadLineDate!);
    final size = MediaQuery.of(context).size;
    // print(size.height);
    final double offset = ((size.height - 150) / 150);
    final double sizeOffset = -((size.height -
                50 -
                130 -
                ((widget.index * 100) +
                    (widget.searchVisible
                        ? 191.1818181818182
                        : 141.1818181818182))) /
            130) /* +
        ( size.height / (( size.height / 4 ) + 12)) */
        ;
    // print(sizeOffset);
    late final Animation<Offset> _offsetTopAnimation = Tween<Offset>(
      begin: Offset(0.0,
          /* double.parse((widget.index % offset).toString()) - offset */ sizeOffset),
      end: Offset(
          0.0,
          /*  double.parse((widget.index % offset).toString()) - offset - 0.1 */ sizeOffset -
              0.4),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeInBack),
    ));
    late final Animation<Offset> _offsetAnimation = Tween<Offset>(
      begin: Offset(
          0.0,
          /* double.parse((widget.index % offset).toString()) - offset - 0.1 */ sizeOffset -
              0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1, curve: Curves.elasticOut),
    ));
    _controller.addListener(
      () {
        setState(() {});
      },
    );
    return SlideTransition(
      position:
          _controller.value < 0.5 ? _offsetTopAnimation : _offsetAnimation,
      child: Container(
        padding: const EdgeInsets.fromLTRB(15, 20, 40, 20),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    widget.task.clientName,
                    style: const TextStyle(
                      color: secondColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                  ),
                  AutoSizeText(
                    widget.task.name,
                    style: const TextStyle(
                      color: secondColor,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const AutoSizeText(
                              "Time Spent",
                              style: TextStyle(
                                color: secondColor,
                                fontSize: 10,
                              ),
                              maxLines: 1,
                            ),
                            StreamBuilder<int>(
                              stream: controller.timerWatchController.rawTime,
                              initialData: 0,
                              builder: (context, snap) => Obx(() {
                                final value = (snap.data!) +
                                    (controller
                                        .subTask.value.totalTimeMillisecond);

                                final displayTime =
                                    StopWatchTimer.getDisplayTime(
                                  value,
                                  milliSecond: false,
                                );

                                return Text(
                                  displayTime,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const AutoSizeText(
                              "Out of",
                              style: TextStyle(
                                color: secondColor,
                                fontSize: 11,
                              ),
                              maxLines: 1,
                            ),
                            AutoSizeText(
                              widget.task.deadLineTime,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Obx(
                () => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    controller.type.value == TASK_TYPE_WORK
                        ? const SizedBox()
                        : FittedBox(
                            child: AutoSizeText(
                              controller.type.value == TASK_TYPE_MANAGEMENT
                                  ? "Management"
                                  : controller.type.value == TASK_TYPE_MEETING
                                      ? "Meeting"
                                      : "",
                              maxLines: 1,
                              style: const TextStyle(
                                color: secondColor,
                                fontSize: 12,
                              ),
                            ),
                          ),
                    const SizedBox(height: 10),
                    _isLoadingTimer.value
                        ? const CircularProgressIndicator(color: secondColor)
                        : InkWell(
                            onTap: controller.isStartTime.value
                                ? () => controller.stopTimer(
                                      widget.task,
                                      _isLoadingTimer,
                                    )
                                : () => controller.startTimer(
                                      widget.task,
                                      _isLoadingTimer,
                                      widget.index,
                                    ),
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                color: redColor,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(5),
                              alignment: Alignment.center,
                              child: Icon(
                                controller.isStartTime.value
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                color: primaryColor,
                                size: 30,
                              ),
                            ),
                          ),
                    const SizedBox(height: 10),
                    AutoSizeText(
                      date,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: dateColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
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
