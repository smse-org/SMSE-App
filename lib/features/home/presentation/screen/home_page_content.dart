import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smse/core/routes/app_router.dart';
import 'package:smse/features/search/data/model/search_query.dart';
import 'package:smse/features/search/data/model/search_results.dart';
import 'package:smse/features/search/presentation/controller/search_cubit.dart';
import 'package:smse/features/search/presentation/controller/search_state.dart';

import '../widgets/mobile_home.dart';
import '../widgets/web_home.dart';


class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<SearchCubit>().searchQueries();

    return BlocListener<SearchCubit,SearchState>(
      listener: (context, state) {
        if (state is SearchError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }else if (state is SearchSucsess) {
         GoRouter.of(context).go(AppRouter.search,extra :state.searchResults);
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            // Display mobile UI if the screen width is less than 600
            return const SafeArea(child: MobileHomePage());
          } else {
            // Display web UI if the screen width is 600 or more
            return const WebHomePage();
          }
        },
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
        Align(
          alignment: Alignment.center,
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: const [
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
      builder: (context, state) {
        final isSelected = context.read<SearchCubit>().selectedModalities.contains(value);
        final isDark = Theme.of(context).brightness == Brightness.dark;
        
        return FilterChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected 
                  ? (isDark ? Colors.white : Colors.white)
                  : (isDark ? Colors.white70 : Colors.black87),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected 
                    ? (isDark ? Colors.white : Colors.white)
                    : (isDark ? Colors.white70 : Colors.black87),
                ),
              ),
            ],
          ),
          selected: isSelected,
          onSelected: (selected) {
            context.read<SearchCubit>().toggleModality(value);
          },
          backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
          selectedColor: Theme.of(context).primaryColor,
          checkmarkColor: isDark ? Colors.white : Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isSelected 
                ? Theme.of(context).primaryColor
                : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
              width: 1,
            ),
          ),
          elevation: 0,
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
  final List<SearchQuery> results;
  final Function(String) onTextClicked;

  const SearchSuggestions({
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
        trailing: IconButton(onPressed:onDelete , icon: const Icon(Icons.close,color: Colors.red,)),
      ),
    );
  }
}
