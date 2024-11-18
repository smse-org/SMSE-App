import 'package:flutter/material.dart';
import 'package:smse/features/search/presentation/screen/search_page.dart';


class MobileSearchView extends StatelessWidget {
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