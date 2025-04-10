class SearchQuery{
  int id;
  String text;
  String timeStamp;

  SearchQuery({
    required this.id,
    required this.text,
    required this.timeStamp,
  });
  factory SearchQuery.fromJson(Map<String, dynamic> json) {
    return SearchQuery(
      id: json["id"],
      text: json["text"],
      timeStamp: json["timestamp"],
    );
  }
}