import 'package:flutter/material.dart';
import 'package:smse/core/components/content_card.dart';
class FavoritesPageWeb extends StatelessWidget {
  const FavoritesPageWeb(this.number, {super.key});
  final int number;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: number, // Adjust based on screen size
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 3 / 2, // Adjust card dimensions
          ),
          itemCount: 10, // Replace with the length of your favorites list
          itemBuilder: (context, index) {
            return ContentCardWeb(
              title: 'File Name ${index + 1}',
              relevanceScore: 90 - (index * 5), // Example data
            );
          },
        ),
      ),
    );
  }
}

