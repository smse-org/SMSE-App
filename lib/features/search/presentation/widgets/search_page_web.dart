import 'package:flutter/material.dart';
import 'package:smse/components/content_card.dart';

class WebSearchView extends StatelessWidget {
  const WebSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 4 / 1.8,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return SearchResultCard(
          title: 'File Name ${index + 1}',
          score: 95 - (index * 5),
        );
      },
    );
  }
}