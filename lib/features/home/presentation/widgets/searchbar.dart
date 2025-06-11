import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:smse/features/search/presentation/controller/search_cubit.dart';
import 'package:smse/features/search/presentation/controller/search_state.dart';
import 'package:smse/features/uploded_content/presentation/controller/cubit/content_cubit.dart';
import 'package:smse/features/uploded_content/presentation/controller/cubit/content_state.dart';
import 'package:smse/features/search/data/model/search_query.dart';

class SearchBarCustom extends StatefulWidget {
  final Function(String) onSearch;
  final TextEditingController controller;

  const SearchBarCustom({
    super.key,
    required this.onSearch,
    required this.controller,
  });

  @override
  SearchBarCustomState createState() => SearchBarCustomState();
}

class SearchBarCustomState extends State<SearchBarCustom> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  List<String> _selectedFiles = [];

  void _handleSearch() async {
    if (widget.controller.text.isEmpty && _selectedFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a search query or upload files')),
      );
      return;
    }

    final searchCubit = context.read<SearchCubit>();
    final selectedModalities = searchCubit.selectedModalities;

    try {
      // Execute search based on whether we have files or just text
      if (_selectedFiles.isNotEmpty) {
        await searchCubit.searchWithFiles(
          _selectedFiles,
          query: widget.controller.text.trim(),
          limit: 10,
          modalities: selectedModalities,
        );
      } else {
        await searchCubit.searchWithText(
          widget.controller.text.trim(),
          limit: 10,
          modalities: selectedModalities,
        );
      }

      // Clear selected files after successful search
      setState(() {
        _selectedFiles.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error performing search: $e')),
      );
    }
  }

  Future<bool> _requestMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (status.isDenied) {
      status = await Permission.microphone.request();
    }
    return status.isGranted;
  }

  void _toggleListening() async {
    if (_isListening) {
      setState(() => _isListening = false);
      _handleSearch();
      await _speech.stop();
    } else {
      final hasPermission = await _requestMicrophonePermission();
      if (!hasPermission) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Microphone permission is required.")),
        );
        return;
      }

      try {
        bool available = await _speech.initialize();
        if (available) {
          setState(() => _isListening = true);
          await _speech.listen(onResult: (result) {
            setState(() {
              widget.controller.text = result.recognizedWords;
            });
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error initializing speech: $e")),
        );
      }
    }
  }

  Future<void> _pickFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'wav', 'txt'],
      );

      if (result != null) {
        setState(() {
          _selectedFiles.addAll(result.paths.where((path) => path != null).cast<String>());
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking files: $e')),
      );
    }
  }

  void _showModalitySelector() {
    final searchCubit = context.read<SearchCubit>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => BlocProvider<SearchCubit>.value(
        value: searchCubit,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(16),
          child: const SearchModalitySelector(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
          ? Colors.grey[100]
          : Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  maxLines: 4,
                  controller: widget.controller,
                  onSubmitted: (_) => _handleSearch(),
                  decoration: InputDecoration(
                    hintText: "Search with text, images, or audio files",
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_selectedFiles.isNotEmpty)
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${_selectedFiles.length} file${_selectedFiles.length > 1 ? 's' : ''}',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: _pickFiles,
                        ),
                      ],
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _handleSearch,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Colors.black,
                ),
                child: const Icon(Icons.arrow_upward, color: Colors.white),
              ),
            ],
          ),
          if (_selectedFiles.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.2,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _selectedFiles.length,
                itemBuilder: (context, index) {
                  final file = _selectedFiles[index];
                  final fileName = file.split('/').last;
                  final isImage = fileName.toLowerCase().endsWith('.jpg') ||
                                fileName.toLowerCase().endsWith('.jpeg');
                  final isAudio = fileName.toLowerCase().endsWith('.wav');

                  return Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.light
                        ? Colors.grey[200]
                        : Colors.grey[800],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isImage ? Icons.image :
                          isAudio ? Icons.audio_file : Icons.text_snippet,
                          size: 20,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            fileName,
                            style: const TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 16),
                          onPressed: () {
                            setState(() {
                              _selectedFiles.removeAt(index);
                            });
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class SearchModalitySelector extends StatelessWidget {
  const SearchModalitySelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.4,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Text(
                'Filter by Modality',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black87
                    : Colors.white70,
                ),
              ),
            ),
            const SizedBox(height: 12),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _ModalityChip(
                      label: 'Text',
                      value: 'text',
                      icon: Icons.text_fields_rounded,
                    ),
                    _ModalityChip(
                      label: 'Image',
                      value: 'image',
                      icon: Icons.image_rounded,
                    ),
                    _ModalityChip(
                      label: 'Audio',
                      value: 'audio',
                      icon: Icons.audio_file_rounded,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModalityChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ModalityChip({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        final isSelected = context.read<SearchCubit>().selectedModalities.contains(value);
        return FilterChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
          selected: isSelected,
          onSelected: (selected) {
            context.read<SearchCubit>().toggleModality(value);
          },
          backgroundColor: Colors.grey[200],
          selectedColor: Theme.of(context).primaryColor,
          checkmarkColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
              width: 1,
            ),
          ),
        );
      },
    );
  }
}
