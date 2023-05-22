import 'package:flutter/material.dart';
import 'package:appbank/components/colors.dart';
import 'package:appbank/components/fonts.dart';
import 'package:appbank/components/form_input.dart';
import 'package:appbank/components/my_button.dart';
import 'package:appbank/firebase/Transaction.dart';
import 'dart:math';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

class BLIKPayment extends StatefulWidget {
  const BLIKPayment({super.key});

  @override
  _BLIKPaymentState createState() => _BLIKPaymentState();
}

class _BLIKPaymentState extends State<BLIKPayment> {
  final int resetTime = 120;
  final CountDownController _controller = CountDownController();
  String blikCode = '';
  String remainingTime = '120';

  @override
  void initState() {
    super.initState();
    generateRandomCode();
    _controller.start();
  }

  String generateRandomCode() {
    final random = Random();
    blikCode = '';
    for (int i = 0; i < 6; i++) {
      blikCode += random.nextInt(10).toString();
    }
    return blikCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.lightRed,
        title: Text('BLIK', style: AppFonts.h1),
        titleSpacing: 10,
        elevation: 0,
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
        child: Center(
            child: Stack(
          alignment: Alignment.center,
          children: [
            FractionallySizedBox(
              widthFactor: 1.25, // Adjust the width factor as desired
              heightFactor: 1.25, // Adjust the height factor as desired
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.grey,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            CircularCountDownTimer(
              duration: resetTime,
              initialDuration: 0,
              controller: _controller,
              width: 340,
              height: 340,
              ringColor: Colors.transparent,
              fillColor: AppColors.darkRed,
              backgroundColor: AppColors.white,
              strokeWidth: 12.0,
              strokeCap: StrokeCap.round,
              textStyle: AppFonts.h1,
              textFormat: CountdownTextFormat.MM_SS,
              isReverse: true,
              isReverseAnimation: true,
              isTimerTextShown: true,
              autoStart: true,
              onStart: () {
                setState(() {
                  blikCode = generateRandomCode();
                });
              },
              onChange: (duration) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    remainingTime = duration;
                  });
                });
              },
              onComplete: () {
                _controller.restart();
              },
            ),
            Positioned(
              bottom: 325,
              child: Text(
                "BLIK CODE",
                style: AppFonts.pDark,
              ),
            ),
            Positioned(
              bottom: 280,
              child: Text(
                "${blikCode.substring(0, 3)} ${blikCode.substring(3, 6)}",
                style: AppFonts.h1Dark,
              ),
            ),
            Positioned(
              bottom: 250,
              child: Text(
                remainingTime == '120' || remainingTime == '02:00'
                    ? 'Time left: 2min 00s'
                    : 'Time left: ${remainingTime.substring(1, 2)}min ${remainingTime.substring(3, 5)}s',
                style: AppFonts.h2,
              ),
            ),
          ],
        )),
      ),
    );
  }
}

class Transfer {
  String sender;
  String accNumber;
  double amount;
  String title;
  String recipient;
  bool whether;

  Transfer(
      {this.recipient = '',
      this.accNumber = '',
      this.amount = 0,
      this.title = '',
      this.sender = '',
      this.whether = false});
}

class TransferPayment extends StatelessWidget {
  final Transfer transfer = Transfer();

  TransferPayment({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.lightRed,
        title: Text('Transfer', style: AppFonts.h1),
        titleSpacing: 10,
        elevation: 0,
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
          padding: const EdgeInsets.all(16),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Divider(
                  color: AppColors.white,
                  thickness: 1,
                ),
                InputForm(
                  controller: TextEditingController(text: transfer.recipient),
                  hintText: 'Wpisz nazwe odbiorcy',
                  icon: Icons.person,
                  obscure: false,
                  onChanged: (value) {
                    transfer.recipient = value;
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
                const Divider(
                  color: AppColors.white,
                  thickness: 1,
                ),
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
                const SizedBox(height: 12),
                CustomButton(
                    text: 'Continue',
                    onPressed: () => {wykonajPrzelew(transfer)}),
              ]),
        ),
      ),
    );
  }
}

class TopAccount extends StatelessWidget {
  const TopAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Profile Screen'),
    );
  }
}
