import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smse/core/routes/app_router.dart';
import 'package:smse/core/services/suggestions_service.dart';
import 'package:smse/features/search/data/model/search_query.dart';
import 'package:smse/features/search/data/model/search_results.dart';
import 'package:smse/features/search/data/repositories/search_repo_imp.dart';
import 'package:smse/features/search/presentation/controller/search_cubit.dart';
import 'package:smse/features/search/presentation/controller/search_state.dart';
import 'package:smse/features/search/presentation/screen/search_page.dart';
import 'package:smse/features/uploded_content/presentation/controller/cubit/content_cubit.dart';
import 'package:smse/features/uploded_content/data/repositories/display_content_repo_imp.dart';
import 'package:smse/core/network/api/api_service.dart';
import 'package:dio/dio.dart';
import 'package:smse/features/search/data/repositories/search_repo.dart';

import '../widgets/mobile_home.dart';
import '../widgets/web_home.dart';
import '../widgets/searchbar.dart';

class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SearchCubit>(
          create: (context) => SearchCubit(
            SearchRepositoryImpl(ApiService(Dio())),
          )..searchQueries(),
        ),
        BlocProvider<ContentCubit>(
          create: (context) => ContentCubit(
            DisplayContentRepoImp(ApiService(Dio())),
          ),
        ),
      ],
      child: BlocListener<SearchCubit,SearchState>(
        listener: (context, state) {
          if (state is SearchError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          } else if (state is SearchSucsess) {
            // Use pushNamed instead of go for web compatibility
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
              SearchPage(searchResults: state.searchResults)));
          }
        },
        child: BlocBuilder<SearchCubit, SearchState>(
          buildWhen: (previous, current) => 
            current is QueriesSuccess || 
            current is SearchInitial,
          builder: (context, state) {
            return LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 600) {
                  // Display mobile UI if the screen width is less than 600
                  return const SafeArea(child: MobileHomePage());
                } else {
                  // Display web UI if the screen width is 600 or more
                  return const WebHomePage();
                }
              },
            );
          },
        ),
      ),
    );
  }
}

class ModalitySelector extends StatelessWidget {
  const ModalitySelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Text(
            'Filter by Modality',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).brightness == Brightness.light 
                ? Colors.black87 
                : Colors.white70,
            ),
          ),
        ),
        const SizedBox(height: 12),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                _ModalityChip(
                  label: 'Text',
                  value: 'text',
                  icon: Icons.text_fields_rounded,
                ),
                _ModalityChip(
                  label: 'Image',
                  value: 'image',
                  icon: Icons.image_rounded,
                ),
                _ModalityChip(
                  label: 'Audio',
                  value: 'audio',
                  icon: Icons.audio_file_rounded,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ModalityChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ModalityChip({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      buildWhen: (previous, current) => true, // Always rebuild to ensure state is current
      builder: (context, state) {
        final searchCubit = context.read<SearchCubit>();
        final isSelected = searchCubit.selectedModalities.contains(value);
        final isDark = Theme.of(context).brightness == Brightness.dark;
        
        return TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          tween: Tween(begin: 0.0, end: isSelected ? 1.0 : 0.0),
          builder: (context, animationValue, child) {
            return Transform.scale(
              scale: 0.95 + (animationValue * 0.05),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    searchCubit.toggleModality(value);
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected 
                        ? Theme.of(context).colorScheme.primary
                        : (isDark ? Colors.grey[800] : Colors.grey[200]),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected 
                          ? Theme.of(context).colorScheme.primary
                          : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          icon,
                          size: 18,
                          color: isSelected 
                            ? Colors.white
                            : (isDark ? Colors.white70 : Colors.black87),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected 
                              ? Colors.white
                              : (isDark ? Colors.white70 : Colors.black87),
                          ),
                        ),
                        if (isSelected) ...[
                          const SizedBox(width: 4),
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color: Colors.white,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class RecentSearches extends StatelessWidget {
  final List<SearchQuery> results;
  final Function(String) onTextClicked;

  const RecentSearches({
    super.key,
    required this.results,
    required this.onTextClicked,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: results.take(4).map(
            (result) {
          return TextHomeCard(
            title: result.text,
            onTap: () => onTextClicked(result.text),
            onDelete: () {
              context.read<SearchCubit>().deleteQuery(result.id);
            },
          );
        },
      ).toList(),
    );
  }
}


class SearchSuggestions extends StatelessWidget {
  final Function(String) onTextClicked;

  const SearchSuggestions({
    super.key,
    required this.onTextClicked,
  });

  @override
  Widget build(BuildContext context) {
    final suggestions = SuggestionsService.getRandomSuggestions();
    return Column(
      children: suggestions.map(
        (suggestion) {
          return TextHomeCard(
            title: suggestion,
            onTap: () => onTextClicked(suggestion),
          );
        },
      ).toList(),
    );
  }
}


class TextHomeCard extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  const TextHomeCard({super.key, required this.title, this.onTap, this.onDelete});

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
