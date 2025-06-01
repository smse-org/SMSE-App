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
import 'dart:convert';
import 'dart:typed_data';
import 'package:smse/core/components/shimmer_loading.dart';

class FileViewerPage extends StatelessWidget {
  const FileViewerPage({super.key, required this.contentModel});
  final ContentModel contentModel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ContentCubit(DisplayContentRepoImp(ApiService(Dio()))),
      child: Builder(
        builder: (context) {
          return BlocListener<ContentCubit, ContentState>(
            listener: (context, state) {
              if (state is ContentError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.redAccent,
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
              body: FutureBuilder<String>(
                future: context.read<ContentCubit>().getThumbnail(contentModel.id!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: ShimmerLoading(child: ShimmerCard(width: double.infinity, height: double.infinity))); // Show shimmer while loading
                  } else if (snapshot.hasError) {
                    print('Error fetching thumbnail in FileViewerPage: ${snapshot.error}');
                    // Pass null thumbnailBytes and isLoadingThumbnail = false on error
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth < 650) {
                          return SafeArea(
                            child: FilePreviewMobile(
                                contentModel: contentModel, thumbnailBytes: null, isLoadingThumbnail: false),
                          );
                        } else {
                          return FilePreviewWeb(
                              contentModel: contentModel, thumbnailBytes: null, isLoadingThumbnail: false);
                        }
                      },
                    );
                  } else if (snapshot.hasData && snapshot.data != null) {
                    try {
                      final Uint8List bytes = base64Decode(snapshot.data!.split(',').last);
                      // Pass fetched thumbnailBytes and isLoadingThumbnail = false on success
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth < 650) {
                            return SafeArea(
                              child: FilePreviewMobile(
                                  contentModel: contentModel, thumbnailBytes: bytes, isLoadingThumbnail: false),
                            );
                          } else {
                            return FilePreviewWeb(
                                contentModel: contentModel, thumbnailBytes: bytes, isLoadingThumbnail: false);
                          }
                        },
                      );
                    } catch (e) {
                      print('Error decoding base64 in FileViewerPage: $e');
                       // Pass null thumbnailBytes and isLoadingThumbnail = false on decoding error
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth < 650) {
                            return SafeArea(
                              child: FilePreviewMobile(
                                  contentModel: contentModel, thumbnailBytes: null, isLoadingThumbnail: false),
                            );
                          } else {
                            return FilePreviewWeb(
                                contentModel: contentModel, thumbnailBytes: null, isLoadingThumbnail: false);
                          }
                        },
                      );
                    }
                  } else {
                     // Pass null thumbnailBytes and isLoadingThumbnail = false if no data
                     return LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth < 650) {
                            return SafeArea(
                              child: FilePreviewMobile(
                                  contentModel: contentModel, thumbnailBytes: null, isLoadingThumbnail: false),
                            );
                          } else {
                            return FilePreviewWeb(
                                contentModel: contentModel, thumbnailBytes: null, isLoadingThumbnail: false);
                          }
                        },
                      );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
