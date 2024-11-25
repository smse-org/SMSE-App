import 'package:flutter/material.dart';
import 'package:smse/constants.dart';

class FilePreviewWeb extends StatelessWidget {
  const FilePreviewWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 600,
              height: 400,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[300],
                border: Border.all(color: Colors.grey[800]!),
              ),
              child: const Text("File Preview", style: TextStyle(fontSize: 24)),
            ),
            const SizedBox(height: 20),
            const Text(
              "Highlighted Text",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "This is a sample text with highlighted section that matches the query.",
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor:  const Color(Constant.blueColor),
                    side: const BorderSide(color: Colors.white),
                    padding: const EdgeInsets.fromLTRB(60, 15, 60, 15),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.download, color: Colors.white),
                      SizedBox(width: 10),
                      Text("Download", style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 60),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor:  const Color(Constant.greenColor),
                    side: const BorderSide(color: Colors.white),
                    padding: const EdgeInsets.fromLTRB(60, 15, 60, 15),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.share, color: Colors.white),
                      SizedBox(width: 10),
                      Text("Share", style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}