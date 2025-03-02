import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:fancy_bottom_navigation_plus/fancy_bottom_navigation_plus.dart';
import 'package:smse/core/routes/app_router.dart';
import 'package:smse/features/home/presentation/controller/theme_cubit/theme_cubit.dart';

class MobileLayout extends StatelessWidget {
  final Widget child; // Render the current page
  final VoidCallback toggleTheme;
  final ThemeMode themeMode;

  const MobileLayout({
    required this.child,
    required this.toggleTheme,
    required this.themeMode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => GoRouter.of(context).push(AppRouter.KSearchAnimation), // Example navigation
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        title: const Text("SMSE", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        actions: [
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return IconButton(
                icon: Icon(themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode),
                onPressed: () => context.read<ThemeCubit>().toggleTheme(), // Toggle theme using ThemeCubit
              );
            },
          ),
        ],
      ),
      body: child, // Render the current page
      bottomNavigationBar: FancyBottomNavigationPlus(
        initialSelection: currentIndex,
        shadowRadius: 10,
        circleColor: context.watch<ThemeCubit>().state == ThemeMode.light ? Colors.white : Colors.black,
        onTabChangedListener: (index) {
          // Navigate to the selected tab
          switch (index) {
            case 0:
              context.go('/home');
              break;

            case 1:
              context.go('/favorites');
              break;
            case 2:
              context.go('/profile');
              break;
          }
        },
        tabs: [
          TabData(icon: const Icon(Icons.home), title: "Home"),
          TabData(icon: const Icon(Icons.favorite), title: "Favorites"),
          TabData(icon: const Icon(Icons.person), title: "Profile"),
        ],
      ),
    );
  }

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouter.of(context).state!.uri.toString();  // Correct way to access the location
    switch (location) {
      case '/home':
        return 0;
      case '/favorites':
        return 1;
      case '/profile':
        return 2;
      default:
        return 0;
    }
  }
}
