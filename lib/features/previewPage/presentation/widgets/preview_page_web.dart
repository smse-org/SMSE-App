import 'package:flutter/material.dart';
import 'package:smse/constants.dart';
import 'package:smse/features/mainPage/model/content.dart';
import 'package:smse/features/previewPage/presentation/widgets/file_preview_widget.dart';

class FilePreviewWeb extends StatelessWidget {
  const FilePreviewWeb({super.key, required this.contentModel});
  final ContentModel contentModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilePreviewWidget(
              contentModel: contentModel,
              width: 600,
              height: 400,
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
                  Text("Name: ${contentModel.contentPath.split('/').last}"),
                  Text("Size: ${contentModel.contentSize} bytes"),
                  Text("Upload Date: ${contentModel.uploadDate.toString().split('.')[0]}"),
                  Text("Status: ${contentModel.contentTag ? "Tagged" : "Not Tagged"}"),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(Constant.blueColor),
                    side: const BorderSide(color: Colors.white),
                    padding: const EdgeInsets.fromLTRB(60, 15, 60, 15),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.download, color: Colors.white),
                      SizedBox(width: 10),
                      Text("Download", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(width: 60),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(Constant.greenColor),
                    side: const BorderSide(color: Colors.white),
                    padding: const EdgeInsets.fromLTRB(60, 15, 60, 15),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.share, color: Colors.white),
                      SizedBox(width: 10),
                      Text("Share", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}