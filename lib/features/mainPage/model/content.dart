class ContentModel {
  int? id; // Nullable
  String contentPath;
  bool contentTag;
  int contentSize;
  String thumbnailPath;
  DateTime uploadDate;

  ContentModel({
    this.id,
    required this.contentPath,
    required this.contentTag,
    required this.contentSize,
    required this.uploadDate,
    required this.thumbnailPath,
  });

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(String? dateStr) {
      if (dateStr == null) return DateTime.now();
      
      try {
        // Try parsing RFC 2822 format first
        final parts = dateStr.split(' ');
        if (parts.length >= 6) {
          final day = int.parse(parts[1]);
          final month = _getMonthNumber(parts[2]);
          final year = int.parse(parts[3]);
          final timeParts = parts[4].split(':');
          final hour = int.parse(timeParts[0]);
          final minute = int.parse(timeParts[1]);
          final second = int.parse(timeParts[2]);
          
          return DateTime(year, month, day, hour, minute, second);
        }
        
        // Fallback to ISO 8601 format
        return DateTime.parse(dateStr);
      } catch (e) {
        print('Error parsing date: $dateStr, Error: $e');
        return DateTime.now();
      }
    }

    return ContentModel(
      id: json['id'],
      contentPath: json['content_path'],
      contentTag: json['content_tag'] ?? false,
      contentSize: json['content_size'] ?? 0,
      uploadDate: parseDate(json['upload_date']),
      thumbnailPath: json['thumbnail_path'] ?? '',
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
      'content_path': contentPath,
      'content_tag': contentTag,
      'content_size': contentSize,
      'upload_date': uploadDate.toIso8601String(),
      'thumbnail_path': thumbnailPath,
    };
  }
}

