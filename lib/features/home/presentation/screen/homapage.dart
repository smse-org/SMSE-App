import 'package:flutter/material.dart';

import '../widgets/mobile_home.dart';
import '../widgets/web_home.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          // Display mobile UI if the screen width is less than 600
          return SafeArea(child: MobileHomePage());
        } else {
          // Display web UI if the screen width is 600 or more
          return WebHomePage();
        }
      },
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
        ListTile(
          title: Text("Sunset beach photos"),
        ),
        ListTile(
          title: Text("Black hole research papers"),
        ),
        ListTile(
          title: Text("Jazz music albums"),
        ),
        ListTile(
          title: Text("Documentaries on space exploration"),
        ),
      ],
    );
  }
}

class SearchSuggestions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ListTile(
          title: Text("Popular travel destinations"),
        ),
        ListTile(
          title: Text("Latest technology trends"),
        ),
        ListTile(
          title: Text("Top movies of 2023"),
        ),
        ListTile(
          title: Text("Healthy recipes for dinner"),
        ),
      ],
    );
  }
}
