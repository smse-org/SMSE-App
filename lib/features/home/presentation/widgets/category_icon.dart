import 'package:flutter/material.dart';

class CategoryIcons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconCategory(icon: Icons.article, label: "Text"),
        IconCategory(icon: Icons.image, label: "Image"),
        IconCategory(icon: Icons.videocam, label: "Video"),
        IconCategory(icon: Icons.music_note, label: "Audio"),
      ],
    );
  }
}

class IconCategory extends StatefulWidget {
  final IconData icon;
  final String label;

  IconCategory({required this.icon, required this.label});

  @override
  _IconCategoryState createState() => _IconCategoryState();
}

class _IconCategoryState extends State<IconCategory> {
  bool _isSelected = false;

  void _toggleSelection() {
    setState(() {
      _isSelected = !_isSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: _isSelected ? Colors.blue : Colors.grey[200], // Change color when selected
          radius: 35,
          child: IconButton(
            icon: Icon(widget.icon, size: 40, color: _isSelected ? Colors.white : Colors.black),
            onPressed: _toggleSelection,
          ),
        ),
        const SizedBox(height: 8),
        Text(widget.label),
      ],
    );
  }
}
