import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smse/core/network/api/api_service.dart';
import 'package:smse/core/routes/app_router.dart';
import 'package:smse/features/search/data/model/search_results.dart';
import 'package:smse/features/search/data/repositories/search_repo_imp.dart';
import 'package:smse/features/search/presentation/controller/search_cubit.dart';
import 'package:smse/features/search/presentation/controller/search_state.dart';
import 'package:smse/features/search/presentation/widgets/mobile_search_page.dart';
import 'package:smse/features/search/presentation/widgets/search_page_web.dart';
import 'package:smse/features/uploded_content/presentation/controller/cubit/content_cubit.dart';
import 'package:smse/features/uploded_content/data/repositories/display_content_repo_imp.dart';

class SearchPage extends StatelessWidget {
  final List<SearchResult>? searchResults;

  const SearchPage({super.key, this.searchResults});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SearchCubit>(
          create: (context) => SearchCubit(SearchRepositoryImpl(ApiService(Dio())))
            ..emit(SearchSucsess(searchResults ?? [])),
        ),
        BlocProvider<ContentCubit>(
          create: (context) => ContentCubit(DisplayContentRepoImp(ApiService(Dio()))),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title: const Text(
            'Search Results',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              return const SafeArea(child: MobileSearchView());
            } else if (constraints.maxWidth < 800) {
              return const WebSearchView(number: 2);
            } else {
              return const WebSearchView(number: 3);
            }
          },
        ),
      ),
    );
  }
}
