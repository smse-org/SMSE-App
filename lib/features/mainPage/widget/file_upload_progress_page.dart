import 'package:flutter/material.dart';

class FileUploadProgressPage extends StatefulWidget {
  final List<String> files;

  const FileUploadProgressPage({Key? key, required this.files}) : super(key: key);

  @override
  _FileUploadProgressPageState createState() => _FileUploadProgressPageState();
}

class _FileUploadProgressPageState extends State<FileUploadProgressPage> {
  double progress = 0;

  @override
  void initState() {
    super.initState();
    _uploadFiles();
  }

  Future<void> _uploadFiles() async {
    for (int i = 0; i < widget.files.length; i++) {
      await Future.delayed(const Duration(seconds: 5));
      setState(() {
        progress = ((i + 1) / widget.files.length) * 100;
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("All files uploaded successfully!")),
    );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Uploading Files")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Uploading... ${progress.toStringAsFixed(0)}%",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: progress / 100,
              minHeight: 10,
              backgroundColor: Colors.grey[300],
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            Text(
              "File ${((progress / 100) * widget.files.length).ceil()} of ${widget.files.length}",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
