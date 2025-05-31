import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:smse/features/home/presentation/controller/theme_cubit/theme_cubit.dart';
import 'package:smse/features/home/presentation/screen/home_page_content.dart';
import 'package:smse/features/home/presentation/widgets/searchbar.dart';
import 'package:smse/features/search/presentation/controller/search_cubit.dart';
import 'package:smse/features/search/presentation/controller/search_state.dart';

import 'category_icon.dart';

class MobileHomePage extends StatelessWidget {
  const MobileHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  const SectionHeader('Recent Searches'),
                  const SizedBox(height: 10),
                  if (state is QueriesSuccess)
                    RecentSearches(
                      results: state.searchQuery,
                      onTextClicked: (text) {
                        context.read<SearchCubit>().search(text);
                      },
                    ),
                  const SizedBox(height: 20),
                  const SectionHeader('Suggested Searches'),
                  const SizedBox(height: 10),
                  SearchSuggestions(
                    onTextClicked: (text) {
                      context.read<SearchCubit>().search(text);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
