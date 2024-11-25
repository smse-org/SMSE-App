import 'package:flutter/material.dart';
import 'package:smse/features/home/presentation/widgets/searchbar.dart';

import '../screen/homapage.dart';
import 'category_icon.dart';

class WebHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(

          constraints: const BoxConstraints(maxWidth: double.infinity),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Explore Beyond Keywords",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                 SearchBarCustom(),
                const SizedBox(height: 30),
                CategoryIcons(),
                const SizedBox(height: 30),
                SectionHeader("Recent Searches"),
                RecentSearches(),
                const SizedBox(height: 30),
                SectionHeader("Search Suggestions"),
                SearchSuggestions(),
                const SizedBox(height: 50),  // Additional spacing for web layout
              ],
            ),
          ),
        ),
      ),
    );
  }
}
