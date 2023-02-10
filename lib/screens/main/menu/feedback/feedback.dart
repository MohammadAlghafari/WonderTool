import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wonder_tool/connectors/task.dart';
import 'package:wonder_tool/models/task_delivered.dart';
import 'package:wonder_tool/screens/main/menu/feedback/widgets/task_feedback_item.dart';
import 'package:wonder_tool/themes/colors.dart';
import 'package:wonder_tool/themes/styles.dart';
import 'package:wonder_tool/widgets/animation_list.dart';
import 'package:wonder_tool/widgets/custom_app_bar.dart';
import 'package:wonder_tool/widgets/custom_safe_area.dart';
import 'package:wonder_tool/screens/main/menu/drawer.dart';
import 'package:wonder_tool/widgets/header_refresh.dart';
import 'package:wonder_tool/widgets/loading_progress.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  @override
  Widget build(BuildContext context) {
    final _searchController = TextEditingController();
    final _smartRefreshController = RefreshController(initialRefresh: false);

    final _isTypingSearch = false.obs;
    List<TaskDeiveredModel> allTasks = [];
    final tasks = <TaskDeiveredModel>[].obs;

    return CustomSafeArea(
      child: GestureDetector(
        onTap: (){
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          endDrawer: const CustomDrawerWidget(),
          appBar: customeAppBar(title: 'My Feedbacks', hasBack: true),
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
                                  tasks.value = allTasks;
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                              ),
                              onChanged: (value) {
                                tasks.value = allTasks
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
              future: TaskConnector().getTasksFeedbackDelivered(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingProgressWidget();
                } else {
                  if (snapshot.hasError) {
                    return AutoSizeText(snapshot.error.toString());
                  } else {
                    allTasks = snapshot.data as List<TaskDeiveredModel>;
                    tasks.value = allTasks;
      
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
                          AnimationLimiter(
                            child: allTasks.isEmpty
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
                                    () => ListView.separated(
                                      separatorBuilder: (context, index) =>
                                          const Divider(
                                        color: lightGrayColor,
                                        height: 2,
                                        thickness: 0.5,
                                      ),
                                      itemCount: tasks.length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return AnimationListWidget(
                                          index: index,
                                          isVertical: true,
                                          child: TaskFeedbackItemWidget(
                                            task: tasks[index],
                                            onRead: () {
                                              WidgetsBinding.instance
                                                  .addPostFrameCallback((_) {
                                                setState(() {});
                                              });
                                            },
                                          ),
                                        );
                                      },
                                    ),
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
