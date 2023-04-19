import 'package:appbank/pages/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:appbank/firebase/authentication.dart';
import 'package:appbank/pages/pin_page.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final Authentication _auth = Authentication();

  Future<void> _signInWithEmailAndPassword() async {
    setState(() {
      _email = usernameController.text.trim();
      _password = passwordController.text.trim();
    });
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      print("zalogowano");
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PinInputScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';
      if (e.code == 'user-not-found') {
        errorMessage = e.message ?? 'Nie ma użytkownika o podanym e-mailu.';
      } else if (e.code == 'wrong-password') {
        errorMessage = e.message ?? 'Podaj poprawne haslo.';
      } else {
        errorMessage = e.message ?? 'Wystąpił nieznany błąd.';
      }
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Błąd logowania'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      String errorMessage = e.toString() ?? 'Wystąpił nieznany błąd.';
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Błąd logowania'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                child: Text('OK'),
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
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    const white = Color(0xfffefefe);
    const lightRed = Color(0xffc24646);
    const darkRed = Color(0xff953333);
    const grey = Color(0x99fefefe);
    return Material(
      child: Container(
        width: double.infinity,
        height: 800 * fem,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment(0, 0.546),
          end: Alignment(0, 1),
          colors: <Color>[lightRed, darkRed],
          stops: <double>[0, 1],
        )),
        child: Stack(
          children: [
            //Vector BG
            Positioned(
              left: 0 * fem,
              top: 0 * fem,
              child: Align(
                child: FittedBox(
                  child: Image.asset(
                    './lib/images/vector_bg.png',
                    width: 630.91 * fem,
                    height: 356 * fem,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 100 * fem,
              top: 46 * fem,
              child: SizedBox(
                width: 159 * fem,
                height: 108 * fem,
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Stack(
                    children: [
                      Positioned(
                        //logo
                        left: 36 * fem,
                        top: 0 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 89 * fem,
                            height: 89 * fem,
                            child: Image.asset(
                              './lib/images/logo.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        // poloniabankDAi (2:7)
                        left: 0 * fem,
                        top: 64 * fem,
                        child: Align(
                          child: SizedBox(
                            width: 159 * fem,
                            height: 44 * fem,
                            child: Text(
                              'Polonia Bank',
                              style: GoogleFonts.glegoo(
                                fontSize: 24 * ffem,
                                fontWeight: FontWeight.w700,
                                height: 1.7925 * ffem / fem,
                                color: white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 13 * fem,
              right: 13 * fem,
              top: 277 * fem,
              child: SizedBox(
                width: 330 * fem,
                height: 300 * fem,
                child: Column(
                  key: _formKey,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 0 * fem, 18 * fem),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(
                                6.36 * fem, 0 * fem, 0 * fem, 0 * fem),
                            child: Text(
                              'Hi there!',
                              style: GoogleFonts.leagueSpartan(
                                fontSize: 40 * ffem,
                                fontWeight: FontWeight.w500,
                                height: 0.92 * ffem / fem,
                                color: white,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 18 * fem,
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(
                                14 * fem, 4 * fem, 3 * fem, 3 * fem),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: grey,
                              borderRadius: BorderRadius.circular(11 * fem),
                            ),
                            child: TextFormField(
                              controller: usernameController,
                              obscureText: false,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Email',
                                hintStyle: GoogleFonts.leagueSpartan(
                                  fontSize: 23 * ffem,
                                  fontWeight: FontWeight.w400,
                                  height: 0.92 * ffem / fem,
                                  color: white.withOpacity(0.5),
                                ),
                              ),
                              style: GoogleFonts.leagueSpartan(
                                fontSize: 23 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 0.92 * ffem / fem,
                                color: white,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 18 * fem,
                          ),

                          // Define a controller for the password text field

// Use the controller in your password container
                          Container(
                            padding: EdgeInsets.fromLTRB(
                                14 * fem, 4 * fem, 3 * fem, 3 * fem),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: grey,
                              borderRadius: BorderRadius.circular(11 * fem),
                            ),
                            child: TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Password',
                                hintStyle: GoogleFonts.leagueSpartan(
                                  fontSize: 23 * ffem,
                                  fontWeight: FontWeight.w400,
                                  height: 0.92 * ffem / fem,
                                  color: white.withOpacity(0.5),
                                ),
                              ),
                              style: GoogleFonts.leagueSpartan(
                                fontSize: 23 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 0.92 * ffem / fem,
                                color: white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          0 * fem, 0 * fem, 0 * fem, 10 * fem),
                      width: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SignupPage()),
                                );
                              },
                              child: (Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontFamily: 'League Spartan',
                                  fontSize: 18 * ffem,
                                  fontWeight: FontWeight.w500,
                                  height: 0.92 * ffem / fem,
                                  color: white,
                                ),
                              ))),
                          Text(
                            'Forgot password?',
                            style: GoogleFonts.leagueSpartan(
                              fontSize: 18 * ffem,
                              fontWeight: FontWeight.w500,
                              height: 0.92 * ffem / fem,
                              color: white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => _signInWithEmailAndPassword(),
                      child: Container(
                        width: double.infinity,
                        height: 48 * fem,
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(11 * fem),
                        ),
                        child: Center(
                          child: Text(
                            'Sign in',
                            style: GoogleFonts.leagueSpartan(
                              fontSize: 18 * ffem,
                              fontWeight: FontWeight.w500,
                              height: 0.92 * ffem / fem,
                              color: lightRed,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
