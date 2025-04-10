class ContentModel {
  int? id; // Nullable
  String contentPath;
  bool contentTag;

  ContentModel({
    this.id,
    required this.contentPath,
    required this.contentTag,
  });

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      id: json['id'],
      contentPath: json['content_path'],
      contentTag: json['content_tag'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content_path': contentPath,
      'content_tag': contentTag,
    };
  }
}
