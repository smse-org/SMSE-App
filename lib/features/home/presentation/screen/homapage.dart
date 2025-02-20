import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smse/core/network/api/api_service.dart';
import 'package:smse/features/home/presentation/screen/home_page_content.dart';
import 'package:smse/features/search/data/repositories/search_repo_imp.dart';
import 'package:smse/features/search/presentation/controller/search_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(
        SearchRepositoryImpl(ApiService(Dio())),
      ),
      child: HomePageContent(),
    );
  }
}
