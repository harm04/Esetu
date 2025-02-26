import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final Color textColor;
  const CustomButton({super.key, required this.buttonText,  required this.buttonColor, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Center(child: Text(buttonText,style: TextStyle(color: textColor,fontSize: 20),),),
      ),
    );
  }
}