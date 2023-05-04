import 'package:flutter/material.dart';
import 'package:appbank/components/fonts.dart';
import 'package:appbank/components/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(11),
        ),
      ),
      child: Container(
        width: double.infinity,
        height: 48,
        child: Center(
          child: Text(text, style: AppFonts.buttonText),
        ),
      ),
    );
  }
}
