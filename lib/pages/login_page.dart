import 'package:appbank/components/fonts.dart';
import 'package:appbank/components/my_button.dart';
import 'package:appbank/pages/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:appbank/pages/pin_page.dart';
import 'package:appbank/components/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:appbank/components/form_input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

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

  void changeScreen(Widget destination) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }

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
      changeScreen(PinInputScreen());
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';
      if (e.code == 'user-not-found') {
        errorMessage = 'User not found!';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Invalid password!';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email!';
      } else {
        errorMessage = 'Email and Password fields are required!';
      }
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
    } catch (e) {
      String errorMessage = e.toString();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Signup error'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                child: const Text('Try again'),
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
              top: 277 * fem,
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
                            'Welcome back!',
                            style: AppFonts.h1,
                          ),
                        ),
                        SizedBox(
                          height: 18 * fem,
                        ),
                        InputForm(
                          controller: usernameController,
                          hintText: 'Email',
                          icon: Icons.person,
                          obscure: false,
                        ),
                        SizedBox(
                          height: 18 * fem,
                        ),
                        InputForm(
                          controller: passwordController,
                          hintText: 'Password',
                          icon: Icons.lock,
                          obscure: true,
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 16 * fem),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                              onPressed: () => changeScreen(const SignupPage()),
                              child: (Text('Sign up', style: AppFonts.p))),
                          TextButton(
                              onPressed: () => changeScreen(const SignupPage()),
                              child: (Text('Forgot password?',
                                  style: AppFonts.p))),
                        ],
                      ),
                    ),
                    CustomButton(
                        text: 'Sign in',
                        onPressed: _signInWithEmailAndPassword),
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
