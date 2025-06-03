import 'package:flutter/material.dart';

class ContentTypeLabels extends StatelessWidget {
  final List<String> labels;
  final String? selectedLabel;
  final Function(String) onLabelSelected;

  const ContentTypeLabels({
    super.key,
    required this.labels,
    this.selectedLabel,
    required this.onLabelSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Center(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: labels.length,
          itemBuilder: (context, index) {
            final label = labels[index];
            final isSelected = label == selectedLabel;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => onLabelSelected(label),
                    borderRadius: BorderRadius.circular(20),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? Colors.black.withOpacity(0.1)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected 
                              ? Colors.black
                              : Colors.grey[300]!,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                )
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isSelected)
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Icon(
                                _getIconForLabel(label),
                                size: 16,
                                color: Colors.black,
                              ),
                            ),
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 300),
                            style: TextStyle(
                              color: isSelected 
                                  ? Colors.black
                                  : Colors.black87,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 14,
                            ),
                            child: Text(label),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  IconData _getIconForLabel(String label) {
    switch (label.toLowerCase()) {
      case 'all':
        return Icons.grid_view;
      case 'images':
        return Icons.image;
      case 'text':
        return Icons.text_snippet;
      case 'audio':
        return Icons.audio_file;
      default:
        return Icons.folder;
    }
  }
} 