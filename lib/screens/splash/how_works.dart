import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wonder_tool/connectors/data.dart';
import 'package:wonder_tool/models/how_work.dart';
import 'package:wonder_tool/apis/urls.dart';
import 'package:wonder_tool/themes/colors.dart';
import 'package:wonder_tool/widgets/loading_progress.dart';

class HowItWorksScreen extends StatefulWidget {
  const HowItWorksScreen({Key? key}) : super(key: key);

  @override
  State<HowItWorksScreen> createState() => _HowItWorksScreenState();
}

class _HowItWorksScreenState extends State<HowItWorksScreen> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersive,
      overlays: [SystemUiOverlay.top],
    );

    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
    );

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _currentIndex = 0.obs;
    final _sliderController = CarouselController();

    void _onComplete() {
      Get.back();
    }

    return SafeArea(
      bottom: false,
      child: Scaffold(
        body: FutureBuilder(
          future: DataConnector().getHowToWork(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingProgressWidget();
            } else {
              if (snapshot.hasError) {
                return AutoSizeText(snapshot.error.toString());
              } else {
                final _data = snapshot.data as List<HowItWorkModel>;

                final List<Widget> _dataWidgets = _data
                    .map(
                      (e) => CachedNetworkImage(
                        imageUrl: "$BASE_IMAGE_URL${e.image}",
                        fit: BoxFit.cover,
                        errorWidget: (ctx, error, _) => Image.asset(
                          "assets/images/launch.png",
                        ),
                        placeholder: (context, url) =>
                            const LoadingProgressWidget(),
                      ),
                    )
                    .toList();

                return Obx(
                  () => Stack(
                    children: [
                      CarouselSlider(
                        carouselController: _sliderController,
                        items: _dataWidgets,
                        options: CarouselOptions(
                          disableCenter: true,
                          viewportFraction: 1,
                          enlargeCenterPage: false,
                          enableInfiniteScroll: false,
                          initialPage: 0,
                          height: double.infinity,
                          onPageChanged: (index, reason) {
                            _currentIndex.value = index;
                          },
                        ),
                      ),
                      Positioned(
                        left: 10,
                        right: 10,
                        bottom: 10,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: _currentIndex.value == _data.length - 1
                                  ? const SizedBox()
                                  : TextButton(
                                      onPressed: _onComplete,
                                      child: const Text("Skip"),
                                    ),
                            ),
                            Expanded(
                              flex: 5,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: _data.asMap().entries.map((entry) {
                                    return GestureDetector(
                                      onTap: () => _sliderController
                                          .animateToPage(entry.key),
                                      child: Container(
                                        width: 12.0,
                                        height: 12.0,
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 8.0,
                                          horizontal: 4.0,
                                        ),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              _currentIndex.value == entry.key
                                                  ? blueColor
                                                  : grayColor,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _currentIndex.value != _data.length - 1
                                      ? IconButton(
                                          onPressed: () {
                                            _sliderController.animateToPage(
                                                _currentIndex.value + 1);
                                            _currentIndex.value += 1;
                                          },
                                          icon: const Icon(
                                            Icons.arrow_forward_rounded,
                                            color: primaryColor,
                                          ),
                                        )
                                      : ElevatedButton(
                                          onPressed: _onComplete,
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 5,
                                              vertical: 0,
                                            ),
                                          ),
                                          child: const AutoSizeText(
                                            "Get Started",
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
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
          },
        ),
      ),
    );
  }
}
