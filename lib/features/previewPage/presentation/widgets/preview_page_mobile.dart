import 'package:flutter/material.dart';
import 'package:smse/constants.dart';

class FilePreviewMobile extends StatelessWidget {
  const FilePreviewMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        children: [
          Container(
            height: 300,
            margin: const EdgeInsets.symmetric(vertical: 24.0 , horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[300],
              border: Border.all(color: Colors.grey[800]!),
            ),
            alignment: Alignment.center,
            child: const Text(
              "File Preview",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: const Color(Constant.blackColor),
                  side: const BorderSide(color: Colors.white),
                   padding: const EdgeInsets.fromLTRB(60, 15, 60, 15),
                ),
                child: const Text("Share", style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold),
              ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: const Color(Constant.whiteColor),
                  side: const BorderSide(color: Colors.black),
                  padding: const EdgeInsets.fromLTRB(60, 15, 60, 15),
                ),
                child: const Text("Save", style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "File details and any relevant metadata can be displayed here.",
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

        ],
      ),
    );
  }
}
