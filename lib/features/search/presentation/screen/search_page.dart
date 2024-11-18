import 'package:flutter/material.dart';
import 'package:smse/features/search/presentation/screen/search_page.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results', style: TextStyle(fontSize: 24 , fontWeight: FontWeight.bold),),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            // Mobile view
            return MobileSearchView();
          } else {
            // Web/Desktop view
            return WebSearchView();
          }
        },
      ),
    );
  }
}




