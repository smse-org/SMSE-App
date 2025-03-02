import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smse/bloc_observer.dart';
import 'package:smse/core/routes/app_router.dart';
import 'package:smse/core/utililes/cachedSP.dart';
import 'package:smse/features/home/presentation/controller/theme_cubit/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CachedData.cachInit(); // Ensure SharedPreferences is initialized
  Bloc.observer = Observe();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit()..loadTheme(), // Load theme on app start
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            routerConfig: AppRouter.router,
            debugShowCheckedModeBanner: false,
            title: 'SMSE APP',
            theme: ThemeData.light().copyWith(
              scaffoldBackgroundColor: Colors.white,
            ),
            darkTheme: ThemeData.dark().copyWith(
              scaffoldBackgroundColor: Colors.black, // Custom dark mode background
            ),
            themeMode: themeMode, // Apply user-selected theme mode
          );
        },
      ),
    );
  }
}
