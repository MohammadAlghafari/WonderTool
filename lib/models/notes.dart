class NoteModel {
  final String title;
  final String video;

  NoteModel({
    required this.title,
    required this.video,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) => NoteModel(
        title: json['title'] ?? "",
        video: json['video'] ?? "",
      );
}
