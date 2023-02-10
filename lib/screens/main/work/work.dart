import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wonder_tool/connectors/task.dart';
import 'package:wonder_tool/controllers/selected_task.dart';
import 'package:wonder_tool/controllers/task.dart';
import 'package:wonder_tool/controllers/user.dart';
import 'package:wonder_tool/screens/main/work/widgets/counter_task.dart';
import 'package:wonder_tool/screens/main/work/widgets/task_item.dart';
import 'package:wonder_tool/themes/colors.dart';
import 'package:wonder_tool/themes/styles.dart';
import 'package:wonder_tool/widgets/animation_column.dart';
import 'package:wonder_tool/widgets/header_refresh.dart';
import 'package:wonder_tool/widgets/loading_progress.dart';

class WorkScreen extends GetView<SelectedTaskController> {
  const WorkScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final taskController = Get.find<TaskController>();
    final _userController = Get.find<UserController>();
    final _scrollController = ScrollController(initialScrollOffset: 57);
    final _smartRefreshController = RefreshController(
      initialRefresh: false,
    );
    final _isLoading = false.obs;
    final _searchVisible = false.obs;

    final _searchController = TextEditingController();
    final _isTypingSearch = false.obs;

    _scrollController.addListener(() {
      _searchVisible.value = _scrollController.offset < 50;
    });

    Future<void> _getData() async {
      _isLoading.value = true;

      final _data = await TaskConnector().getUserTasks();

      taskController.addAllPinTasks(_data.where((t) => t.isPin).toList());
      taskController.addAllUnpinTasks(_data.where((t) => !t.isPin).toList());

      _isLoading.value = false;

      _smartRefreshController.refreshCompleted();
    }

    if (_userController.hasTaskNotification) {
      _userController.readTaskNotification();
    }

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: secondColor,
                elevation: 0,
                centerTitle: false,
                floating: true,
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

                                taskController.searchPinTasks.value =
                                    taskController.pinTasks;
                                taskController.searchUnPinTasks.value =
                                    taskController.unPinTasks;

                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                            ),
                            onChanged: (value) {
                              taskController.searchPinTasks.value =
                                  taskController.pinTasks
                                      .where((t) =>
                                          t.name
                                              .toLowerCase()
                                              .contains(value.toLowerCase()) ||
                                          t.clientName
                                              .toLowerCase()
                                              .contains(value.toLowerCase()))
                                      .toList();

                              taskController.searchUnPinTasks.value =
                                  taskController
                                      .unPinTasks
                                      .where((t) =>
                                          t
                                              .name
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
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanDown: (_) {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Stack(
              children: [
                SmartRefresher(
                  controller: _smartRefreshController,
                  enablePullUp: true,
                  header: const CustomHeaderRefreshWidget(),
                  footer: CustomFooter(
                    height: 0,
                    builder: (context, mode) => const SizedBox(),
                  ),
                  physics: const ScrollPhysics(),
                  onRefresh: () async {
                    await _getData();
                  },
                  child: GetBuilder<TaskController>(
                    builder: (taskController) => taskController.isLoading
                        ? const LoadingProgressWidget()
                        : Obx(
                            () => ListView(
                              padding: const EdgeInsets.only(top: 10),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                _isLoading.value
                                    ? _smartRefreshController.isRefresh
                                        ? const SizedBox()
                                        : const LoadingProgressWidget()
                                    : taskController.pinTasks.isEmpty &&
                                            taskController.unPinTasks.isEmpty
                                        ? const Center(
                                            child: AutoSizeText(
                                              "You don't have any tasks yet",
                                              style: smallTextInputWhiteStyle,
                                              maxLines: 2,
                                            ),
                                          )
                                        : AnimationColumnWidget(
                                            isVertical: false,
                                            children: [
                                              ListView.builder(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: taskController
                                                    .searchPinTasks.length,
                                                itemBuilder: (context, index) =>
                                                    TaskItemWidget(
                                                  task: taskController
                                                      .searchPinTasks[index],
                                                  refreshData: _getData,
                                                  index: index,
                                                ),
                                              ),
                                              ListView.builder(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: taskController
                                                    .searchUnPinTasks.length,
                                                itemBuilder: (context, index) =>
                                                    TaskItemWidget(
                                                  task: taskController
                                                      .searchUnPinTasks[index],
                                                  refreshData: _getData,
                                                  index: index,
                                                ),
                                              ),
                                            ],
                                          ),
                                SizedBox(
                                  height: controller
                                          .selectedTask.value.id.isNotEmpty
                                      ? 140
                                      : 0,
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
                Positioned(
                  bottom: 1,
                  left: 0,
                  right: 0,
                  child: Obx(
                    () => controller.selectedTask.value.id.isNotEmpty
                        ? CounterTaskWidget(
                            task: controller.selectedTask.value,
                            index: controller.selectedTaskIndex,
                            searchVisible: _searchVisible.value,
                          )
                        : const SizedBox(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
