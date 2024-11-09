import 'package:flutter/material.dart';

class SearchBarCustom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Find a sunset beach photo or Research on black holes",
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(onPressed: () {  },
            icon: const Icon(Icons.mic)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
