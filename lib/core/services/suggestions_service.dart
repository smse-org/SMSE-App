import 'dart:math';

class SuggestionsService {
  static final List<String> _suggestions = [
    'Search for documents',
    'Find images',
    'Look for audio files',
    'Browse recent uploads',
    'Search by tags',
    'Find similar content',
    'Explore categories',
    'Search by date',
    'Find popular content',
    'Browse favorites',
    'Search by file type',
    'Find trending content',
    'Explore collections',
    'Search by size',
    'Find related files',
    'Browse by modality',
    'Search by author',
    'Find shared content',
    'Explore recent changes',
    'Search by keywords',
  ];

  static List<String> getRandomSuggestions({int count = 4}) {
    final random = Random();
    final shuffled = List<String>.from(_suggestions)..shuffle(random);
    return shuffled.take(count).toList();
  }

  static String getRandomSuggestion() {
    final random = Random();
    return _suggestions[random.nextInt(_suggestions.length)];
  }
} 