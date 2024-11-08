import 'package:flutter/material.dart';

class Textfeildcustom extends StatelessWidget {
  const Textfeildcustom({super.key, required this.obsecure, required this.label});
  final bool obsecure;
  final String label;
  @override
  Widget build(BuildContext context) {
    return  TextField(
      obscureText: obsecure,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        suffixIcon:obsecure? const Icon(Icons.visibility):null,
      ),
    );
  }
}
