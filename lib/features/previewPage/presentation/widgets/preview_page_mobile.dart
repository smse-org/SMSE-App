import 'dart:io'; // For handling file paths
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart'; // For downloading files
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smse/constants.dart';
import 'package:smse/features/mainPage/model/content.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smse/features/previewPage/presentation/widgets/file_preview_widget.dart';
import 'package:smse/features/uploded_content/presentation/controller/cubit/content_cubit.dart';
import 'package:smse/features/uploded_content/presentation/controller/cubit/content_state.dart';
import 'dart:typed_data'; // Import for Uint8List

class FilePreviewMobile extends StatefulWidget {
  const FilePreviewMobile({super.key, required this.contentModel, this.thumbnailBytes, this.isLoadingThumbnail = true});
  final ContentModel contentModel;
  final Uint8List? thumbnailBytes;
  final bool isLoadingThumbnail;

  @override
  FilePreviewMobileState createState() => FilePreviewMobileState();
}

class FilePreviewMobileState extends State<FilePreviewMobile> {
  String? downloadedFilePath;

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 56,
          left: 16,
          right: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Future<bool> _checkAndRequestPermissions() async {
    if (!Platform.isAndroid) return true;

    final deviceInfo = await DeviceInfoPlugin().androidInfo;
    final sdkInt = deviceInfo.version.sdkInt;

    // Android 13+ (API 33)
    if (sdkInt >= 33) {
      final mediaPermission = await Permission.photos.status;
      if (mediaPermission.isGranted) return true;

      if (mediaPermission.isPermanentlyDenied) {
        return await _showPermissionDialog();
      }

      final result = await Permission.photos.request();
      return result.isGranted;
    }

    // Android 11-12 (API 30-32)
    if (sdkInt >= 30) {
      final manageStatus = await Permission.manageExternalStorage.status;
      if (manageStatus.isGranted) return true;

      if (manageStatus.isPermanentlyDenied) {
        return await _showPermissionDialog();
      }

      final result = await Permission.manageExternalStorage.request();
      return result.isGranted;
    }

    // Android < 30
    final storageStatus = await Permission.storage.status;
    if (storageStatus.isGranted) return true;

    if (storageStatus.isPermanentlyDenied) {
      return await _showPermissionDialog();
    }

    final result = await Permission.storage.request();
    return result.isGranted;
  }
  Future<bool> _showPermissionDialog() async {
    bool? shouldOpenSettings = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
          'Storage permissions are required to download files.\n'
              'Please enable them in app settings.',
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: const Text('Open Settings'),
            onPressed: () {
              Navigator.of(context).pop(true);
              openAppSettings();
            },
          ),
        ],
      ),
    );

    if (shouldOpenSettings == true) {
      await openAppSettings();
      return false;
    }
    return false;
  }

  Future<void> downloadFile() async {
    bool hasPermission = await _checkAndRequestPermissions();

    if (hasPermission) {
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
    } else {
      _showSnackBar('Storage permission is required to download files', isError: true);
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
          downloadedFilePath = state.filePath;
          _showSnackBar('File downloaded successfully');
        } else if (state is ContentError) {
          _showSnackBar('Error: ${state.message}', isError: true);
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            spacing: 8,
            children: [
              SizedBox(height: 16,),
              FilePreviewWidget(
                contentModel: widget.contentModel,
                width: MediaQuery.of(context).size.width - 32,
                height: 300,
                image: widget.thumbnailBytes,
                isLoading: widget.isLoadingThumbnail,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: shareFile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(Constant.blackColor),
                      side: const BorderSide(color: Colors.white),
                      padding: const EdgeInsets.fromLTRB(60, 15, 60, 15),
                    ),
                    child: const Text("Share", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  BlocBuilder<ContentCubit, ContentState>(
                    builder: (context, state) {
                      bool isDownloading = state is FileDownloading;
                      return ElevatedButton(
                        onPressed: isDownloading ? null : downloadFile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(Constant.whiteColor),
                          side: const BorderSide(color: Colors.black),
                          padding: const EdgeInsets.fromLTRB(60, 15, 60, 15),
                        ),
                        child: Text(
                          isDownloading ? "Downloading..." : "Save",
                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
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
              Padding(
                padding: const EdgeInsets.all(16.0),
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
            ],
          ),
        ),
      ),
    );
  }
}
