import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smse/core/components/shimmer_loading.dart';
import 'package:smse/features/mainPage/model/content.dart';
import 'package:smse/features/previewPage/presentation/screen/preview_page.dart';
import 'package:smse/features/uploded_content/presentation/controller/cubit/content_cubit.dart';
import 'dart:convert'; // Import for base64Decode
import 'dart:typed_data'; // Import for Uint8List

class FavoritesWeb extends StatelessWidget {
  const FavoritesWeb({super.key, required this.taggedContents});

  final List<ContentModel> taggedContents;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2, // Adjust childAspectRatio as needed after visual check
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: taggedContents.length,
          itemBuilder: (context, index) {
            final content = taggedContents[index];
            return Card(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FileViewerPage(contentModel: content),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Use a helper widget for consistent image/icon display
                          SizedBox(
                            width: 100, // Give a fixed width to the thumbnail/icon area
                            child: _buildThumbnailOrIcon(context, content),
                          ),
                          const SizedBox(width: 7),
                          const Icon(Icons.favorite, color: Colors.red), // Favorite icon
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              content.contentPath.split('/').last,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Size: ${content.contentSize} bytes',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Upload Date: ${content.uploadDate.toString().split('.')[0]}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildThumbnailOrIcon(BuildContext context, ContentModel content) {
    // Check file extension and display icon if not an image type
    if (content.contentPath.toLowerCase().endsWith('.wav') ||
        content.contentPath.toLowerCase().endsWith('.txt') ||
        content.contentPath.toLowerCase().endsWith('.md')) {
      return const AspectRatio(
        aspectRatio: 16 / 9, // Maintain consistent aspect ratio
        child: Center(
          child: Icon(
            Icons.insert_drive_file, // Default file icon
            size: 64,
            color: Colors.grey,
          ),
        ),
      );
    } else {
      // Otherwise, fetch and display thumbnail
      return FutureBuilder<String>(
        future: context.read<ContentCubit>().getThumbnail(content.id!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const AspectRatio(
              aspectRatio: 16 / 9, // Maintain consistent aspect ratio
              child: ShimmerLoading(child: ShimmerCard(width: double.infinity, height: double.infinity)), // Use ShimmerRectangle with full width/height
            );
          }
          if (snapshot.hasData && snapshot.data != null) {
            try {
              final Uint8List bytes = base64Decode(snapshot.data!.split(',').last);
              return AspectRatio(
                 aspectRatio: 16 / 9, // Maintain consistent aspect ratio
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(
                    bytes,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(child: Icon(Icons.image_not_supported, size: 64)); // Consistent icon size
                    },
                  ),
                ),
              );
            } catch (e) {
              print('Error decoding base64: $e');
              return const AspectRatio(
                 aspectRatio: 16 / 9, // Maintain consistent aspect ratio
                child: Center(child: Icon(Icons.error, size: 64)), // Consistent icon size
              );
            }
          }
          return const AspectRatio(
             aspectRatio: 16 / 9, // Maintain consistent aspect ratio
            child: Center(child: Icon(Icons.image_not_supported, size: 64)), // Consistent icon size
          );
        },
      );
    }
  }
}

class FavoritesWebShimmer extends StatelessWidget {
  const FavoritesWebShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            return ShimmerLoading(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const ShimmerCircle(size: 24),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const ShimmerText(width: 200, height: 20),
                                const SizedBox(height: 8),
                                const ShimmerText(width: 150, height: 16),
                                const SizedBox(height: 4),
                                const ShimmerText(width: 180, height: 16),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}