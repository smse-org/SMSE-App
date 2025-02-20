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
  static const String KHome = '/home';
  static const String KSearch = '/search';
  static const String KFavorites = '/favorites';
  static const String KProfile = '/profile';
  static const String KLogin = '/login';
  static const String KSignUp = '/signup';
  static const String KSearchAnimation = '/search-animation';
  static const String kContetnPage ="/content";
  static late final Function toggleTheme; // Declare toggleTheme as a late variable

  static final router = GoRouter(
    initialLocation: KLogin, // Default route
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: KLogin,
        builder: (context, state) => ResponsiveLoginPage(),
      ),
      GoRoute(
        path: KSignUp,
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: KSearchAnimation,
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
            path: KHome,
            builder: (context, state) =>  const HomePage(),
          ),
          GoRoute(
            path: KSearch,
            builder: (context, state){
              final searchResults = state.extra as List<SearchResult>?;
              return SearchPage(searchResults: searchResults);
            },
          ),
          GoRoute(
            path: KFavorites,
            builder: (context, state) => const FavoritesPage(),
          ),
          GoRoute(
            path: KProfile,
            builder: (context, state) =>  ProfilePage(),
          ),


          GoRoute(
            path: kContetnPage,
            builder: (context, state) =>  const ContentPage(),
          ),
        ],
      ),
    ],
  );

  static void initialize(Function toggleThemeCallback) {
    toggleTheme = toggleThemeCallback;
  }
}

