import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:smse/core/network/api/api_service.dart';
import 'package:smse/features/mainPage/model/content.dart';
import 'package:smse/features/previewPage/presentation/screen/preview_page.dart';
import 'package:smse/features/previewPage/presentation/widgets/preview_page_web.dart';
import 'package:smse/features/uploded_content/data/repositories/display_content_repo_imp.dart';
import 'package:smse/features/uploded_content/presentation/controller/cubit/content_cubit.dart';
import 'package:smse/features/uploded_content/presentation/controller/cubit/content_state.dart';

class ContentPage extends StatefulWidget {
  const ContentPage({super.key});

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
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

  Future<void> _pickAndUploadFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['txt', 'jpg', 'wav', 'jpeg'],
      );

      if (result != null) {
        List<String> filePaths = result.paths.whereType<String>().toList();
        if (filePaths.isNotEmpty) {
          await _contentCubit.uploadFiles(filePaths);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking files: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _contentCubit,
      child: BlocListener<ContentCubit, ContentState>(
        listener: (context, state) {
          if (state is ContentError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          } else if (state is ContentUploaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Files uploaded successfully')),
            );
            _contentCubit.fetchContents();
          }
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              return Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: const Text('Contents'),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.upload_file),
                      onPressed: _pickAndUploadFiles,
                    ),
                  ],
                ),
                body: const ContentWebPage(),
              );
            } else {
              return Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: const Text('Contents'),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.upload_file),
                      onPressed: _pickAndUploadFiles,
                    ),
                  ],
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

class ContentMobilePage extends StatelessWidget {
  const ContentMobilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContentCubit, ContentState>(
      builder: (context, state) {
        if (state is ContentLoading) {
          return const Center(child: SpinKitCubeGrid(color: Colors.black,));
        } else if (state is ContentError) {
          return Center(child: Text(state.message));
        } else if (state is ContentLoaded) {
          return ListView.builder(
            itemCount: state.contents.length,
            itemBuilder: (context, index) {
              final content = state.contents[index];
              return
                  Card(
                    child: ListTile(
                      title: Text(content.contentPath.split('/').last),
                      subtitle: Text(content.contentTag ? "Tagged" : "Not Tagged"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  FileViewerPage(contentModel:  content,),
                          ),
                        );
                      },
                      trailing:  buildActionsMobile(context, content)
                    ),
                  );

            },
          );
        }
        return const Center(child: Text('No contents available.'));
      },
    );
  }

  Widget buildActionsMobile(BuildContext context, ContentModel content) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.download),
          onPressed: () {
            context.read<ContentCubit>().downloadFile(content.id ?? 0,content.contentPath);
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            context.read<ContentCubit>().deleteContent(content.id ?? 0);
          },
        ),
      ],
    );
  }
}

class ContentWebPage extends StatelessWidget {
  const ContentWebPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContentCubit, ContentState>(
      builder: (context, state) {
        if (state is ContentLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ContentError) {
          return Center(child: Text(state.message));
        } else if (state is ContentLoaded) {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
            ),
            padding: const EdgeInsets.all(16.0),
            itemCount: state.contents.length,
            itemBuilder: (context, index) {
              final content = state.contents[index];
              return Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        content.contentPath.split('/').last,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(content.contentTag ? "Tagged" : "Not Tagged"),
                      const Spacer(),
                      buildActions(context, content),
                    ],
                  ),
                ),
              );
            },
          );
        }
        return const Center(child: Text('No contents available.'));
      },
    );
  }

  Widget buildActions(BuildContext context, ContentModel content) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.download),
          onPressed: () {
           DownloadProgressWidget(contentId: content.id??0,contentPath: content.contentPath,);
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            context.read<ContentCubit>().deleteContent(content.id ?? 0);
          },
        ),
      ],
    );
  }
}

class DownloadProgressWidget extends StatelessWidget {
  final int contentId;
  final String contentPath;

  const DownloadProgressWidget({super.key, required this.contentId, required this.contentPath});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContentCubit, ContentState>(
      builder: (context, state) {
        if (state is FileDownloading) {
          return Column(
            children: [
              const Text("Downloading..."),
              LinearProgressIndicator(value: state.progress / 100),
            ],
          );
        } else if (state is FileDownloaded) {
          return const Icon(Icons.check_circle, color: Colors.green);
        } else {
          return IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              context.read<ContentCubit>().downloadFile(contentId,contentPath);
            },
          );
        }
      },
    );
  }
}


