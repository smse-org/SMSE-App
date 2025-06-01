import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smse/features/mainPage/web.dart';
import 'package:smse/features/mainPage/mobile.dart';
import 'package:smse/features/mainPage/controller/file_cubit.dart';
import 'package:smse/features/mainPage/repo/file_upload_repo_imp.dart';
import 'package:smse/core/network/api/api_service.dart';
import 'package:dio/dio.dart';
import 'package:smse/features/home/presentation/controller/theme_cubit/theme_cubit.dart';
import 'package:smse/features/profile/data/repositories/preferences_repository_impl.dart';

class ResponsiveHome extends StatelessWidget {
  final Widget child;

  const ResponsiveHome({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
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
          return LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                return WebLayout();
              } else {
                return MobileLayout(
                  themeMode: themeMode,
                  child: child,
                );
              }
            },
          );
        },
      ),
    );
  }
}
