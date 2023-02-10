import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:wonder_tool/connectors/data.dart';
import 'package:wonder_tool/connectors/task.dart';
import 'package:wonder_tool/controllers/task.dart';
import 'package:wonder_tool/controllers/user.dart';
import 'package:wonder_tool/helpers/local_storage.dart';
import 'package:wonder_tool/helpers/public.dart';
import 'package:wonder_tool/screens/main/lounge_cafe/lounge_cafe.dart';
import 'package:wonder_tool/screens/main/lounge_cafe/soon.dart';
import 'package:wonder_tool/screens/main/news_tribe/news_tribe.dart';
import 'package:wonder_tool/screens/main/performance/performance.dart';
import 'package:wonder_tool/screens/main/wonder_cube/ar_cube.dart';
import 'package:wonder_tool/screens/main/wonder_cube/wonder_cube.dart';
import 'package:wonder_tool/screens/main/work/work.dart';
import 'package:wonder_tool/apis/urls.dart';
import 'package:wonder_tool/themes/colors.dart';
import 'package:wonder_tool/widgets/custom_app_bar.dart';
import 'package:wonder_tool/widgets/custom_safe_area.dart';
import 'package:wonder_tool/screens/main/menu/drawer.dart';
import 'package:wonder_tool/widgets/loading_progress.dart';

class BoardScreen extends StatefulWidget {
  final int indexPage;
  const BoardScreen({Key? key, required this.indexPage}) : super(key: key);

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  final user = Get.find<UserController>().user.value;

  @override
  void initState() {
    showIntroIsFirstTime();
    checkIfSecondTime();
    getWorkTaskData();

    super.initState();
  }

  void checkIfSecondTime() async {
    final _isSameDay = await checkDateIsToday(DATE_BACKGROUND_TEXT);
    if (_isSameDay) {
      int nb = boxStorage.read(NUMBER_OF_OPEN_APP_PER_DAY) ?? 0;

      if (nb == 0) {
        await boxStorage.write(NUMBER_OF_OPEN_APP_PER_DAY, 1);
      } else if (nb == 1) {
        showBackgroundText();
        await boxStorage.write(NUMBER_OF_OPEN_APP_PER_DAY, 2);
      }
    } else {
      await boxStorage.write(NUMBER_OF_OPEN_APP_PER_DAY, 1);
    }
  }

  void showBackgroundText() async {
    final data = await DataConnector().getUserBackground();

    if (data != null) {
      Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          insetPadding: const EdgeInsets.symmetric(
            vertical: 24,
            horizontal: 5,
          ),
          backgroundColor: Colors.transparent,
          child: InkWell(
            onTap: () {
              Get.back();
            },
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: "$BASE_IMAGE_URL${data.image}",
                    fit: BoxFit.cover,
                    errorWidget: (ctx, error, _) => Image.asset(
                      "assets/images/launch.png",
                    ),
                    placeholder: (context, url) =>
                        const LoadingProgressWidget(),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      data.text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: secondColor,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );
    }
  }

  Future<void> getWorkTaskData() async {
    final taskController = Get.find<TaskController>();

    taskController.toggleLoading();
    final _data = await TaskConnector().getUserTasks();
    taskController.toggleLoading();

    taskController.addAllPinTasks(_data.where((t) => t.isPin).toList());
    taskController.addAllUnpinTasks(_data.where((t) => !t.isPin).toList());
  }

  Future<bool> showExitDialog() async {
    return await Get.dialog(
      AlertDialog(
        title: const Text("Are you sure?"),
        content: const Text("You want to exit from this app"),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(result: false);
            },
            child: const Text(
              "No",
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            child: const Text(
              "Yes",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    ) as bool;
  }

  @override
  Widget build(BuildContext context) {
    var _selectedIndex = widget.indexPage.obs;

    const List<String> _appBarTitle = [
      'Lounge & Cafe',
      'News & Events',
      'Performance',
      'Work',
      'Wonder Cube',
    ];

    void _onItemBottomNavigationClick(int index) {
      if (user.isFreelancer) {
        if (index == 0 || index == 1 || index == 4) {
          return;
        }
      }

      if (index == 0) {
        Get.to(() => const SoonScreen());
        return;
      }

      if (index == 4) {
        Get.to(() => const ArCubeScreen());
        return;
      }

      _selectedIndex.value = index;
    }

    List<Widget> _pages = const [
      LoungeCafeScreen(),
      NewsTribeScreen(),
      PerformanceScreen(),
      WorkScreen(),
      WonderCubeScreen(),
    ];

    return WillPopScope(
      onWillPop: () => showExitDialog(),
      child: CustomSafeArea(
        child: Obx(
          () => Scaffold(
            endDrawer: const CustomDrawerWidget(),
            appBar: customeAppBar(
              title: _appBarTitle[_selectedIndex.value],
            ),
            body: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: _pages[_selectedIndex.value],
            ),
            bottomNavigationBar: GetBuilder<UserController>(
              builder: (controller) => BottomNavigationBar(
                backgroundColor: lightBlackColor,
                onTap: _onItemBottomNavigationClick,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: blueColor,
                selectedFontSize: 10,
                unselectedFontSize: 10,
                unselectedItemColor: lightGrayColor,
                currentIndex: _selectedIndex.value,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                items: [
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: SvgPicture.asset(
                        "assets/icons/lounge.svg",
                        color:
                            _selectedIndex.value == 0 ? blueColor : grayColor,
                      ),
                    ),
                    label: 'Lounge/Cafe',
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: controller.hasNewsNotification
                          ? Badge(
                              padding: const EdgeInsets.all(5),
                              badgeColor: redColor,
                              position: const BadgePosition(
                                end: -5,
                                top: -3,
                              ),
                              child: SvgPicture.asset(
                                "assets/icons/news.svg",
                                color: _selectedIndex.value == 1
                                    ? blueColor
                                    : grayColor,
                              ),
                            )
                          : SvgPicture.asset(
                              "assets/icons/news.svg",
                              color: _selectedIndex.value == 1
                                  ? blueColor
                                  : grayColor,
                            ),
                    ),
                    label: 'News/Tribe',
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      "assets/icons/performance.svg",
                      color: _selectedIndex.value == 2 ? blueColor : grayColor,
                      height: 29,
                    ),
                    label: 'Performance',
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: controller.hasTaskNotification
                          ? Badge(
                              padding: const EdgeInsets.all(5),
                              badgeColor: redColor,
                              position: const BadgePosition(
                                end: -5,
                                top: -3,
                              ),
                              child: SvgPicture.asset(
                                "assets/icons/work.svg",
                                color: _selectedIndex.value == 3
                                    ? blueColor
                                    : grayColor,
                                height: 23,
                              ),
                            )
                          : SvgPicture.asset(
                              "assets/icons/work.svg",
                              color: _selectedIndex.value == 3
                                  ? blueColor
                                  : grayColor,
                              height: 23,
                            ),
                    ),
                    label: 'Work',
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: SvgPicture.asset(
                        "assets/icons/cube.svg",
                        color:
                            _selectedIndex.value == 4 ? blueColor : grayColor,
                      ),
                    ),
                    label: 'WonderCube',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
