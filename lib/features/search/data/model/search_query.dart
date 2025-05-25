class SearchQuery {
  final int id;
  final String text;
  final DateTime timestamp;

  SearchQuery({
    required this.id,
    required this.text,
    required this.timestamp,
  });

  factory SearchQuery.fromJson(Map<String, dynamic> json) {
    String timestampStr = json['timestamp'] ?? DateTime.now().toIso8601String();
    DateTime timestamp;
    
    try {
      // Try parsing RFC 2822 format first
      timestamp = DateTime.parse(timestampStr);
    } catch (e) {
      try {
        // If that fails, try parsing with a custom format
        final parts = timestampStr.split(' ');
        if (parts.length >= 6) {
          final day = int.parse(parts[1]);
          final month = _getMonthNumber(parts[2]);
          final year = int.parse(parts[3]);
          final timeParts = parts[4].split(':');
          final hour = int.parse(timeParts[0]);
          final minute = int.parse(timeParts[1]);
          final second = int.parse(timeParts[2]);
          
          timestamp = DateTime(year, month, day, hour, minute, second);
        } else {
          timestamp = DateTime.now();
        }
      } catch (e) {
        timestamp = DateTime.now();
      }
    }

    return SearchQuery(
      id: json['id'] ?? 0,
      text: json['text'] ?? '',
      timestamp: timestamp,
    );
  }

  static int _getMonthNumber(String month) {
    const months = {
      'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4, 'May': 5, 'Jun': 6,
      'Jul': 7, 'Aug': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12
    };
    return months[month] ?? 1;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'SearchQuery(id: $id, text: $text, timestamp: $timestamp)';
  }
}

class SearchQueryResponse {
  final List<SearchQuery> queries;
  final Pagination pagination;

  SearchQueryResponse({
    required this.queries,
    required this.pagination,
  });

  factory SearchQueryResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> queriesList = json['queries'] as List<dynamic>;
    return SearchQueryResponse(
      queries: queriesList
          .map((query) => SearchQuery.fromJson(query as Map<String, dynamic>))
          .toList(),
      pagination: Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'queries': queries.map((query) => query.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}

class Pagination {
  final bool hasMore;
  final int limit;
  final int offset;
  final int total;

  Pagination({
    required this.hasMore,
    required this.limit,
    required this.offset,
    required this.total,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      hasMore: json['has_more'] ?? false,
      limit: json['limit'] ?? 10,
      offset: json['offset'] ?? 0,
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'has_more': hasMore,
      'limit': limit,
      'offset': offset,
      'total': total,
    };
  }
}