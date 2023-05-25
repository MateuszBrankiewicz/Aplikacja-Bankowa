import 'package:appbank/pages/login_page.dart';
import 'package:appbank/pages/pin_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appbank/firebase/Registration.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:core';

import 'package:appbank/components/form_input.dart';

import 'package:appbank/components/colors.dart';
import 'package:appbank/components/fonts.dart';
import 'package:appbank/components/my_button.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String _errorMessage = '';

  Future<void> signUp() async {
    // Reset error messages
    setState(() {
      _errorMessage = '';
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
        _errorMessage += 'Please enter your first name!\n';
      });
      isValid = false;
    }

    if (lastName.isEmpty) {
      setState(() {
        _errorMessage += 'Please enter your last name!\n';
      });
      isValid = false;
    }

    if (email.isEmpty) {
      setState(() {
        _errorMessage += 'Please enter your email!\n';
      });
      isValid = false;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      setState(() {
        _errorMessage += 'Please enter a valid email!\n';
      });
      isValid = false;
    }

    if (password.isEmpty) {
      setState(() {
        _errorMessage += 'Please enter your password!\n';
      });
      isValid = false;
    } else if (password.length < 6) {
      setState(() {
        _errorMessage += 'Password must be at least 6 characters long!\n';
      });
      isValid = false;
    }

    if (confirmPassword.isEmpty) {
      setState(() {
        _errorMessage += 'Please confirm your password!\n';
      });
      isValid = false;
    } else if (password != confirmPassword) {
      setState(() {
        _errorMessage += 'Passwords do not match!\n';
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
        String accNumber = await numAccGenerator(userId);
        final currentYear = DateTime.now().year + 5;
        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'First Name': firstName,
          'Last Name': lastName,
          'Bank account number': accNumber,
          'pin': '',
          'account balance': '0',
          'expires': currentYear.toString(),
          'transaction': []
        });
        changeScreen(const PinInputScreen(type: 'register'));
      } else {
        // Registration failed
        print("Something went wrong!");
      }
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: AppColors.white,
              title: Center(
                child: Text(
                  'Signup error!',
                  style: AppFonts.h2,
                ),
              ),
              content: Text(
                _errorMessage,
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
  }

  void changeScreen(Widget destination) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Material(
        child: Container(
            width: double.infinity,
            height: 800 * fem,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment(0, 0.546),
              end: Alignment(0, 1),
              colors: <Color>[AppColors.lightRed, AppColors.darkRed],
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
                                  color: AppColors.white,
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
                top: 195 * fem,
                child: SizedBox(
                  child: Column(
                    key: _formKey,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(
                                6.5 * fem, 0 * fem, 0 * fem, 0 * fem),
                            child: Text(
                              'Hi there!',
                              style: AppFonts.h1,
                            ),
                          ),
                          SizedBox(
                            height: 14 * fem,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: InputForm(
                                  controller: _firstNameController,
                                  isNumeric: false,
                                  hintText: 'First name',
                                  icon: Icons.person,
                                  obscure: false,
                                ),
                              ),
                              SizedBox(
                                width: 16 * fem,
                              ),
                              Expanded(
                                child: InputForm(
                                  controller: _lastNameController,
                                  isNumeric: false,
                                  hintText: 'Last name',
                                  icon: Icons.people,
                                  obscure: false,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 18 * fem,
                          ),
                          InputForm(
                            controller: _emailController,
                            hintText: 'Email',
                            isNumeric: false,
                            icon: Icons.mail,
                            obscure: false,
                          ),
                          SizedBox(
                            height: 18 * fem,
                          ),
                          InputForm(
                            controller: _passwordController,
                            isNumeric: false,
                            hintText: 'Password',
                            icon: Icons.lock,
                            obscure: true,
                          ),
                          SizedBox(
                            height: 18 * fem,
                          ),
                          InputForm(
                            controller: _confirmPasswordController,
                            isNumeric: false,
                            hintText: 'Confirm Password',
                            icon: Icons.lock_person,
                            obscure: true,
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 24 * fem),
                        child: CustomButton(text: 'Sign up', onPressed: signUp),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 2 * fem),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                                onPressed: () =>
                                    changeScreen(const LoginPage()),
                                child: (Text(
                                    'Already have an account?  Sign in',
                                    style: AppFonts.p))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ])));
  }
}
