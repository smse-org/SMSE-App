import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smse/core/network/api/api_service.dart';
import 'package:smse/features/home/presentation/controller/theme_cubit/theme_cubit.dart';
import 'package:smse/features/profile/data/repositories/preferences_repository_impl.dart';

class App extends StatelessWidget {
  final Widget child;

  const App({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeCubit(
            PreferencesRepositoryImpl(ApiService(Dio())),
          ),
        ),
      ],
      child: child,
    );
  }
} 