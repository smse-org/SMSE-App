import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smse/features/auth/login/presentation/screen/login.dart';
import 'package:smse/features/auth/signup/presentation/screen/signup_page.dart';
import 'package:smse/features/favourite/presentation/screen/favourite_page.dart';
import 'package:smse/features/home/presentation/screen/homapage.dart';
import 'package:smse/features/mainPage/responsive_page.dart';
import 'package:smse/features/mainPage/widget/search_animation_page.dart';
import 'package:smse/features/profile/presentation/screen/profile_page.dart';
import 'package:smse/features/search/data/model/search_results.dart';
import 'package:smse/features/search/presentation/screen/search_page.dart';
import 'package:smse/features/splash/splash_view.dart';
import 'package:smse/features/uploded_content/presentation/screen/content_page.dart';

abstract class AppRouter {
  static const String home = '/home';
  static const String search = '/search';
  static const String favorites = '/favorites';
  static const String profile = '/profile';
  static const String login = '/login';
  static const String signUp = '/signup';
  static const String searchAnimation = '/search-animation';
  static const String contentPage = "/content";
  static late final Function toggleTheme; // Declare toggleTheme as a late variable

  static final router = GoRouter(
    initialLocation: login, // Default route
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: login,
        builder: (context, state) => const ResponsiveLoginPage(),
      ),
      GoRoute(
        path: signUp,
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: searchAnimation,
        builder: (context, state) => const SearchAnimationPage(),
      ),
      ShellRoute(
        navigatorKey: GlobalKey<NavigatorState>(), // For nested navigation
        builder: (context, state, child) {
          return ResponsiveHome(
            toggleTheme: () {
              toggleTheme(); // Call the toggleTheme function
            },
            themeMode: ThemeMode.light,
            child: child, // Pass the routed child to the layout
          );
        },
        routes: [
          GoRoute(
            path: home,
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: search,
            builder: (context, state) {
              final searchResults = state.extra as List<SearchResult>?;
              return SearchPage(searchResults: searchResults);
            },
          ),
          GoRoute(
            path: favorites,
            builder: (context, state) => const FavoritesPage(),
          ),
          GoRoute(
            path: profile,
            builder: (context, state) => ProfilePage(),
          ),
          GoRoute(
            path: contentPage,
            builder: (context, state) => const ContentPage(),
          ),
        ],
      ),
    ],
  );

  static void initialize(Function toggleThemeCallback) {
    toggleTheme = toggleThemeCallback;
  }
}

