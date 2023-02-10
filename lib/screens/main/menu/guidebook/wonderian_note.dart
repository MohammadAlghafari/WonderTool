import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:wonder_tool/connectors/data.dart';
import 'package:wonder_tool/helpers/constants.dart';
import 'package:wonder_tool/models/notes.dart';
import 'package:wonder_tool/screens/main/menu/drawer.dart';
import 'package:wonder_tool/themes/colors.dart';
import 'package:wonder_tool/widgets/animation_list.dart';
import 'package:wonder_tool/widgets/custom_app_bar.dart';
import 'package:wonder_tool/widgets/custom_safe_area.dart';
import 'package:wonder_tool/widgets/loading_progress.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class WonderianNotesScreen extends StatelessWidget {
  const WonderianNotesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomSafeArea(
      child: Scaffold(
        endDrawer: const CustomDrawerWidget(),
        appBar: customeAppBar(title: 'Wonderian Notes', hasBack: true),
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: DataConnector().getNotes(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingProgressWidget();
              } else {
                if (snapshot.hasError) {
                  return AutoSizeText(snapshot.error.toString());
                } else {
                  final _notes = snapshot.data as List<NoteModel>;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 20,
                    ),
                    child: AnimationLimiter(
                      child: ListView.separated(
                        itemCount: _notes.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (_, __) => Divider(
                          height: 2,
                          thickness: 1,
                          color: grayColor.withOpacity(0.5),
                        ),
                        itemBuilder: (context, index) {
                          return AnimationListWidget(
                            index: index,
                            isVertical: true,
                            child: NoteItemWidget(
                              note: _notes[index],
                            ),
                          );
                        },
                      ),
                    ),
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

class NoteItemWidget extends StatelessWidget {
  final NoteModel note;

  const NoteItemWidget({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            note.title,
            style: const TextStyle(
              color: primaryColor,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(defaultRaduis),
            child: YoutubePlayer(
              controller: YoutubePlayerController(
                initialVideoId: YoutubePlayer.convertUrlToId(note.video)!,
                flags: const YoutubePlayerFlags(
                  autoPlay: false,
                ),
              ),
              bottomActions: [
                const SizedBox(width: 14.0),
                CurrentPosition(),
                const SizedBox(width: 8.0),
                ProgressBar(isExpanded: true),
                RemainingDuration(),
                const PlaybackSpeedButton(),
              ],
              showVideoProgressIndicator: true,
              progressIndicatorColor: blueColor,
            ),
          ),
        ],
      ),
    );
  }
}
