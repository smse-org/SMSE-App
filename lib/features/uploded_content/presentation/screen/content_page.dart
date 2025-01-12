
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smse/core/network/api/api_service.dart';
import 'package:smse/features/uploded_content/data/repositories/display_content_repo_imp.dart';
import 'package:smse/features/uploded_content/presentation/controller/cubit/content_cubit.dart';
import 'package:smse/features/uploded_content/presentation/controller/cubit/content_state.dart';
import 'package:smse/features/uploded_content/presentation/screen/content_page.dart';
import 'package:smse/features/uploded_content/presentation/widgets/content_page_mobile.dart';
import 'package:smse/features/uploded_content/presentation/widgets/content_page_web.dart';

class ContentPage extends StatelessWidget {
  const ContentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ContentCubit(DisplayContentRepoImp(ApiService(Dio()))),
      child: BlocListener<ContentCubit, ContentState>(
        listener: (context, state) {
          if (state is ContentError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            BlocProvider.of<ContentCubit>(context).fetchContents();
            if (constraints.maxWidth > 600) {
              return Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: const Text('Contents'),
                ),
                body: const ContentWebPage(),
              );
            } else {
              return Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: const Text('Contents'),
                ),
                body: const ContentMobilePage(),
              );
            }
          },
        ),
      ),
    );
  }
}


