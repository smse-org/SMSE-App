import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smse/features/mainPage/model/content.dart';
class ContentDetailPage extends StatelessWidget {
  final ContentModel content;

  const ContentDetailPage({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final extension = content.content_path.split('.').last.toLowerCase();

    return Scaffold(
      appBar: AppBar(
        title: Text(content.content_path.split('/').last),
      ),
      body: Center(
        child: _buildContentDetail(extension, content.content_path),
      ),
    );
  }

  Widget _buildContentDetail(String extension, String filePath) {
    if (['jpeg', 'jpg', 'png', 'gif'].contains(extension)) {
      return _loadLocalImage(filePath); // Image loading logic
    } else if (extension == 'pdf') {
      return _buildPDFViewer(filePath); // PDF handling
    } else {
      return const Center(child: Text("Unsupported Content"));
    }
  }

  // Use FutureBuilder to load local image asynchronously
  Widget _loadLocalImage(String filePath) {
    return FutureBuilder<Widget>(
      future: _getLocalImage(filePath), // Load image asynchronously
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Loading indicator
        } else if (snapshot.hasError) {
          return const Icon(Icons.broken_image, size: 100); // Error state
        } else if (snapshot.hasData) {
          return snapshot.data!; // Return the image once loaded
        } else {
          return const Icon(Icons.broken_image, size: 100); // Default state
        }
      },
    );
  }

  // Asynchronous method to load local image
  Future<Widget> _getLocalImage(String filePath) async {
    final appDocDir = await getTemporaryDirectory(); // Get the temp directory
    final fullPath = '${appDocDir.path}$filePath'; // Construct the full file path

    if (await File(fullPath).exists()) {
      return Image.file(
        File(fullPath),
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 100),
      );
    } else {
      return const Icon(Icons.broken_image, size: 100); // If the file doesn't exist
    }
  }

  Widget _buildPDFViewer(String filePath) {
    // PDF viewer logic here (e.g., using a package like flutter_pdfview)
    return const Icon(Icons.picture_as_pdf, color: Colors.red, size: 100);
  }
}
