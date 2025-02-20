import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smse/core/components/content_card.dart';
import 'package:smse/features/home/presentation/widgets/searchbar.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smse/features/search/data/model/search_results.dart';
import 'package:smse/features/search/presentation/controller/search_cubit.dart';
import 'package:smse/features/search/presentation/controller/search_state.dart';
class MobileSearchView extends StatelessWidget {
  const MobileSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        return Column(
          children: [
            const SizedBox(height: 20),
            if (state is SearchLoading)
              const Skeletonizer(
                enabled: true,
                child: _BuildDummyContent(),
              )
            else if (state is SearchSucsess)
              _buildContentList(state.searchResults)
            else if (state is SearchError)
                Center(child: Text(state.message))
              else
                const Center(child: Text('Start searching...')),
          ],
        );
      },
    );
  }

  Widget _buildContentList(List<SearchResult> results) {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(8.0),
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

class _BuildDummyContent extends StatelessWidget {
  const _BuildDummyContent();

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(8.0),
      children: const [
        ContentCardWeb(
          title: 'Loading content...',
          relevanceScore: 95,
        ),
        ContentCardWeb(
          title: 'Loading content...',
          relevanceScore: 90,
        ),
      ],
    );
  }
}