import 'package:smse/features/mainPage/model/content.dart';

class SearchResult {
  final int contentId;
  final String contentPath;
  final bool contentTag;
  final double similarityScore;

  SearchResult({
    required this.contentId,
    required this.contentPath,
    required this.contentTag,
    required this.similarityScore,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      contentId: json['content_id'] ?? 0,
      contentPath: json['content_path'] ?? '',
      contentTag: json['content_tag'] ?? false,
      similarityScore: (json['similarity_score'] ?? 0.0).toDouble(),
    );
  }

  String get fileName {
    final parts = contentPath.split('/');
    if (parts.length > 1) {
      final fileName = parts.last;
      return fileName.replaceAll('_text.txt', '');
    }
    return contentPath;
  }

  ContentModel toContentModel() {
    return ContentModel(
      id: contentId,
      contentPath: fileName,
      contentTag: contentTag,
      contentSize: 0, // Since we don't have this info in search results
      uploadDate: DateTime.now(), // Since we don't have this info in search results
    );
  }
}

class SearchResponse {
  final String message;
  final int queryId;
  final String queryType;
  final List<SearchResult> results;
  final Pagination pagination;

  SearchResponse({
    required this.message,
    required this.queryId,
    required this.queryType,
    required this.results,
    required this.pagination,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    return SearchResponse(
      message: json['message'] ?? '',
      queryId: json['query_id'] ?? 0,
      queryType: json['query_type'] ?? '',
      results: (json['results'] as List?)
          ?.map((result) => SearchResult.fromJson(result))
          .toList() ?? [],
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }
}

class Pagination {
  final int limit;

  Pagination({
    required this.limit,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      limit: json['limit'] ?? 10,
    );
  }
}