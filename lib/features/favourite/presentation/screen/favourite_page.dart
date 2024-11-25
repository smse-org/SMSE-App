import 'package:flutter/material.dart';
import 'package:smse/features/favourite/presentation/widgets/favourite_page_mobile.dart';
import 'package:smse/features/favourite/presentation/widgets/favourite_page_web.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Favorites', style: TextStyle(fontSize: 24 , fontWeight: FontWeight.bold),),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            // Mobile layout
            return const SafeArea(child: FavoritesPageMobile());
          } else if (constraints.maxWidth < 800) {
            // Desktop layout
            return  const FavoritesPageWeb( 2);
          }else{
            return const FavoritesPageWeb( 3);
          }
        },
      ),
    );
  }
}
