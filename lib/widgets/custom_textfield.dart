import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool obsecureText;
  final TextInputType type;
  final int maxlines;
  const CustomTextfield(
      {super.key,
      required this.hintText,
      required this.type,
      required this.controller,
      required this.obsecureText,
      this.maxlines = 1});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.black,
      controller: controller,
      keyboardType: type,
      obscureText: obsecureText,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: 'Enter your $hintText',
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black),
        ),
      ),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Enter your $hintText';
        }
        return null;
      },
      maxLines: maxlines,
    );
  }
}
