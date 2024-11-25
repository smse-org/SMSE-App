import 'package:flutter/material.dart';
import 'package:smse/features/search/presentation/widgets/mobile_search_page.dart';
import 'package:smse/features/search/presentation/widgets/search_page_web.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Search Results', style: TextStyle(fontSize: 24 , fontWeight: FontWeight.bold),),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            // Mobile view
            return const SafeArea(child: MobileSearchView());
          } else if (constraints.maxWidth < 800) {
            // Web/Desktop view
            return const WebSearchView(number: 2);
          }else{
            return const WebSearchView(number: 3);
          }
        },
      ),
    );
  }
}





