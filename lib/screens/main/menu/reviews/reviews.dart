import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wonder_tool/connectors/task.dart';
import 'package:wonder_tool/models/task_delivered.dart';
import 'package:wonder_tool/screens/main/menu/reviews/widgets/task_review_item.dart';
import 'package:wonder_tool/themes/colors.dart';
import 'package:wonder_tool/themes/styles.dart';
import 'package:wonder_tool/widgets/animation_list.dart';
import 'package:wonder_tool/widgets/custom_app_bar.dart';
import 'package:wonder_tool/widgets/custom_safe_area.dart';
import 'package:wonder_tool/screens/main/menu/drawer.dart';
import 'package:wonder_tool/widgets/header_refresh.dart';
import 'package:wonder_tool/widgets/loading_progress.dart';
import 'package:get/get.dart';

import '../../../../controllers/user.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({Key? key}) : super(key: key);

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  final _userController = Get.find<UserController>();

  final _smartRefreshController = RefreshController(initialRefresh: false);

  final _searchController = TextEditingController();

  final _isTypingSearch = false.obs;
  List<TaskDeiveredModel> allTasksPending = [];
  List<TaskDeiveredModel> allTasksCompleted = [];
  final tasksPending = <TaskDeiveredModel>[].obs;
  final tasksCompleted = <TaskDeiveredModel>[].obs;

  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          endDrawer: const CustomDrawerWidget(),
          appBar: customeAppBar(title: 'To Review', hasBack: true),
          body: NestedScrollView(
            controller: ScrollController(initialScrollOffset: 50),
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: secondColor,
                  elevation: 0,
                  centerTitle: false,
                  actions: const [
                    SizedBox(),
                  ],
                  flexibleSpace: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Obx(
                      () => Row(
                        children: [
                          const Icon(
                            Icons.search,
                            color: primaryColor,
                            size: 30,
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: TextFormField(
                              controller: _searchController,
                              style: smallTextInputWhiteStyle,
                              maxLines: 1,
                              decoration: inputStyle(
                                "Search..",
                                !_isTypingSearch.value,
                                () {
                                  _searchController.clear();
                                  _isTypingSearch.value = false;
                                  tasksPending.value = allTasksPending;
                                  tasksCompleted.value = allTasksCompleted;
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                              ),
                              onChanged: (value) {
                                tasksPending.value = allTasksPending
                                    .where((t) =>
                                        t.name
                                            .toLowerCase()
                                            .contains(value.toLowerCase()) ||
                                        t.clientName
                                            .toLowerCase()
                                            .contains(value.toLowerCase()))
                                    .toList();

                                tasksCompleted.value = allTasksCompleted
                                    .where((t) =>
                                        t.name
                                            .toLowerCase()
                                            .contains(value.toLowerCase()) ||
                                        t.clientName
                                            .toLowerCase()
                                            .contains(value.toLowerCase()))
                                    .toList();

                                if (value.isEmpty) {
                                  _isTypingSearch.value = false;
                                } else {
                                  _isTypingSearch.value = true;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: FutureBuilder(
              future: TaskConnector().getTasksReviewDelivered(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingProgressWidget();
                } else {
                  if (snapshot.hasError) {
                    return AutoSizeText(snapshot.error.toString());
                  } else {
                    final _tasks = snapshot.data as List<TaskDeiveredModel>;

                    allTasksCompleted =
                        _tasks.where((t) => t.isAccepted).toList();

                    allTasksPending =
                        _tasks.where((t) => !t.isAccepted).toList();

                    tasksCompleted.value = allTasksCompleted;
                    tasksPending.value = allTasksPending;

                    return SmartRefresher(
                      controller: _smartRefreshController,
                      enablePullUp: true,
                      header: const CustomHeaderRefreshWidget(),
                      footer: CustomFooter(
                        height: 0,
                        builder: (context, mode) => const SizedBox(),
                      ),
                      onRefresh: () async {
                        setState(() {});
                        _smartRefreshController.refreshCompleted();
                      },
                      child: ListView(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        children: [
                          _tasks.isEmpty
                              ? Center(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(top: Get.height * 0.3),
                                    child: const Text(
                                      "Not Yet Delivery Tasks",
                                      style: TextStyle(color: primaryColor),
                                    ),
                                  ),
                                )
                              : Obx(
                                  () => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (tasksPending.isNotEmpty)
                                        const SizedBox(height: 10),
                                      if (tasksPending.isNotEmpty)
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 20,
                                          ),
                                          child: AutoSizeText(
                                            'JOBS PENDING',
                                            style: TextStyle(
                                              color: grayColor,
                                              fontSize: 17,
                                            ),
                                            maxLines: 1,
                                          ),
                                        ),
                                      const SizedBox(height: 10),
                                      AnimationLimiter(
                                        child: ListView.separated(
                                          separatorBuilder: (context, index) =>
                                              const Divider(
                                            color: lightGrayColor,
                                            height: 2,
                                            thickness: 0.5,
                                          ),
                                          itemCount: tasksPending.length,
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return AnimationListWidget(
                                              index: index,
                                              isVertical: true,
                                              child: TaskReviewItemWidget(
                                                task: tasksPending[index],
                                                onRead: () {
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback(
                                                          (_) {
                                                    setState(() {
                                                      if (!tasksPending[index]
                                                          .isRead) {
                                                        _userController
                                                            .reviewNotificationCount -= 1;
                                                        _userController
                                                            .update();
                                                      }
                                                      tasksPending.value[index]
                                                          .isRead = true;
                                                    });
                                                  });
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      if (tasksCompleted.isNotEmpty)
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: AutoSizeText(
                                            'JOBS REVIEWED',
                                            style: TextStyle(
                                              color: grayColor,
                                              fontSize: 17,
                                            ),
                                            maxLines: 1,
                                          ),
                                        ),
                                      const SizedBox(height: 5),
                                      AnimationLimiter(
                                        child: ListView.separated(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          separatorBuilder: (context, index) =>
                                              const Divider(
                                            color: lightGrayColor,
                                            height: 2,
                                            thickness: 0.5,
                                          ),
                                          itemCount: tasksCompleted.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return AnimationListWidget(
                                              index: index,
                                              isVertical: true,
                                              child: TaskReviewItemWidget(
                                                task: tasksCompleted[index],
                                                onRead: () {
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback(
                                                          (_) {
                                                    setState(() {
                                                      if (!tasksCompleted[index]
                                                          .isRead) {
                                                        _userController
                                                            .reviewNotificationCount -= 1;
                                                        _userController
                                                            .update();
                                                      }
                                                      tasksCompleted
                                                          .value[index]
                                                          .isRead = true;
                                                    });
                                                  });
                                                },
                                              ),
                                            );
                                          },
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
              },
            ),
          ),
        ),
      ),
    );
  }
}
