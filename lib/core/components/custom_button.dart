import 'package:flutter/material.dart';
class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.color, required this.text, required this.colorText, required this.onPressed});
  final Color color;
  final String text;
  final Color colorText;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor:  color,
        side: const BorderSide(color: Colors.white),
        minimumSize: const Size(double.infinity, 50),
      ),
      child:   Text(text, style: TextStyle(color: colorText , fontWeight: FontWeight.bold),),
    );
  }
}
