import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:wonder_tool/connectors/review.dart';
import 'package:wonder_tool/models/review.dart';
import 'package:wonder_tool/models/task_delivered.dart';
import 'package:wonder_tool/screens/main/menu/reviews/widgets/add_review.dart';
import 'package:wonder_tool/widgets/custom_app_bar.dart';
import 'package:wonder_tool/widgets/custom_safe_area.dart';
import 'package:wonder_tool/screens/main/menu/drawer.dart';
import 'package:wonder_tool/widgets/loading_progress.dart';

class ReviewDetailsScreen extends StatelessWidget {
  final TaskDeiveredModel task;
  final Function() onRead;

  const ReviewDetailsScreen({
    Key? key,
    required this.task,
    required this.onRead,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!task.isRead) {
      onRead();
    }

    return CustomSafeArea(
      child: GestureDetector(
        onTap: (){
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          endDrawer: const CustomDrawerWidget(),
          appBar: customeAppBar(
            title: 'Reviews',
            hasBack: true,
          ),
          body: FutureBuilder(
            future: ReviewConnector().getReviewByTaskId(
              task.id,
              task.taskUserId,
              task.userId,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingProgressWidget();
              } else {
                if (snapshot.hasError) {
                  return AutoSizeText(snapshot.error.toString());
                } else {
                  final _reviews = snapshot.data as List<ReviewModel>;
      
                  return AddReviewWidget(
                    task: task,
                    review: _reviews[0],
                    onRead: onRead,
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
