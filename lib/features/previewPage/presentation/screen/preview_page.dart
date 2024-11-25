import 'package:flutter/material.dart';
import 'package:smse/features/previewPage/presentation/widgets/preview_page_mobile.dart';
import 'package:smse/features/previewPage/presentation/widgets/preview_page_web.dart';
class FileViewerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('File Viewer', style: TextStyle(fontSize: 24 , fontWeight: FontWeight.bold),),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Switch layout based on screen width
          if (constraints.maxWidth < 650) {
            // Web/Desktop Design
            return const SafeArea(child: FilePreviewMobile());
          } else {
            // Mobile Design
            return const FilePreviewWeb();
          }
        },
      ),
    );
  }
}