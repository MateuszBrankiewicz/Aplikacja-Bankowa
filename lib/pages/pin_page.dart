import 'package:appbank/pages/home_page.dart';
import 'package:flutter/material.dart';
import '../components/logo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appbank/components/colors.dart';
import 'package:appbank/components/fonts.dart';

//Custom Keyboard
class NumberKeyboard extends StatelessWidget {
  final Function(String) onKeyPressed;

  const NumberKeyboard({super.key, required this.onKeyPressed});

  @override
  Widget build(BuildContext context) {
    List<String> numbers = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '',
      '0',
      '<'
    ];
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    return SizedBox(
      height: 320 * fem,
      width: 240 * fem,
      child: GridView.count(
        crossAxisSpacing: 25 * fem,
        mainAxisSpacing: 7 * fem,
        crossAxisCount: 3,
        children: numbers.map((number) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(80 * fem),
            ),
            child: TextButton(
              child: number == '<'
                  ? const Icon(
                      Icons.backspace_outlined,
                      size: 30,
                      color: AppColors.darkGrey,
                    )
                  : Text(
                      number,
                      style: TextStyle(
                          fontSize: 38 * fem, color: AppColors.darkGrey),
                    ),
              onPressed: () => onKeyPressed(number),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// Pin widget

class PinWidget extends StatelessWidget {
  final String pin;

  const PinWidget({Key? key, required this.pin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDot(pin.isNotEmpty, fem),
        _buildDot(pin.length >= 2, fem),
        _buildDot(pin.length >= 3, fem),
        _buildDot(pin.length >= 4, fem),
      ],
    );
  }

  Widget _buildDot(bool filled, double fem) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      width: 30 * fem,
      height: 30 * fem,
      decoration: BoxDecoration(
        color: filled ? AppColors.darkGrey : AppColors.grey,
        border: filled
            ? Border.all(color: AppColors.grey, width: 3 * fem)
            : Border.all(color: AppColors.grey, width: 3 * fem),
        borderRadius: BorderRadius.circular(50 * fem),
      ),
    );
  }
}

class PinInputScreen extends StatefulWidget {
  final String type;
  const PinInputScreen({Key? key, required this.type}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PinInputScreenState createState() => _PinInputScreenState();
}

class _PinInputScreenState extends State<PinInputScreen> {
  String _pin = "";

  void _onKeyPressed(String value) {
    setState(() {
      if (value == '<') {
        _pin = _pin.substring(0, _pin.length - 1);
      } else {
        _pin += value;
      }
    });
    if (_pin.length == 4) {
      _submitPin();
    }
  }

  void changeScreen(Widget destination) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  bool checkPin(String pin) {
    if (pin.length < 4 || pin.length > 4) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> _submitPin() async {
    if (!checkPin(_pin)) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: AppColors.white,
              title: Center(
                child: Text(
                  'PIN error!',
                  style: AppFonts.h2,
                ),
              ),
              content: Text(
                'PIN is to short!',
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
          });
    } else {
      try {
        String pin = _pin;
        String type = widget.type;

        User? user = FirebaseAuth.instance.currentUser;
        String userId = user!.uid;

        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();

        if (userData.exists) {
          DocumentSnapshot docSnapshot = userData;
          Map<String, dynamic> data =
              docSnapshot.data() as Map<String, dynamic>;
          bool hasPin =
              data.containsKey('pin') && (data['pin'] as String).isNotEmpty;

          if (hasPin && type == 'login') {
            // Check if the entered PIN matches the stored PIN
            final dataPin = await FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .get();
            // ignore: unrelated_type_equality_checks
            if (dataPin.exists) {
              final firepin = dataPin.data()?['pin'];
              if (firepin == pin) {
                changeScreen(const HomePage());
              } else {
                // ignore: use_build_context_synchronously
                showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return AlertDialog(
                        backgroundColor: AppColors.white,
                        title: Center(
                          child: Text(
                            'PIN error!',
                            style: AppFonts.h2,
                          ),
                        ),
                        content: Text(
                          'Wrong PIN!',
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
                    });
              }
            } else {
              // ignore: use_build_context_synchronously
              showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      backgroundColor: AppColors.white,
                      title: Center(
                        child: Text(
                          'PIN error!',
                          style: AppFonts.h2,
                        ),
                      ),
                      content: Text(
                        'Wrong PIN!',
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
                  });
            }
          } else if (type == 'register') {
            // Insert the user's PIN into the database
            await FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .update({'pin': pin}); // specify the new pin value

            // Show success dialog and navigate to the home page
            changeScreen(const HomePage());
          }
        }
      } catch (error) {
        showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                backgroundColor: AppColors.white,
                title: Center(
                  child: Text(
                    'PIN error!',
                    style: AppFonts.h2,
                  ),
                ),
                content: Text(
                  'Something went wrong!',
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
            });
      } finally {
        setState(() {
          _pin = '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    String type = widget.type;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: 800 * fem,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: <Color>[AppColors.lightRed, AppColors.darkRed],
          begin: Alignment(0, 0.546),
          end: Alignment(0, 1),
          stops: <double>[0, 1],
        )),
        child: VectorBackgroundLogo(
          fem: fem,
          child: Padding(
            padding: EdgeInsets.all(16 * fem),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 140 * fem,
                  ),
                  Text(
                    type == 'login' ? "Enter your pin!" : "Create your pin!",
                    style: AppFonts.h1,
                  ),
                  SizedBox(
                    height: 12 * fem,
                  ),
                  PinWidget(pin: _pin),
                  NumberKeyboard(onKeyPressed: _onKeyPressed),
                  SizedBox(
                    height: 10 * fem,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
