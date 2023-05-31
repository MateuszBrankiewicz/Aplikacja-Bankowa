import 'package:flutter/material.dart';
import 'package:appbank/components/fonts.dart';
import 'package:flutter/services.dart';
import 'colors.dart';

class InputForm extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscure;
  final bool isNumeric;
  final void Function(String)? onChanged;

  const InputForm({
    Key? key,
    required this.isNumeric,
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.obscure,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fem = MediaQuery.of(context).textScaleFactor;

    if (isNumeric) {
      return Container(
        padding: EdgeInsets.all(4 * fem),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.grey,
          borderRadius: BorderRadius.circular(11 * fem),
        ),
        child: TextFormField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(
              r'^[0-9]*[.]?[0-9]*',
            ))
          ],
          obscureText: obscure ? true : false,
          textAlignVertical: TextAlignVertical.bottom,
          onChanged: onChanged,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: AppFonts.formInputOpacity,
            prefixIcon: Icon(
              icon,
              color: AppColors.white,
            ),
          ),
          style: AppFonts.formInput,
        ),
      );
    } else {
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
          onChanged: onChanged,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: AppFonts.formInputOpacity,
            prefixIcon: Icon(
              icon,
              color: AppColors.white,
            ),
          ),
          style: AppFonts.formInput,
        ),
      );
    }
  }
}
