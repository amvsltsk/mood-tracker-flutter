import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget{
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const CustomTextField({
      super.key,
      required this.hintText,
      this.obscureText=false,
      this.keyboardType=TextInputType.text,
      this.controller,
      this.validator,
      this.onChanged,
});

  @override
  Widget build(BuildContext context){
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: const Color(0xFFE8EDF2),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(
          color: Color(0xFF4D7399),
        ),
      ),
    );
  }
}