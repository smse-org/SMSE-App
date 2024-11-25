import 'package:flutter/material.dart';
import 'package:smse/components/content_card.dart';
import 'package:smse/features/home/presentation/widgets/searchbar.dart';


class MobileSearchView extends StatelessWidget {
  const MobileSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children:[

        SearchBarCustom(),

        const SizedBox(height: 20),
        ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(8.0),
          children: const [
            ContentCardWeb(
              title: 'Beautiful Sunset Beach Photo',
              relevanceScore: 95,
            ),
            ContentCardWeb(
              title: 'Document on Black Hole Research',
              relevanceScore: 90,
            ),
          ],
        ),
      ]
    );
  }
}