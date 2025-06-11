import 'package:flutter/material.dart';
import 'package:smse/features/previewPage/presentation/screen/preview_page.dart';

class ContentCardWeb extends StatelessWidget {
  final String title;

  const ContentCardWeb({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the details page
       // Navigator.push(context, MaterialPageRoute(builder: (context) =>  const FileViewerPage()));
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/image/beach.jpg', fit: BoxFit.cover, height: 200),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),

            ],
          ),
        ),
      ),
    );
  }
}
