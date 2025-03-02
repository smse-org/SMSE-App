import 'dart:io'; // For handling file paths
import 'package:dio/dio.dart'; // For downloading files
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smse/constants.dart';
import 'package:path_provider/path_provider.dart';


class FilePreviewMobile extends StatefulWidget {
  const FilePreviewMobile({super.key});

  @override
  FilePreviewMobileState createState() => FilePreviewMobileState();
}

class FilePreviewMobileState extends State<FilePreviewMobile> {
  double downloadProgress = 0;
  bool isDownloading = false;
  String downloadMessage = '';

  // Simulating file download

  Future<void> downloadFile() async {
    // Request permissions
    PermissionStatus status = await Permission.storage.request();

    if (status.isGranted) {
      setState(() {
        isDownloading = true;
        downloadMessage = 'Starting download...';
      });

      try {
        Dio dio = Dio();

        // Replace with actual file URL to download
        String fileUrl = 'https://www.tutorialspoint.com/flutter/flutter_tutorial.pdf';
        // Use path_provider to get the correct path
        Directory? directory = await getExternalStorageDirectory();
        String savePath = '${directory?.path}/flutter.pdf'; // Safe path

        await dio.download(
          fileUrl,
          savePath,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              setState(() {
                downloadProgress = (received / total) * 100;
                downloadMessage = 'Downloading: ${downloadProgress.toStringAsFixed(0)}%';
              });
            }
          },
        );

        setState(() {
          downloadMessage = 'Download complete!';
        });
      } catch (e) {
        setState(() {
          downloadMessage = 'Download failed: $e';
        });
      } finally {
        setState(() {
          isDownloading = false;
        });
      }
    } else {
      setState(() {
        downloadMessage = 'Permission denied!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 300,
            margin: const EdgeInsets.symmetric(vertical: 24.0 , horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[300],
              border: Border.all(color: Colors.grey[800]!),
            ),
            alignment: Alignment.center,
            child: const Text(
              "File Preview",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: const Color(Constant.blackColor),
                  side: const BorderSide(color: Colors.white),
                  padding: const EdgeInsets.fromLTRB(60, 15, 60, 15),
                ),
                child: const Text("Share", style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold)),
              ),
              ElevatedButton(
                onPressed: isDownloading ? null : downloadFile, // Disable button if downloading
                style: ElevatedButton.styleFrom(backgroundColor: const Color(Constant.whiteColor),
                  side: const BorderSide(color: Colors.black),
                  padding: const EdgeInsets.fromLTRB(60, 15, 60, 15),
                ),
                child: const Text("Save", style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          if (isDownloading)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  LinearProgressIndicator(value: downloadProgress / 100),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(downloadMessage, style: const TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "File details and any relevant metadata can be displayed here.",
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
