import 'package:flutter/material.dart';
import 'package:smse/features/previewPage/presentation/screen/preview_page.dart';

class ContentCardWeb extends StatelessWidget {
  final String title;
  final int relevanceScore;

  const ContentCardWeb({required this.title, required this.relevanceScore});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the details page
        Navigator.push(context, MaterialPageRoute(builder: (context) =>  FileViewerPage()));
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 180,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[300],
                border: Border.all(color: Colors.grey[800]!),

              ),
              child: const Center(child: Text('Image')),
            ),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Relevance Score: $relevanceScore'),
            const SizedBox(height: 16),

          ],
        ),
      ),
    );
  }
}
