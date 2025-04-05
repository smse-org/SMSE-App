import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

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

  void _handleSearch() {
    if (widget.controller.text.isNotEmpty) {
      widget.onSearch(widget.controller.text);
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

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onSubmitted: (_) => _handleSearch(),
      decoration: InputDecoration(
        hintText: "Find a sunset beach photo or Research on black holes",
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          onPressed: _toggleListening,
          icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
