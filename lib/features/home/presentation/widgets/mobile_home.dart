import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:smse/features/home/presentation/screen/home_page_content.dart';
import 'package:smse/features/home/presentation/widgets/searchbar.dart';
import 'package:smse/features/search/presentation/controller/search_cubit.dart';
import 'package:smse/features/search/presentation/controller/search_state.dart';

import 'category_icon.dart';

class MobileHomePage extends StatelessWidget {
  const MobileHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _searchController = TextEditingController();
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Text(
              "Search beyond keywords",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SearchBarCustom(
              controller: _searchController,
              onSearch: (query) {
                context.read<SearchCubit>().search(query);
              },
            ),
            const SizedBox(height: 20),
           // const CategoryIcons(),
            const SizedBox(height: 20),
            const SectionHeader("Recent Searches"),
            BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return const Center(child: SpinKitCubeGrid(color: Colors.black));
                } else if (state is QueriesSuccess) {
                  return RecentSearches(
                    results: state.searchQuery,
                    onTextClicked: (text) {
                      _searchController.text = text;
                      context.read<SearchCubit>().search(text);
                    },
                  );
                } else {
                  return const Center(child: Text("No recent searches found"));
                }
              },
            ),

            const SizedBox(height: 20),
            const SectionHeader("Search Suggestions"),
            BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return const Center(child: SpinKitCubeGrid(color: Colors.black));
                } else if (state is QueriesSuccess) {
                  return SearchSuggestions(
                    results: state.searchQuery,
                    onTextClicked: (text) {
                      _searchController.text = text;
                      context.read<SearchCubit>().search(text);
                    },
                  );
                } else {
                  return const Center(child: Text("No suggestions available"));
                }
              },
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
