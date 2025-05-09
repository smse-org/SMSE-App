import 'package:flutter/material.dart';
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