import 'package:flutter/material.dart';
import 'package:smse/features/mainPage/model/content.dart';
import 'package:smse/features/previewPage/presentation/screen/preview_page.dart';

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
            childAspectRatio: 2,
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
                          const Icon(Icons.favorite, color: Colors.red),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              content.contentPath.split('/').last,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Size: ${content.contentSize} bytes',
                        style: const TextStyle(fontSize: 14),
                      ),
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
}