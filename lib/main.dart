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
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit()..loadTheme(), // Initialize ThemeCubit and load theme preference
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            routerConfig: AppRouter.router,
            debugShowCheckedModeBanner: false,
            title: 'Responsive Navigation with Theme Switching',
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: themeMode, // Apply the selected theme mode
          );
        },
      ),
    );
  }
}
