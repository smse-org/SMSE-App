import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smse/core/components/content_card.dart';
import 'package:smse/features/search/data/model/search_results.dart';
import 'package:smse/features/search/presentation/controller/search_cubit.dart';
import 'package:smse/features/search/presentation/controller/search_state.dart';

class WebSearchView extends StatelessWidget {
  const WebSearchView({required this.number});
  final int number;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        return Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: _buildContent(state),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContent(SearchState state) {
    if (state is SearchLoading) {
      return _buildSkeletonGrid();
    } else if (state is SearchSucsess) {
      return _buildResultsGrid(state.searchResults);
    } else if (state is SearchError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(state.message),
          ],
        ),
      );
    } else {
      return const Center(
        child: Text('Start searching...'),
      );
    }
  }

  Widget _buildSkeletonGrid() {
    return Skeletonizer(
      enabled: true,
      child: GridView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: number,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 3 / 2,
        ),
        itemCount: 6, // Show more skeleton items
        itemBuilder: (context, index) {
          return const ContentCardWeb(
            title: 'Loading content...',
            relevanceScore: 95,
          );
        },
      ),
    );
  }

  Widget _buildResultsGrid(List<SearchResult> results) {
    if (results.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text('No results found'),
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(16.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: number,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 3 / 2,
      ),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];
        return ContentCardWeb(
          title: 'Content ID: ${result.contentId}',
          relevanceScore: (result.similarityScore * 100).round(),
        );
      },
    );
  }
}