import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smse/bloc_observer.dart';
import 'package:smse/core/routes/app_router.dart';
import 'package:smse/core/utililes/cached_sp.dart';
import 'package:smse/features/home/presentation/controller/theme_cubit/theme_cubit.dart';
import 'package:smse/core/services/notification_service.dart';
import 'package:smse/core/network/api/api_service.dart';
import 'package:smse/features/profile/data/repositories/preferences_repository_impl.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:smse/features/mainPage/controller/file_cubit.dart';
import 'package:smse/features/mainPage/repo/file_upload_repo_imp.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(PreferencesRepositoryImpl(ApiService(Dio()))),
        ),
        BlocProvider<FileUploadCubit>(
          create: (context) => FileUploadCubit(
            FileUploadRepoImp(
              ApiService(Dio()),
            ),
          ),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            routerConfig: AppRouter.router,
            debugShowCheckedModeBanner: false,
            title: 'SMSE APP',
            theme: ThemeData.light().copyWith(
              scaffoldBackgroundColor: Colors.white,
              colorScheme: ColorScheme.light(
                primary: Colors.blue,
                secondary: Colors.blueAccent,
                surface: Colors.white,
                background: Colors.white,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
            ),
            darkTheme: ThemeData.dark().copyWith(
              scaffoldBackgroundColor: Colors.black,
              colorScheme: ColorScheme.dark(
                primary: Colors.blue,
                secondary: Colors.blueAccent,
                surface: Colors.grey[900]!,
                background: Colors.black,
                onPrimary: Colors.white,
                onSurface: Colors.white,
              ),
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.grey[900],
                foregroundColor: Colors.white,
              ),
            ),
            themeMode: themeMode,
          );
        },
      ),
    );
  }
}
