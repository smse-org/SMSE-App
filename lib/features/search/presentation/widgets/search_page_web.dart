import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smse/components/content_card.dart';
import 'package:smse/features/home/presentation/widgets/searchbar.dart';

class WebSearchView extends StatefulWidget {
  const WebSearchView( { required this.number});
  final int number;

  @override
  State<WebSearchView> createState() => _WebSearchViewState();
}

class _WebSearchViewState extends State<WebSearchView> {
  bool isLoading = true; // Loading state
  @override
  void initState() {
    super.initState();
    // Simulate a delay for loading state
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB( 16, 0, 16, 0),
          child: SearchBarCustom(),
        ),
        const SizedBox(height: 20),
        Skeletonizer(
          enabled: isLoading,
          child: Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(16.0),
              gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.number, // Adjust based on screen size
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3 / 2,
              ),
              itemCount: 3,
              itemBuilder: (context, index) {
                return ContentCardWeb(
                  title: 'File Name ${index + 1}',
                  relevanceScore: 95 - (index * 5),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}