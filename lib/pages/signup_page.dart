// ignore_for_file: use_build_context_synchronously

import 'package:appbank/pages/login_page.dart';
import 'package:appbank/pages/pin_registerp.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appbank/firebase/checkRegistation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String _firstNameError = '';
  String _lastNameError = '';
  String _emailError = '';
  String _passwordError = '';
  String _confirmPasswordError = '';

  Future<void> signUp() async {
    // Reset error messages
    setState(() {
      _firstNameError = '';
      _lastNameError = '';
      _emailError = '';
      _passwordError = '';
      _confirmPasswordError = '';
    });

    // Get input values
    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    // Validate input data
    bool isValid = true;

    if (firstName.isEmpty) {
      setState(() {
        _firstNameError = 'Please enter your first name';
      });
      isValid = false;
    }

    if (lastName.isEmpty) {
      setState(() {
        _lastNameError = 'Please enter your last name';
      });
      isValid = false;
    }

    if (email.isEmpty) {
      setState(() {
        _emailError = 'Please enter your email';
      });
      isValid = false;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      setState(() {
        _emailError = 'Please enter a valid email';
      });
      isValid = false;
    }

    if (password.isEmpty) {
      setState(() {
        _passwordError = 'Please enter your password';
      });
      isValid = false;
    } else if (password.length < 6) {
      setState(() {
        _passwordError = 'Password must be at least 6 characters long';
      });
      isValid = false;
    }

    if (confirmPassword.isEmpty) {
      setState(() {
        _confirmPasswordError = 'Please confirm your password';
      });
      isValid = false;
    } else if (password != confirmPassword) {
      setState(() {
        _confirmPasswordError = 'Passwords do not match';
      });
      isValid = false;
    }

    if (isValid) {
      // Register user
      bool isRegistered = await registerUser(
          firstName, lastName, email, password, confirmPassword);

      if (isRegistered) {
        User? user = FirebaseAuth.instance.currentUser;
        String userId = user!.uid;
        String AccNumber = incrementNumber().toString();
        await FirebaseFirestore.instance.collection('users').add({
          'userId': userId,
          'First Name': firstName,
          'Last Name': lastName,
          'Bank account number': AccNumber,
        });
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => PinInputScreenR()));
      } else {
        // Registration failed
        // Show an error message
      }
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
    const darkGrey = Color(0xff395263);

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
            child: Stack(children: [
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
                top: 210 * fem,
                child: SizedBox(
                  width: 375 * fem,
                  height: 401 * fem,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            0 * fem, 0 * fem, 0 * fem, 36 * fem),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                  0 * fem, 0 * fem, 0 * fem, 18 * fem),
                              width: double.infinity,
                              height: 56 * fem,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(11 * fem),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(18 * fem,
                                        0 * fem, 17.95 * fem, 0 * fem),
                                    width: 156.53 * fem,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      color: grey,
                                      borderRadius:
                                          BorderRadius.circular(11 * fem),
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16 * fem),
                                        child: TextFormField(
                                          controller: _firstNameController,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(
                                                bottom: -14 * fem),
                                            border: InputBorder.none,
                                            hintText: 'First Name',
                                            errorText: _firstNameError,
                                            hintStyle:
                                                GoogleFonts.leagueSpartan(
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
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        0 * fem, 0 * fem, 17.95 * fem, 0 * fem),
                                    width: 156.53 * fem,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      color: grey,
                                      borderRadius:
                                          BorderRadius.circular(11 * fem),
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16 * fem),
                                        child: TextFormField(
                                          controller: _lastNameController,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(
                                                bottom: -14 * fem),
                                            border: InputBorder.none,
                                            hintText: 'Last Name',
                                            errorText: _lastNameError,
                                            hintStyle:
                                                GoogleFonts.leagueSpartan(
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
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                  0 * fem, 0 * fem, 0 * fem, 17 * fem),
                              width: 332.01 * fem,
                              height: 56 * fem,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(11 * fem),
                              ),
                              child: Container(
                                padding: EdgeInsets.fromLTRB(13.92 * fem,
                                    18 * fem, 13.92 * fem, 16 * fem),
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  color: grey,
                                  borderRadius: BorderRadius.circular(11 * fem),
                                ),
                                child: TextFormField(
                                  controller: _emailController,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.only(bottom: -4 * fem),
                                    border: InputBorder.none,
                                    hintText: 'Email',
                                    errorText: _emailError,
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
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                  0 * fem, 0 * fem, 0 * fem, 18 * fem),
                              width: 332.01 * fem,
                              height: 56 * fem,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(11 * fem),
                              ),
                              child: Container(
                                padding: EdgeInsets.fromLTRB(13.92 * fem,
                                    18 * fem, 13.92 * fem, 16 * fem),
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  color: grey,
                                  borderRadius: BorderRadius.circular(11 * fem),
                                ),
                                child: TextFormField(
                                  controller: _confirmPasswordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.only(bottom: -4 * fem),
                                    border: InputBorder.none,
                                    hintText: 'Password',
                                    errorText: _confirmPasswordError,
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
                            ),
                            Container(
                              width: 330 * fem,
                              height: 56 * fem,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(11 * fem),
                              ),
                              child: Container(
                                padding: EdgeInsets.fromLTRB(13.92 * fem,
                                    18 * fem, 13.92 * fem, 16 * fem),
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  color: grey,
                                  borderRadius: BorderRadius.circular(11 * fem),
                                ),
                                child: TextFormField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.only(bottom: -4 * fem),
                                    border: InputBorder.none,
                                    hintText: 'Confirm Password',
                                    errorText: _confirmPasswordError,
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
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(
                            20 * fem, 0 * fem, 20 * fem, 18 * fem),
                        width: double.infinity,
                        height: 48 * fem,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(11 * fem),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(11.0)),
                            backgroundColor: white,
                          ),
                          onPressed: signUp,
                          child: Text(
                            'Sign Up',
                            style: GoogleFonts.leagueSpartan(
                              fontSize: 18 * ffem,
                              fontWeight: FontWeight.w500,
                              height: 0.92 * ffem / fem,
                              color: lightRed,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(
                            50 * fem, 0 * fem, 61.36 * fem, 0 * fem),
                        width: double.infinity,
                        height: 22 * fem,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(
                                    30 * fem, 0 * fem, 2.28 * fem, 0 * fem),
                                child: Text(
                                  'Already a member?',
                                  style: GoogleFonts.leagueSpartan(
                                    fontSize: 18 * ffem,
                                    fontWeight: FontWeight.w500,
                                    height: 0.92 * ffem / fem,
                                    color: white,
                                  ),
                                ),
                              ),
                              Container(
                                width: 80 * fem,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  color: darkGrey,
                                  borderRadius: BorderRadius.circular(6 * fem),
                                ),
                                child: Center(
                                    child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(11.0)),
                                    backgroundColor: darkGrey,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoginPage()));
                                  },
                                  child: Text(
                                    'Sign In',
                                    style: GoogleFonts.leagueSpartan(
                                      fontSize: 18 * ffem,
                                      fontWeight: FontWeight.w500,
                                      height: 0.92 * ffem / fem,
                                      color: white,
                                    ),
                                  ),
                                )),
                              ),
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
            ])));
  }
}
