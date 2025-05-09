import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smse/bloc_observer.dart';
import 'package:smse/core/routes/app_router.dart';
import 'package:smse/core/utililes/cached_sp.dart';
import 'package:smse/features/home/presentation/controller/theme_cubit/theme_cubit.dart';
import 'package:smse/core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize SharedPreferences first
  await CachedData.cachInit();
  
  // Initialize notification service
  await NotificationService().initialize();
  
  // Set up Bloc observer
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
