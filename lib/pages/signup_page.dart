import 'package:flutter/material.dart';
import 'package:appbank/components/my_button.dart';
import 'package:appbank/components/my_textfield.dart';
import 'package:appbank/components/logo.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final usernameController = TextEditingController(); //do zmiany
  final passwordController = TextEditingController(); //do zmiany

  void signUp() async {
    //Funkcja do rejestrowania uzytkownika
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 45),
                // logo
                const Logo(imagePath: './lib/images/logo.jfif'),

                const SizedBox(height: 25),

                const Text(
                  'Bank Polonia',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 35,
                  ),
                ),

                const SizedBox(height: 15),

                // registration form
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: MyTextField(
                              controller:
                                  usernameController, //do zmiany na odpowiedni kontroler
                              hintText: 'First Name',
                              obscureText: false,
                            ),
                          ),
                          Expanded(
                            child: MyTextField(
                              controller:
                                  usernameController, //do zmiany na odpowiedni kontroler
                              hintText: 'Last Name',
                              obscureText: false,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      MyTextField(
                        hintText: 'Email',
                        controller:
                            usernameController, //do zmiany na odpowiedni kontroler
                        obscureText: false,
                      ),
                      const SizedBox(height: 10),
                      MyTextField(
                        hintText: 'Password',
                        controller:
                            usernameController, //do zmiany na odpowiedni kontroler
                        obscureText: true,
                      ),
                      const SizedBox(height: 10),
                      MyTextField(
                        hintText: 'Confirm Password',
                        controller:
                            usernameController, //do zmiany na odpowiedni kontroler
                        obscureText: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // sign up button
                MyButton(
                  buttonText: 'Sign Up',
                  onTap: () => signUp(),
                ),

                const SizedBox(height: 20),

                // already a member? sign in now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Sign in now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
