import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wonder_tool/connectors/data.dart';
import 'package:wonder_tool/apis/urls.dart';
import 'package:wonder_tool/themes/colors.dart';
import 'package:wonder_tool/widgets/loading_progress.dart';

class SoonScreen extends StatelessWidget {
  const SoonScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            FutureBuilder(
              future: DataConnector().getTribeImage(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingProgressWidget();
                } else {
                  if (snapshot.hasError) {
                    return AutoSizeText(snapshot.error.toString());
                  } else {
                    final _imageUrl = snapshot.data as String;

                    return SizedBox(
                      width: double.infinity,
                      child: _imageUrl.isEmpty
                          ? Image.asset(
                              "assets/images/wonderians.jpg",
                              fit: BoxFit.cover,
                            )
                          : CachedNetworkImage(
                              imageUrl: "$BASE_IMAGE_URL$_imageUrl",
                              fit: BoxFit.cover,
                              errorWidget: (ctx, error, _) => Image.asset(
                                "assets/images/launch.png",
                              ),
                              placeholder: (context, url) =>
                                  const LoadingProgressWidget(),
                            ),
                    );
                  }
                }
              },
            ),
            InkWell(
              onTap: () => Get.back(),
              child: const Padding(
                padding: EdgeInsets.all(20),
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
