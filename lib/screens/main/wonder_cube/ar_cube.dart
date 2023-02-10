import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:get/get.dart';
import 'package:wonder_tool/connectors/data.dart';
import 'package:wonder_tool/helpers/public.dart';
import 'package:wonder_tool/helpers/variables.dart';
import 'package:wonder_tool/screens/main/wonder_cube/widgets/slider_obejcts.dart';
import 'package:wonder_tool/themes/colors.dart';
import 'package:wonder_tool/widgets/loading_progress.dart';

class ArCubeScreen extends StatefulWidget {
  const ArCubeScreen({Key? key}) : super(key: key);

  @override
  State<ArCubeScreen> createState() => _ArCubeScreenState();
}

class _ArCubeScreenState extends State<ArCubeScreen> {
  late UnityWidgetController _unityWidgetController;

  final _selectedIndex = (arSelectedIndexVAR).obs;
  final _isDetectObject = arIsDetectObjectVAR.obs;
  final _isLoadingTakeScreenshot = false.obs;
  final _is8Ball = arIs8BallVAR.obs;
  final _isShowObjects = arIsShowObjectsVAR.obs;
  String _textLetter = '';

  void onUnityCreated(controller) {
    _unityWidgetController = controller;
  }

  @override
  void initState() {
    getTextLetter();
    super.initState();
  }

  void getTextLetter() async {
    final data = await DataConnector().getTextLetter3dObject();

    if (data != null) {
      _textLetter = data;
    }
  }

  void _changeAnswer8Ball() async {
    _unityWidgetController.postMessage(
      '5_ball',
      'changeAnswer',
      "20",
    );
  }

  void _takeScreenshot() async {
    _isLoadingTakeScreenshot.value = true;

    await _unityWidgetController.postMessage(
      'Objects',
      'TakeScreenshot',
      "20",
    );

    _isLoadingTakeScreenshot.value = false;

    showSuccessSnackBar("Screenshot Saved In Gallery");
  }

  void onBack() async {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [
        SystemUiOverlay.top,
        SystemUiOverlay.bottom,
      ],
    );

    await killUnityScene();
    Get.back();
  }

  Future<void> killUnityScene() async {
    arSelectedIndexVAR = _selectedIndex.value;
    arIsDetectObjectVAR = _isDetectObject.value;
    arIs8BallVAR = _is8Ball.value;
    arIsShowObjectsVAR = _isShowObjects.value;

    await _unityWidgetController.pause();
    _unityWidgetController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              UnityWidget(
                onUnityCreated: onUnityCreated,
                unloadOnDispose: true,
                fullscreen: true,
                useAndroidViewSurface: true,
                hideStatus: false,
              ),
              Obx(
                () => _isDetectObject.value
                    ? const SizedBox()
                    : Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            "assets/icons/ar_cube.svg",
                          ),
                        ),
                      ),
              ),
              Positioned(
                top: 20,
                left: 5,
                child: InkWell(
                  onTap: onBack,
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 90,
                right: 20,
                child: Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        child: AutoSizeText(
                          _is8Ball.value ? "Reveal" : "Snap",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: primaryColor,
                            fontSize: 8,
                          ),
                          maxLines: 3,
                        ),
                      ),
                      const SizedBox(width: 5),
                      _isLoadingTakeScreenshot.value
                          ? const LoadingProgressWidget()
                          : InkWell(
                              onTap: _is8Ball.value
                                  ? _changeAnswer8Ball
                                  : _takeScreenshot,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.4),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(5),
                                child: const Icon(
                                  Icons.fiber_manual_record,
                                  color: redColor,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              Obx(
                () => _isShowObjects.value
                    ? Positioned(
                        bottom: 80,
                        left: 2,
                        right: 2,
                        child: SliderObjectsWidget(
                          onClick: selectObject,
                        ),
                      )
                    : const SizedBox(),
              ),
              Positioned(
                bottom: 20,
                left: 2,
                right: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    cubeContainer('assets/images/w8.png', 1),
                    InkWell(
                      onTap: () {
                        if (!_isShowObjects.value) {
                          selectObject(2);
                        }

                        _isShowObjects.value = !_isShowObjects.value;
                      },
                      child: Obx(
                        () => Container(
                          width: 50,
                          height: 50,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: _selectedIndex.value == 2
                                  ? Colors.white
                                  : Colors.transparent,
                              width: _selectedIndex.value == 2 ? 2 : 0,
                            ),
                          ),
                          child: Image.asset(
                            'assets/images/ps.png',
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                    cubeContainer('assets/images/w8_global.png', 7),
                    cubeContainer('assets/images/infinity.png', 8),
                    cubeContainer('assets/images/8_ball.png', 9),
                    cubeContainer('assets/images/cedar.png', 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> selectObject(int position) async {
    _isDetectObject.value = true;

    String message = "";
    switch (position) {
      case 1:
        message = _textLetter;
        _is8Ball.value = false;
        _isShowObjects.value = false;
        break;
      case 2:
        message = "unimaginable";
        _is8Ball.value = false;
        position = 2;
        break;
      case 3:
        message = "floating";
        _is8Ball.value = false;
        position = 2;
        break;
      case 4:
        message = "eye_candy";
        _is8Ball.value = false;
        position = 2;
        break;
      case 5:
        message = "typography";
        _is8Ball.value = false;
        position = 2;
        break;
      case 6:
        message = "pizza";
        _is8Ball.value = false;
        position = 2;
        break;
      case 7:
        message = "play_seriously";
        _is8Ball.value = false;
        _isShowObjects.value = false;
        break;
      case 8:
        message = "globe";
        _is8Ball.value = false;
        _isShowObjects.value = false;
        break;
      case 9:
        message = "8_ball";
        _is8Ball.value = true;
        _isShowObjects.value = false;
        break;
      case 10:
        message = "hill_crad";
        _is8Ball.value = false;
        _isShowObjects.value = false;
        break;
      default:
    }

    await _unityWidgetController.postMessage(
      'Objects',
      'changeObject',
      message,
    );

    _selectedIndex.value = position;
  }

  Widget cubeContainer(String image, int position) {
    return InkWell(
      onTap: () => selectObject(position),
      child: Obx(
        () => Container(
          width: 50,
          height: 50,
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: _selectedIndex.value == position
                  ? Colors.white
                  : Colors.transparent,
              width: _selectedIndex.value == position ? 2 : 0,
            ),
          ),
          child: Image.asset(
            image,
            color: position == 1 ? null : Colors.white,
          ),
        ),
      ),
    );
  }
}
