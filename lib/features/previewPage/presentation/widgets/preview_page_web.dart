import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smse/constants.dart';
import 'package:smse/features/mainPage/model/content.dart';
import 'package:smse/features/previewPage/presentation/widgets/file_preview_widget.dart';
import 'package:smse/features/uploded_content/presentation/controller/cubit/content_cubit.dart';
import 'package:smse/features/uploded_content/presentation/controller/cubit/content_state.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'dart:typed_data'; // Import for Uint8List

class FilePreviewWeb extends StatefulWidget {
  const FilePreviewWeb({super.key, required this.contentModel, this.thumbnailBytes, this.isLoadingThumbnail = true});
  final ContentModel contentModel;
  final Uint8List? thumbnailBytes;
  final bool isLoadingThumbnail;

  @override
  State<FilePreviewWeb> createState() => _FilePreviewWebState();
}

class _FilePreviewWebState extends State<FilePreviewWeb> {
  String? downloadedFilePath;

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Future<void> downloadFile() async {
    try {
      // Get the file path from content model
      String filePath = widget.contentModel.contentPath;
      
      // Get the content ID
      int? contentId = widget.contentModel.id;

      if (contentId == null) {
        _showSnackBar('Invalid content ID', isError: true);
        return;
      }

      // Trigger download through cubit with full file path
      context.read<ContentCubit>().downloadFile(contentId, filePath);
    } catch (e) {
      _showSnackBar('Error preparing download: $e', isError: true);
    }
  }

  Future<void> shareFile() async {
    if (downloadedFilePath != null && File(downloadedFilePath!).existsSync()) {
      await Share.shareXFiles(
        [XFile(downloadedFilePath!)],
        text: 'Check out this file: ${widget.contentModel.contentPath.split('/').last}',
      );
    } else {
      _showSnackBar('Please download the file first before sharing', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ContentCubit, ContentState>(
      listener: (context, state) {
        if (state is FileDownloaded) {
          setState(() {
            downloadedFilePath = state.filePath;
          });
          _showSnackBar('File downloaded successfully');
        } else if (state is ContentError) {
          _showSnackBar('Error: ${state.message}', isError: true);
        }
      },
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FilePreviewWidget(
                    contentModel: widget.contentModel,
                    width: 600,
                    height: 400,
                    image: widget.thumbnailBytes,
                    isLoading: widget.isLoadingThumbnail,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    width: 600,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "File Details",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text("Name: ${widget.contentModel.contentPath.split('/').last}"),
                        Text("Size: ${widget.contentModel.contentSize} bytes"),
                        Text("Upload Date: ${widget.contentModel.uploadDate.toString().split('.')[0]}"),
                        Text("Status: ${widget.contentModel.contentTag ? "Tagged" : "Not Tagged"}"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 60,
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: shareFile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(Constant.greenColor),
                          side: const BorderSide(color: Colors.white),
                          padding: const EdgeInsets.fromLTRB(60, 15, 60, 15),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.share, color: Colors.white),
                            SizedBox(width: 10),
                            Text("Share", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      BlocBuilder<ContentCubit, ContentState>(
                        builder: (context, state) {
                          bool isDownloading = state is FileDownloading;
                          return ElevatedButton(
                            onPressed: isDownloading ? null : downloadFile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(Constant.blueColor),
                              side: const BorderSide(color: Colors.white),
                              padding: const EdgeInsets.fromLTRB(60, 15, 60, 15),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(isDownloading ? Icons.downloading : Icons.download, color: Colors.white),
                                const SizedBox(width: 10),
                                Text(
                                  isDownloading ? "Downloading..." : "Download",
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  BlocBuilder<ContentCubit, ContentState>(
                    builder: (context, state) {
                      if (state is FileDownloading) {
                        return Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(16),
                          width: 600,
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              LinearProgressIndicator(value: state.progress / 100),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Downloading: ${state.progress.toStringAsFixed(0)}%',
                                  style: const TextStyle(fontSize: 16)
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}