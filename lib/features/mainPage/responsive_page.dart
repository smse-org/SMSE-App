import 'package:flutter/material.dart';
import 'package:smse/features/mainPage/mobile.dart';
import 'package:smse/features/mainPage/web.dart';

class ResponsiveHome extends StatelessWidget {
  final VoidCallback toggleTheme;
  final ThemeMode themeMode;

  const ResponsiveHome({required this.toggleTheme, required this.themeMode});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return WebLayout(toggleTheme: toggleTheme, themeMode: themeMode);
        } else {
          return MobileLayout(toggleTheme: toggleTheme, themeMode: themeMode);
        }
      },
    );
  }
}
