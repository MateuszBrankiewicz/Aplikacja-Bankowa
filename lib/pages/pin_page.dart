import 'package:appbank/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/logo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const white = Color(0xfffefefe);
const lightRed = Color(0xffc24646);
const darkRed = Color(0xff953333);
const grey = Color(0x99fefefe);
const darkGrey = Color(0xff395263);

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
    // double ffem = fem * 0.97;
    return SizedBox(
      height: 300 * fem,
      width: 240 * fem, // set the height of the number keyboard
      child: GridView.count(
        crossAxisSpacing: 25 * fem,
        mainAxisSpacing: 7 * fem,
        crossAxisCount: 3,
        children: numbers.map((number) {
          return Container(
            decoration: BoxDecoration(
              color: white, // set the background color to white
              borderRadius: BorderRadius.circular(
                  80 * fem), // set the border radius to 30
            ),
            child: TextButton(
              child: number == '<'
                  ? const Icon(
                      Icons.backspace_outlined,
                      color: darkGrey,
                    )
                  : Text(
                      number,
                      style: TextStyle(fontSize: 38 * fem, color: darkGrey),
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
        _buildDot(pin.length >= 1, fem),
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
        color: filled ? darkGrey : grey,
        border: filled
            ? Border.all(color: grey, width: 3 * fem)
            : Border.all(color: grey, width: 3 * fem),
        borderRadius: BorderRadius.circular(50 * fem),
      ),
    );
  }
}

class PinInputScreen extends StatefulWidget {
  @override
  _PinInputScreenState createState() => _PinInputScreenState();
}

class _PinInputScreenState extends State<PinInputScreen> {
  final TextEditingController _pinController = TextEditingController();
  String _pin = "";

  void _onKeyPressed(String value) {
    setState(() {
      if (value == '<') {
        _pin = _pin.substring(0, _pin.length - 1);
      } else {
        _pin += value;
      }
    });
  }

  // Future<void> _submitPin() async {
  //   _pinController.text = _pin;
  //   String pin = _pinController.text;

  //   print('PIN przed sprawdzeniem w bazie danych: $pin');
  //   User? user = FirebaseAuth.instance.currentUser;
  //   String userId = user!.uid;
  //   print('PIN przed sprawdzeniem w bazie danych: $userId');
  //   // Query the database to check if the user's PIN exists
  //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //       .collection('users')
  //       .where('pin', isEqualTo: pin)
  //       .where('userId', isEqualTo: userId)
  //       .get();

  //   if (querySnapshot.docs.isNotEmpty) {
  //     // Show success dialog and navigate to the home page
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: const Text('Logowanie'),
  //           content: const Text('Udało ci się zalogować.'),
  //           actions: [
  //             TextButton(
  //               child: const Text('OK'),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => HomePage()),
  //     );
  //   } else {
  //     // Show error dialog
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: const Text('Logowanie'),
  //           content: const Text('Wprowadź poprawny PIN.'),
  //           actions: [
  //             TextButton(
  //               child: const Text('OK'),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }

  //   setState(() {
  //     _pinController.clear();
  //   });
  // }
  Future<void> _submitPin() async {
    _pinController.text = _pin;
    String pin = _pinController.text;

    print('PIN przed sprawdzeniem w bazie danych: $pin');
    User? user = FirebaseAuth.instance.currentUser;
    String userId = user!.uid;
    print('PIN przed sprawdzeniem w bazie danych: $userId');

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('userId', isEqualTo: userId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot docSnapshot = querySnapshot.docs[0];
      String docId = docSnapshot.id;
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      bool hasPin = data.containsKey('pin') && data['pin'].isNotEmpty;

      if (hasPin) {
        // Check if the entered PIN matches the stored PIN
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('pin', isEqualTo: pin)
            .where('userId', isEqualTo: userId)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Show success dialog and navigate to the home page
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Logowanie'),
                content: const Text('Udało ci się zalogować.'),
                actions: [
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else {
          // Show error dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Logowanie'),
                content: const Text('Wprowadź poprawny PIN.'),
                actions: [
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      } else {
        // Insert the user's PIN into the database
        await FirebaseFirestore.instance
            .collection('users')
            .doc(docId)
            .update({'pin': pin}); // specify the new pin value

        // Show success dialog and navigate to the home page
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Logowanie'),
              content: const Text('Udało ci się zalogować.'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    }
    setState(() {
      _pinController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: 800 * fem,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: <Color>[lightRed, darkRed],
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
                    height: 160 * fem,
                  ),
                  Text(
                    'Enter your pin!',
                    style: GoogleFonts.leagueSpartan(
                        fontSize: 40 * ffem,
                        fontWeight: FontWeight.w500,
                        height: 0.92 * ffem / fem,
                        color: white),
                  ),
                  SizedBox(
                    height: 12 * fem,
                  ),
                  PinWidget(pin: _pin),
                  NumberKeyboard(onKeyPressed: _onKeyPressed),
                  SizedBox(
                    height: 10 * fem,
                  ),
                  Container(
                    width: 180 * fem,
                    height: 38 * fem,
                    decoration: BoxDecoration(
                      border: Border.all(color: darkGrey, width: 3 * fem),
                      borderRadius: BorderRadius.circular(14 * fem),
                    ),
                    child: ElevatedButton(
                      onPressed: _submitPin,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10 * fem))),
                      child: Text(
                        "Confirm",
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 18 * ffem,
                          fontWeight: FontWeight.w500,
                          height: 0.92 * ffem / fem,
                          color: white,
                        ),
                      ),
                    ),
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
