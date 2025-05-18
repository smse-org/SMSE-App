class ContentModel {
  int? id; // Nullable
  String contentPath;
  bool contentTag;
  int contentSize;
  DateTime uploadDate;

  ContentModel({
    this.id,
    required this.contentPath,
    required this.contentTag,
    required this.contentSize,
    required this.uploadDate
  });

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      id: json['id'],
      contentPath: json['content_path'],
      contentTag: json['content_tag'] ?? false,
      contentSize: json['content_size'] ?? 0,
      uploadDate: DateTime.parse(json['upload_date'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content_path': contentPath,
      'content_tag': contentTag,
      'content_size': contentSize,
      'upload_date': uploadDate.toIso8601String(),
    };
  }
}

