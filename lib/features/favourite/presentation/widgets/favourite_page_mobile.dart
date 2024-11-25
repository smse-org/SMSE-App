import 'package:flutter/material.dart';
import 'package:smse/components/content_card.dart';

class FavoritesPageMobile extends StatelessWidget {
  const FavoritesPageMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          ContentCardWeb(
            title: 'Beautiful Sunset Beach Photo',
            relevanceScore: 95,
          ),
           ContentCardWeb(
            title: 'Document on Black Hole Research',
            relevanceScore: 90,
          ),
          // Add more cards here
        ],
      ),

    );
  }
}

