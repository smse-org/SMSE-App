import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smse/features/home/presentation/screen/home_page_content.dart';
import 'package:smse/features/home/presentation/widgets/searchbar.dart';
import 'package:smse/features/search/presentation/controller/search_cubit.dart';

import 'category_icon.dart';

class MobileHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),  // Padding for mobile layout
            const Text(
              "Search beyond keywords",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SearchBarCustom(onSearch:
            (query) {
              context.read<SearchCubit>().search(query);

            }
              ),
            const SizedBox(height: 20),
            CategoryIcons(),
            const SizedBox(height: 20),
            SectionHeader("Recent Searches"),
            RecentSearches(),
            const SizedBox(height: 20),
            SectionHeader("Search Suggestions"),
            SearchSuggestions(),
            const SizedBox(height: 40),  // Padding at the bottom for mobile
          ],
        ),
      ),
    );
  }
}
