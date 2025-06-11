import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:smse/features/home/presentation/controller/theme_cubit/theme_cubit.dart';
import 'package:smse/features/home/presentation/screen/home_page_content.dart';
import 'package:smse/features/search/presentation/controller/search_cubit.dart';
import 'package:smse/features/search/presentation/controller/search_state.dart';
import 'package:smse/features/search/data/model/search_query.dart';
import 'package:smse/core/services/suggestions_service.dart';
import '../widgets/searchbar.dart';

import 'category_icon.dart';

class MobileHomePage extends StatefulWidget {
  const MobileHomePage({super.key});

  @override
  State<MobileHomePage> createState() => _MobileHomePageState();
}

class _MobileHomePageState extends State<MobileHomePage> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      buildWhen: (previous, current) => 
        current is QueriesSuccess || 
        current is SearchInitial,
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              SearchBarCustom(
                controller: searchController,
                onSearch: (query) {
                  if (query.isNotEmpty) {
                    context.read<SearchCubit>().searchWithText(
                      query,
                      limit: 10,
                      modalities: context.read<SearchCubit>().selectedModalities.isEmpty 
                        ? null 
                        : context.read<SearchCubit>().selectedModalities,
                    );
                  }
                },
              ),
              const SizedBox(height: 24),
              const ModalitySelector(),
              const SizedBox(height: 24),
              if (state is QueriesSuccess && state.queries.isNotEmpty) ...[
                const Text(
                  'Recent Searches',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...state.queries.take(4).map(
                  (query) => TextHomeCard(
                    title: query.text,
                    onTap: () {
                      searchController.text = query.text;
                      context.read<SearchCubit>().searchWithText(
                        query.text,
                        limit: 10,
                        modalities: context.read<SearchCubit>().selectedModalities.isEmpty 
                          ? null 
                          : context.read<SearchCubit>().selectedModalities,
                      );
                    },
                    onDelete: () {
                      context.read<SearchCubit>().deleteQuery(query.id);
                    },
                  ),
                ),
              ],
              const SizedBox(height: 24),
              const Text(
                'Suggested Searches',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...SuggestionsService.getRandomSuggestions().map(
                (suggestion) => TextHomeCard(
                  title: suggestion,
                  onTap: () {
                    searchController.text = suggestion;
                    context.read<SearchCubit>().searchWithText(
                      suggestion,
                      limit: 10,
                      modalities: context.read<SearchCubit>().selectedModalities.isEmpty 
                        ? null 
                        : context.read<SearchCubit>().selectedModalities,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class TextHomeCard extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const TextHomeCard({
    super.key,
    required this.title,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black
              : Colors.white70,
        ),
        borderRadius: BorderRadius.circular(5),
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.black,
      ),
      child: ListTile(
        title: Text(title),
        onTap: onTap,
        trailing: onDelete != null
            ? IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.close, color: Colors.red),
              )
            : null,
      ),
    );
  }
}
