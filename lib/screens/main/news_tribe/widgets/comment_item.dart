import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wonder_tool/models/comment.dart';
import 'package:wonder_tool/apis/urls.dart';
import 'package:wonder_tool/themes/colors.dart';

class CommentItemWidget extends StatelessWidget {
  final CommentModel comment;

  const CommentItemWidget({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _date = DateFormat('MMM, d, yyyy').format(comment.date!);

    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: SizedBox(
              height: 50,
              width: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: comment.userImage.isEmpty
                    ? Image.asset(
                        "assets/images/user.png",
                        fit: BoxFit.cover,
                      )
                    : CachedNetworkImage(
                        imageUrl: "$BASE_IMAGE_URL${comment.userImage}",
                        fit: BoxFit.cover,
                        errorWidget: (ctx, error, _) => Image.asset(
                          "assets/images/user.png",
                        ),
                        placeholder: (context, url) => Image.asset(
                          "assets/images/user.png",
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Flexible(
            flex: 6,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: lightBlackColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: AutoSizeText(
                          "${comment.firstName} ${comment.lastName}",
                          style: const TextStyle(
                            color: primaryColor,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                        ),
                      ),
                      AutoSizeText(
                        _date,
                        style: const TextStyle(color: grayColor, fontSize: 10),
                        maxLines: 1,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  AutoSizeText(
                    comment.text,
                    style: const TextStyle(
                      color: primaryColor,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
