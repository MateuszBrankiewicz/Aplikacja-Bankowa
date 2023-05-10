import 'package:flutter/material.dart';
import 'package:appbank/components/colors.dart';
import 'package:appbank/components/fonts.dart';
import 'package:appbank/components/form_input.dart';
import 'package:appbank/components/my_button.dart';
import 'package:appbank/firebase/Transaction.dart';

class BLIKPayment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Profile Screen'),
    );
  }
}

class Transfer {
  String sender;
  String accNumber;
  double amount;
  String title;
  String retrieving;
  bool whether;

  Transfer(
      {this.retrieving = '',
      this.accNumber = '',
      this.amount = 0,
      this.title = '',
      this.sender = '',
      this.whether = false});

  factory Transfer.fromJson(Map<String, dynamic> json) {
    return Transfer(
        retrieving: json['sender'] as String,
        accNumber: json['accNumber'] as String,
        amount: json['amount'] as double,
        title: json['title'] as String,
        sender: json['retrieving'] as String,
        whether: json['whether'] as bool);
  }

  Map<String, dynamic> toJson() {
    return {
      'retrieving': sender,
      'accNumber': accNumber,
      'amount': amount,
      'title': title,
      'sender': retrieving,
      'whether': whether
    };
  }
}

class TransferPayment extends StatelessWidget {
  Transfer transfer = Transfer();
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 16),
                InputForm(
                  controller: TextEditingController(text: transfer.sender),
                  hintText: 'Wpisz nazwe odbiorcy',
                  icon: Icons.person,
                  obscure: false,
                  onChanged: (value) {
                    transfer.sender = value;
                  },
                ),
                InputForm(
                  controller: TextEditingController(text: transfer.accNumber),
                  hintText: 'Wpisz numer rachunku',
                  icon: Icons.wallet_rounded,
                  obscure: false,
                  onChanged: (value) {
                    transfer.accNumber = value;
                  },
                ),
                SizedBox(height: 16),
                InputForm(
                  controller:
                      TextEditingController(text: transfer.amount.toString()),
                  hintText: 'Wpisz kwote',
                  icon: Icons.monetization_on_outlined,
                  obscure: false,
                  onChanged: (value) {
                    transfer.amount = double.parse(value);
                  },
                ),
                InputForm(
                  controller: TextEditingController(text: transfer.title),
                  hintText: 'Podaj tytul przelewu',
                  icon: Icons.view_agenda,
                  obscure: false,
                  onChanged: (value) {
                    transfer.title = value;
                  },
                ),
                SizedBox(height: 48),
                CustomButton(
                    text: 'Next', onPressed: () => {wykonajPrzelew(transfer)}),
              ]),
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
