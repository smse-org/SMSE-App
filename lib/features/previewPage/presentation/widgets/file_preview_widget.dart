import 'package:flutter/material.dart';
import 'package:smse/features/mainPage/model/content.dart';

class FilePreviewWidget extends StatelessWidget {
  final ContentModel contentModel;
  final double width;
  final double height;

  const FilePreviewWidget({
    super.key,
    required this.contentModel,
    this.width = 600,
    this.height = 400,
  });

  @override
  Widget build(BuildContext context) {
    final extension = contentModel.contentPath.split('.').last.toLowerCase();
    
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[300],
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: _buildPreview(extension),
    );
  }

  Widget _buildPreview(String extension) {
    switch (extension) {
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Image.network(
          contentModel.contentPath,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => _buildFileIcon(Icons.image),
        );
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
        Text(
          contentModel.contentPath.split('/').last,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
} 