import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:fancy_bottom_navigation_plus/fancy_bottom_navigation_plus.dart';
import 'package:smse/core/routes/app_router.dart';
import 'package:smse/features/home/presentation/controller/theme_cubit/theme_cubit.dart';

class MobileLayout extends StatefulWidget {
  final Widget child; // Render the current page
  final ThemeMode themeMode;

  const MobileLayout({
    required this.child,
    required this.themeMode,
    super.key,
  });

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  @override
  void initState() {
    super.initState();
    // Load theme from preferences when the layout is initialized
    context.read<ThemeCubit>().loadThemeFromPreferences();
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => GoRouter.of(context).push(AppRouter.searchAnimation),
        backgroundColor: widget.themeMode == ThemeMode.light ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
        child: Icon(Icons.add, color: widget.themeMode == ThemeMode.light ? Colors.black : Colors.white),
      ),
      appBar: AppBar(
        title: const Text("SMSE", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        actions: [
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return IconButton(
                icon: Icon(themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode),
                onPressed: () => context.read<ThemeCubit>().toggleTheme(),
              );
            },
          ),
        ],
      ),
      body: widget.child,
      bottomNavigationBar: FancyBottomNavigationPlus(
        initialSelection: currentIndex,
        shadowRadius: 10,
        circleColor: context.watch<ThemeCubit>().state == ThemeMode.light ? Colors.white : Colors.black,
        onTabChangedListener: (index) {
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
        titleStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: context.watch<ThemeCubit>().state == ThemeMode.light ? Colors.black : Colors.white,
        ),
        tabs: [
          TabData(icon: const Icon(Icons.home), title: "Home"),
          TabData(icon: const Icon(Icons.favorite), title: "Favorites"),
          TabData(icon: const Icon(Icons.person), title: "Profile"),
        ],
      ),
    );
  }

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouter.of(context).state!.uri.toString();
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
