import 'package:flutter/material.dart';
import 'package:smse/features/mainPage/web.dart';
import 'package:smse/features/mainPage/mobile.dart';

class ResponsiveHome extends StatelessWidget {
  final VoidCallback toggleTheme;
  final ThemeMode themeMode;
  final Widget child; // Accept the routed child widget

  const ResponsiveHome({
    required this.toggleTheme,
    required this.themeMode,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return WebLayout(
            toggleTheme: toggleTheme,
            themeMode: themeMode,

          );
        } else {
          return MobileLayout(
            toggleTheme: toggleTheme,
            themeMode: themeMode,
            child: child, // Pass child to MobileLayout
          );
        }
      },
    );
  }
}
