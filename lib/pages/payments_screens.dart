import 'package:appbank/pages/home_page.dart';
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
      this.amount = 0.00,
      this.title = '',
      this.sender = '',
      this.whether = false});
}

class TransferPayment extends StatefulWidget {
  final String balance;
  const TransferPayment({super.key, required this.balance});

  @override
  _TransferPaymentState createState() =>
      _TransferPaymentState(balance: balance);
}

class _TransferPaymentState extends State<TransferPayment> {
  final Transfer transfer = Transfer();
  final String balance;
  _TransferPaymentState({required this.balance});

  void _showCongratulationDialog(double amount, String name) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Transaction finished ',
                style: AppFonts.h2,
              ),
              const Icon(
                Icons.check_circle,
                color: AppColors.green,
              )
            ],
          ),
          content: Text(
            'You have successfully transfered $amount\$ to $name!',
            style: AppFonts.errorText,
          ),
          actions: [
            Center(
              child: TextButton(
                child: Text(
                  'Continue',
                  style: AppFonts.buttonText,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> makeTransaction() async {
    String errorText = '';
    bool isValid = true;
    if (transfer.recipient.isEmpty) {
      errorText += 'Enter recipient name!\n';
      isValid = false;
    }
    if (transfer.accNumber.isEmpty) {
      errorText += 'Add account number!\n';
      isValid = false;
    }
    if (transfer.accNumber.length != 18) {
      errorText += 'Wrong account number length!\n';
    }
    if (transfer.title.isEmpty || transfer.title.length <= 2) {
      errorText += 'Add transfer title!\n';
      isValid = false;
    }
    if (transfer.amount <= 0.00) {
      errorText += 'Enter correct amount!\n';
      isValid = false;
    } else {
      double balanceAmount = double.tryParse(balance) ?? 0.0;
      if (transfer.amount > balanceAmount) {
        errorText += 'Insufficient balance!\n';
        isValid = false;
      }
    }
    if (isValid) {
      wykonajPrzelew(transfer, context);
      _showCongratulationDialog(transfer.amount, transfer.sender);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: AppColors.white,
            title: Center(
              child: Text(
                'Transfer error!',
                style: AppFonts.h2,
              ),
            ),
            content: Text(
              errorText,
              style: AppFonts.errorText,
            ),
            actions: [
              TextButton(
                child: Text(
                  'Try again',
                  style: AppFonts.buttonText,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

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
                  isNumeric: false,
                  onChanged: (value) {
                    transfer.recipient = value;
                  },
                ),
                InputForm(
                  controller: TextEditingController(text: transfer.accNumber),
                  hintText: 'Wpisz numer rachunku',
                  icon: Icons.wallet_rounded,
                  isNumeric: true,
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
                  isNumeric: true,
                  obscure: false,
                  onChanged: (value) {
                    if (value.isEmpty) {
                      transfer.amount = 0.00;
                    } else {
                      transfer.amount = double.parse(value);
                    }
                  },
                ),
                InputForm(
                  controller: TextEditingController(text: transfer.title),
                  hintText: 'Podaj tytul przelewu',
                  isNumeric: false,
                  icon: Icons.view_agenda,
                  obscure: false,
                  onChanged: (value) {
                    transfer.title = value;
                  },
                ),
                const SizedBox(height: 12),
                CustomButton(
                    text: 'Continue', onPressed: () => {makeTransaction()}),
              ]),
        ),
      ),
    );
  }
}

class TopAccount extends StatefulWidget {
  const TopAccount({super.key});

  @override
  _TopAccountState createState() => _TopAccountState();
}

class _TopAccountState extends State<TopAccount> {
  final TextEditingController _amountController = TextEditingController();
  String errorMessage = '';

  Future<void> _addMoneyToAccount() async {
    String amountText = _amountController.text.trim();
    int amount = int.tryParse(amountText) ?? 0;
    bool isValid = true;

    if (amountText.isEmpty) {
      setState(() {
        errorMessage = 'Please enter an amount!';
      });
      isValid = false;
    }

    if (amount <= 0 || amount > 2000) {
      setState(() {
        errorMessage = 'Invalid amount. Enter amount between 0 and 2000!';
      });
      isValid = false;
    }
    if (isValid) {
      //Dodanie kasy do konta, lub wyrzucenie bledu jak sie zapytanie zepsuje
      //Jesli pomyslnie doda kase do bazy danych to wywolujesz ta funkcje
      //_showCongratulationDialog(amount);
      // try{
      _showCongratulationDialog(amount);
      // }
      // catch{
      // }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: AppColors.white,
            title: Center(
              child: Text(
                'Top up error!',
                style: AppFonts.h2,
              ),
            ),
            content: Text(
              errorMessage,
              style: AppFonts.errorText,
            ),
            actions: [
              TextButton(
                child: Text(
                  'Try again',
                  style: AppFonts.buttonText,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _showCongratulationDialog(int amount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Congratulations ',
                style: AppFonts.h2,
              ),
              const Icon(
                Icons.check_circle,
                color: AppColors.green,
              )
            ],
          ),
          content: Text(
            'You have successfully added $amount\$ to your account!',
            style: AppFonts.errorText,
          ),
          actions: [
            Center(
              child: TextButton(
                child: Text(
                  'Continue',
                  style: AppFonts.buttonText,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.lightRed,
        title: Text('Top up', style: AppFonts.h1),
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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Divider(
              color: AppColors.white,
              thickness: 1,
            ),
            const SizedBox(
              height: 100,
            ),
            Text(
              'Add funds to your account:',
              style: AppFonts.formInput,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0),
              child: InputForm(
                controller: _amountController,
                isNumeric: true,
                hintText: 'Enter amount (max: 2000\$)',
                icon: Icons.attach_money,
                obscure: false,
                // onChanged: (value) {
                //   transfer.sender = value;
                // },
              ),
            ),
            CustomButton(text: 'Add money', onPressed: _addMoneyToAccount),
          ]),
        ),
      ),
    );
  }
}
