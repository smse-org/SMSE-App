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
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 800),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            "Search beyond keywords",
                            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            onSubmitted: (value) {
                              context.read<SearchCubit>().search(value);
                            },
                            decoration: InputDecoration(
                              hintText: 'Search...',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const ModalitySelector(),
                          const SizedBox(height: 20),
                          Wrap(
                            spacing: 40,
                            runSpacing: 20,
                            children: [
                              SizedBox(
                                width: constraints.maxWidth > 600 ? (constraints.maxWidth) / 1.1 : constraints.maxWidth,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SectionHeader('Recent Searches'),
                                    const SizedBox(height: 20),
                                    if (state is QueriesSuccess)
                                      RecentSearches(
                                        results: state.searchQuery,
                                        onTextClicked: (text) {
                                          context.read<SearchCubit>().search(text);
                                        },
                                      ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: constraints.maxWidth > 600 ? (constraints.maxWidth ) / 1.1 : constraints.maxWidth,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SectionHeader('Suggested Searches'),
                                    const SizedBox(height: 20),
                                    SearchSuggestions(
                                      onTextClicked: (text) {
                                        context.read<SearchCubit>().search(text);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
