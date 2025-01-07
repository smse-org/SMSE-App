class ContentModel{
  int id;
  String content_path;
  bool content_tag;
  ContentModel({
    required this.id,
    required this.content_path,
    required this.content_tag,
  });

factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      id: json['id'],
      content_path: json['content_path'],
      content_tag: true,
    );
  }
Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content_path': content_path,
      'content_tag': true,
    };
  }
}