import 'package:flutter/material.dart';
import 'package:appbank/components/colors.dart';
import 'package:appbank/components/fonts.dart';
import 'package:appbank/components/form_input.dart';
import 'package:appbank/components/my_button.dart';

class BLIKPayment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Profile Screen'),
    );
  }
}

class TransferPayment extends StatelessWidget {
  final TextEditingController placeholder = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.lightRed,
        title: Text('Transfer', style: AppFonts.h1),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0, 0.546),
            end: Alignment(0, 1),
            colors: <Color>[AppColors.lightRed, AppColors.darkRed],
            stops: <double>[0, 1],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16),
              InputForm(
                  controller: placeholder,
                  hintText: 'Wpisz nazwe odbiorcy',
                  icon: Icons.person,
                  obscure: false),
              SizedBox(height: 32),
              InputForm(
                  controller: placeholder,
                  hintText: 'Wpisz numer rachunku',
                  icon: Icons.wallet_rounded,
                  obscure: false),
              SizedBox(height: 48),
              InputForm(
                  controller: placeholder,
                  hintText: 'Wpisz kwote',
                  icon: Icons.monetization_on_outlined,
                  obscure: false),
              SizedBox(height: 16),
              InputForm(
                  controller: placeholder,
                  hintText: 'Podaj tytul',
                  icon: Icons.view_agenda,
                  obscure: false),
              SizedBox(height: 48),
              CustomButton(text: 'Next', onPressed: () => {}),
            ],
          ),
        ),
      ),
    );
  }
}

class ContactlessPayment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Profile Screen'),
    );
  }
}
