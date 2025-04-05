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

  const TextHomeCard({super.key, required this.title, this.onTap});

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
      ),
    );
  }
}
