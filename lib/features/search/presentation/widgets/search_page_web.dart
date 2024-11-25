import 'package:flutter/material.dart';
import 'package:smse/components/content_card.dart';
import 'package:smse/features/home/presentation/widgets/searchbar.dart';

class WebSearchView extends StatelessWidget {
  const WebSearchView( { required this.number});
  final int number;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB( 16, 0, 16, 0),
          child: SearchBarCustom(),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(16.0),
            gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: number, // Adjust based on screen size
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 3 / 2,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              return ContentCardWeb(
                title: 'File Name ${index + 1}',
                relevanceScore: 95 - (index * 5),
              );
            },
          ),
        ),
      ],
    );
  }
}