import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:smse/features/home/presentation/screen/home_page_content.dart';
import 'package:smse/features/home/presentation/widgets/searchbar.dart';
import 'package:smse/features/search/presentation/controller/search_cubit.dart';
import 'package:smse/features/search/presentation/controller/search_state.dart';
import 'package:smse/features/search/data/model/search_query.dart';
import 'package:smse/core/services/suggestions_service.dart';

import 'category_icon.dart';

class WebHomePage extends StatefulWidget {
  const WebHomePage({super.key});

  @override
  State<WebHomePage> createState() => _WebHomePageState();
}

class _WebHomePageState extends State<WebHomePage> {
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
        return Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            padding: const EdgeInsets.all(32),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  const SizedBox(height: 48),
                  if (state is QueriesSuccess && state.queries.isNotEmpty) ...[
                    const Text(
                      'Recent Searches',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
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
                  const SizedBox(height: 48),
                  const Text(
                    'Suggested Searches',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
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
            ),
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
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black
              : Colors.white70,
        ),
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.black,
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 16),
        ),
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
