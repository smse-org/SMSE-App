import 'package:flutter/material.dart';
class SearchResultCard extends StatelessWidget {
  final String title;
  final int score;

  SearchResultCard({required this.title, required this.score});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Placeholder(
              fallbackHeight: 100,
              fallbackWidth: double.infinity,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text('Relevance Score: $score'),
          ],
        ),
      ),
    );
  }
}