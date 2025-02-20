import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smse/core/routes/app_router.dart';
import 'package:smse/features/search/presentation/controller/search_cubit.dart';
import 'package:smse/features/search/presentation/controller/search_state.dart';

import '../widgets/mobile_home.dart';
import '../widgets/web_home.dart';


class HomePageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchCubit,SearchState>(
      listener: (context, state) {
        if (state is SearchError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }else if (state is SearchSucsess) {
         GoRouter.of(context).go(AppRouter.KSearch,extra :state.searchResults);
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            // Display mobile UI if the screen width is less than 600
            return SafeArea(child: MobileHomePage());
          } else {
            // Display web UI if the screen width is 600 or more
            return WebHomePage();
          }
        },
      ),
    );
  }
}





class SectionHeader extends StatelessWidget {
  final String title;

  SectionHeader(this.title);

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
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        TextHomeCard(title: "Sunset beach photos"),
        TextHomeCard(title: "Black hole research"),
        TextHomeCard(title: "Documentaries on space exploration"),
        TextHomeCard(title: "Healthy recipes for dinner"),
      ],
    );
  }
}

class SearchSuggestions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        TextHomeCard(title: "Popular travel destinations"),
        TextHomeCard(title: "Latest technology trends"),
        TextHomeCard(title: "Top movies of 2023"),
        TextHomeCard(title: "Healthy recipes for dinner"),

      ],
    );
  }
}


class TextHomeCard extends StatelessWidget {
  const TextHomeCard({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white70),
        borderRadius: BorderRadius.circular(5),
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.black,
      ),
      child:  ListTile(
        title: Text(title),
      ),
    );
  }
}
