import 'package:fancy_bottom_navigation_plus/fancy_bottom_navigation_plus.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:smse/features/favourite/presentation/screen/favourite_page.dart';
import 'package:smse/features/home/presentation/screen/homapage.dart';
import 'package:smse/features/profile/presentation/screen/profile_page.dart';
import 'package:smse/features/search/presentation/screen/search_page.dart';

class MobileLayout extends StatefulWidget {
  final VoidCallback toggleTheme;
  final ThemeMode themeMode;

  const MobileLayout({super.key, required this.toggleTheme, required this.themeMode});

  @override
  _MobileLayoutState createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
HomePage(),
    SearchPage(),
    const FavoritesPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SMSE",style: TextStyle(fontSize: 24 , fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(widget.themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: FancyBottomNavigationPlus(
        initialSelection: _currentIndex,
        shadowRadius: 10,
        circleColor: widget.themeMode == ThemeMode.light ? Colors.white : Colors.black,
        onTabChangedListener: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        // selectedItemColor: widget.themeMode == ThemeMode.light ? Colors.black : Colors.white,
        // unselectedItemColor:widget.themeMode == ThemeMode.light ? Colors.grey : Colors.grey[300],
        tabs:  [
          TabData(
            icon: const Icon(Icons.home),
            title: "Home",

          ),
          TabData(
            icon: const Icon(Icons.search),
            title: "Search",
          ),
          TabData(
            icon: const Icon(Icons.favorite),
            title: "Favorites",
          ),
          TabData(
            icon: const Icon(Icons.person),
            title: "Profile",
          ),
        ],
      ),
    );
  }
}
