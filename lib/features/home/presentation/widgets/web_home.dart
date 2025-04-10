import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:smse/features/home/presentation/screen/home_page_content.dart';
import 'package:smse/features/home/presentation/widgets/searchbar.dart';
import 'package:smse/features/search/presentation/controller/search_cubit.dart';
import 'package:smse/features/search/presentation/controller/search_state.dart';

import 'category_icon.dart';

class WebHomePage extends StatelessWidget {
  const WebHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _searchController = TextEditingController();

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
                SearchBarCustom(
                  controller: _searchController,
                  onSearch: (query) {
                    context.read<SearchCubit>().search(query);
                  },
                ),
                const SizedBox(height: 30),
                const CategoryIcons(),
                const SizedBox(height: 30),
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

                //  RecentSearches(),
                const SizedBox(height: 30),
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

                //SearchSuggestions(),
                const SizedBox(height: 50),  // Additional spacing for web layout
              ],
            ),
          ),
        ),
      ),
    );
  }
}
