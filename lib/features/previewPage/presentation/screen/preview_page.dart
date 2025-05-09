import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smse/core/network/api/api_service.dart';
import 'package:smse/features/mainPage/model/content.dart';
import 'package:smse/features/previewPage/presentation/widgets/preview_page_mobile.dart';
import 'package:smse/features/previewPage/presentation/widgets/preview_page_web.dart';
import 'package:smse/features/uploded_content/data/repositories/display_content_repo_imp.dart';
import 'package:smse/features/uploded_content/presentation/controller/cubit/content_cubit.dart';
import 'package:smse/features/uploded_content/presentation/controller/cubit/content_state.dart';

class FileViewerPage extends StatelessWidget {
  const FileViewerPage({super.key, required this.contentModel});
  final ContentModel contentModel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ContentCubit(DisplayContentRepoImp(ApiService(Dio()))),
      child: BlocListener<ContentCubit, ContentState>(
        listener: (context, state) {
          if (state is ContentError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is ContentTagging) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Updating tag status...'),
                backgroundColor: Colors.blue,
              ),
            );
          } else if (state is ContentTagged) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Tag status updated successfully'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('File Viewer',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            actions: [
              BlocBuilder<ContentCubit, ContentState>(
                builder: (context, state) {
                  return IconButton(
                    icon: Icon(
                      contentModel.contentTag
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: contentModel.contentTag ? Colors.red : null,
                    ),
                    onPressed: () {
                      context.read<ContentCubit>().toggleContentTag(
                        contentModel.id ?? 0,
                        !contentModel.contentTag,
                      );
                    },
                  );
                },
              ),
            ],
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              // Switch layout based on screen width
              if (constraints.maxWidth < 650) {
                // Mobile Design
                return SafeArea(
                    child: FilePreviewMobile(contentModel: contentModel));
              } else {
                // Web/Desktop Design
                return FilePreviewWeb(contentModel: contentModel);
              }
            },
          ),
        ),
      ),
    );
  }
}
