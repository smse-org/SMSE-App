import 'package:flutter/material.dart';
import 'package:smse/features/mainPage/model/content.dart';
import 'dart:typed_data'; // Import for Uint8List
import 'package:smse/core/components/shimmer_loading.dart';

class FilePreviewWidget extends StatelessWidget {
  final ContentModel contentModel;
  final double width;
  final double height;
  final Uint8List? image; // Make image nullable
  final bool isLoading;

  const FilePreviewWidget({
    super.key,
    required this.contentModel,
    this.width = 600,
    this.height = 400,
    this.image, // Make image nullable
    this.isLoading = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[300],
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: isLoading
          ?  Center(child: ShimmerLoading(child: ShimmerCard(width: 600, height: 400))) // Show shimmer while loading
          : _buildPreview(image, contentModel.contentPath.split('.').last.toLowerCase()), // Pass image and extension
    );
  }

  Widget _buildPreview(Uint8List? imageBytes, String fileExtension) {
    if (imageBytes != null) {
      // Display image if bytes are provided
      return Image.memory(
        imageBytes,
        width: width, // Use widget width/height
        height: height,
        fit: BoxFit.contain, // Use contain to show the whole image
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.image_not_supported, size: 64);
        },
      );
    } else {
      // Fallback to icon based on file extension
      switch (fileExtension) {
        case 'pdf':
          return _buildFileIcon(Icons.picture_as_pdf, color: Colors.red);
        case 'doc':
        case 'docx':
          return _buildFileIcon(Icons.description, color: Colors.blue);
        case 'xls':
        case 'xlsx':
          return _buildFileIcon(Icons.table_chart, color: Colors.green);
        case 'ppt':
        case 'pptx':
          return _buildFileIcon(Icons.slideshow, color: Colors.orange);
        case 'txt':
          return _buildFileIcon(Icons.text_snippet, color: Colors.grey);
        case 'zip':
        case 'rar':
          return _buildFileIcon(Icons.archive, color: Colors.purple);
        default:
          return _buildFileIcon(Icons.insert_drive_file);
      }
    }
  }

  Widget _buildFileIcon(IconData icon, {Color? color}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 64,
          color: color ?? Colors.grey[700],
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            contentModel.contentPath.split('/').last,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis, // Prevent overflow
            maxLines: 2, // Allow up to 2 lines
          ),
        ),
      ],
    );
  }
} 