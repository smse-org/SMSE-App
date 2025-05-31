import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smse/core/components/shimmer_loading.dart';
import 'package:smse/core/network/api/api_service.dart';
import 'package:smse/features/favourite/presentation/widgets/favourite_page_mobile.dart';
import 'package:smse/features/favourite/presentation/widgets/favourite_page_web.dart';
import 'package:smse/features/uploded_content/data/repositories/display_content_repo_imp.dart';
import 'package:smse/features/uploded_content/presentation/controller/cubit/content_cubit.dart';
import 'package:smse/features/uploded_content/presentation/controller/cubit/content_state.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late final ContentCubit _contentCubit;

  @override
  void initState() {
    super.initState();
    _contentCubit = ContentCubit(DisplayContentRepoImp(ApiService(Dio())));
    _contentCubit.fetchContents();
  }

  @override
  void dispose() {
    _contentCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _contentCubit,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Favorites', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ),
        body: BlocBuilder<ContentCubit, ContentState>(
          builder: (context, state) {
            if (state is ContentLoading) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 650) {
                    return const FavoritesMobileShimmer();
                  } else {
                    return const FavoritesWebShimmer();
                  }
                },
              );
            } else if (state is ContentLoaded) {
              final taggedContents = state.contents.where((content) => content.contentTag).toList();

              if (taggedContents.isEmpty) {
                return const Center(
                  child: Text(
                    'No favorite content yet',
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }

              return LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 650) {
                    return FavoritesMobile(taggedContents: taggedContents);
                  } else {
                    return FavoritesWeb(taggedContents: taggedContents);
                  }
                },
              );
            } else if (state is ContentError) {
              return Center(
                child: Text(
                  'Error: ${state.message}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}