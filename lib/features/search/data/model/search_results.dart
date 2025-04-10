class SearchResult {
  final int contentId;
  final double similarityScore;

  SearchResult({required this.contentId, required this.similarityScore});

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      contentId:int.tryParse(json["content_id"].toString()) ?? 0,
      similarityScore: double.tryParse(json["similarity_score"].toString()) ?? 0.0,
    );
  }

}