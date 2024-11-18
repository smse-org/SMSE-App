import 'package:flutter/material.dart';
import 'package:smse/components/content_card.dart';


class MobileSearchView extends StatelessWidget {
  const MobileSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        SearchResultCard(
          title: 'Beautiful Sunset Beach Photo',
          score: 95,
        ),
        SearchResultCard(
          title: 'Document on Black Hole Research',
          score: 90,
        ),
      ],
    );
  }
}