import 'package:flutter/material.dart';

class Textfeildcustom extends StatefulWidget {
  final String label;
  final bool obsecure; // Whether the text field should have hidden text (for password)
  final TextEditingController controller;
  final Function(String) onChanged; // Callback for text changes
  const Textfeildcustom({super.key, required this.label, required this.obsecure, required this.controller, required this.onChanged});

  @override
  TextfeildcustomState createState() => TextfeildcustomState();
}

class TextfeildcustomState extends State<Textfeildcustom> {
  late bool _obscure; // This will be controlled internally only for password fields

  @override
  void initState() {
    super.initState();
    _obscure = widget.obsecure; // Set initial visibility state based on widget.obsecure
  }

  // Toggle the visibility of the password (only when obsecure is true)
  void _toggleVisibility() {
    setState(() {
      _obscure = !_obscure; // Toggle the visibility of the password field
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _obscure, // Only toggle if _obscure is true
      decoration: InputDecoration(
        labelText: widget.label,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        // Show the eye icon for visibility toggle only if it's a password field
        suffixIcon: widget.obsecure
            ? IconButton(
          icon: Icon(
            _obscure ? Icons.visibility : Icons.visibility_off, // Toggle the eye icon
          ),
          onPressed: _toggleVisibility, // Toggle visibility when tapped
        )
            : null, // No icon for non-password fields
      ),
      onChanged: widget.onChanged,
    );
  }
}
