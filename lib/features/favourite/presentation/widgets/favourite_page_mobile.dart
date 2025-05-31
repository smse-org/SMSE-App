import 'package:flutter/material.dart';
import 'package:smse/core/components/shimmer_loading.dart';
import 'package:smse/features/mainPage/model/content.dart';
import 'package:smse/features/previewPage/presentation/screen/preview_page.dart';

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
          child: ListTile(
            leading: const Icon(Icons.favorite, color: Colors.red),
            title: Text(content.contentPath.split('/').last),
            subtitle: Text(
              'Size: ${content.contentSize} bytes\n'
                  'Upload Date: ${content.uploadDate.toString().split('.')[0]}',
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FileViewerPage(contentModel: content),
                ),
              );
            },
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