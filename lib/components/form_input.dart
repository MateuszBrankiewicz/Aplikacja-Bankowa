import 'package:flutter/material.dart';
import 'package:appbank/components/fonts.dart';
import 'colors.dart';

class InputForm extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscure;

  const InputForm({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.obscure,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fem = MediaQuery.of(context).textScaleFactor;

    return Container(
      padding: EdgeInsets.all(4 * fem),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.circular(11 * fem),
      ),
      child: TextFormField(
          controller: controller,
          obscureText: obscure ? true : false,
          textAlignVertical: TextAlignVertical.bottom,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: AppFonts.formInputOpacity,
            prefixIcon: Icon(
              icon,
              color: AppColors.white,
            ),
          ),
          style: AppFonts.formInput),
    );
  }
}
