class UserPreferences {
  final String? textModel;
  final String? imageModel;
  final String? audioModel;
  final bool isDarkMode;

  UserPreferences({
    this.textModel,
    this.imageModel,
    this.audioModel,
    this.isDarkMode = false,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      return UserPreferences();
    }
    
    return UserPreferences(
      textModel: json['textModel']?.toString(),
      imageModel: json['imageModel']?.toString(),
      audioModel: json['audioModel']?.toString(),
      isDarkMode: json['isDarkMode'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (textModel != null) data['textModel'] = textModel;
    if (imageModel != null) data['imageModel'] = imageModel;
    if (audioModel != null) data['audioModel'] = audioModel;
    data['isDarkMode'] = isDarkMode;
    return data;
  }

  UserPreferences copyWith({
    String? textModel,
    String? imageModel,
    String? audioModel,
    bool? isDarkMode,
  }) {
    return UserPreferences(
      textModel: textModel ?? this.textModel,
      imageModel: imageModel ?? this.imageModel,
      audioModel: audioModel ?? this.audioModel,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
} 