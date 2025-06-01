import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smse/core/components/shimmer_loading.dart';
import 'package:smse/features/mainPage/model/content.dart';
import 'package:smse/features/previewPage/presentation/screen/preview_page.dart';
import 'package:smse/features/uploded_content/presentation/controller/cubit/content_cubit.dart';
import 'dart:convert'; // Import for base64Decode
import 'dart:typed_data'; // Import for Uint8List

class FavoritesMobile extends StatelessWidget {
  const FavoritesMobile({super.key, required this.taggedContents});

  final List<ContentModel> taggedContents;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: taggedContents.length,
      itemBuilder: (context, index) {
        final content = taggedContents[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FileViewerPage(contentModel: content),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder<String>(
                  future: context.read<ContentCubit>().getThumbnail(content.id!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const AspectRatio(
                        aspectRatio: 16 / 9,
                        child: ShimmerLoading(child: ShimmerCard(width: double.infinity, height: double.infinity)),
                      ); // Shimmer for image area
                    }
                    if (snapshot.hasData && snapshot.data != null) {
                      try {
                        final Uint8List bytes = base64Decode(snapshot.data!.split(',').last);
                        return AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.memory(
                            bytes,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(child: Icon(Icons.image_not_supported, size: 64));
                            },
                          ),
                        );
                      } catch (e) {
                        print('Error decoding base64: $e');
                        return const AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Center(child: Icon(Icons.error, size: 64)),
                        ); // Error icon for image area
                      }
                    }
                    return const AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Center(child: Icon(Icons.image_not_supported, size: 64)),
                    ); // Fallback icon for image area
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.favorite, color: Colors.red, size: 20), // Favorite icon
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
              ],
            ),
          ),
        );
      },
    );
  }
}

class FavoritesMobileShimmer extends StatelessWidget {
  const FavoritesMobileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return ShimmerLoading(
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const ShimmerCircle(size: 24),
                  const SizedBox(width: 16),
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
            ),
          ),
        );
      },
    );
  }
}