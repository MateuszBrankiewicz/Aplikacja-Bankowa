import 'package:flutter/material.dart';
import 'package:appbank/components/my_button.dart';
import 'package:appbank/components/my_textfield.dart';
import 'package:appbank/components/logo.dart';
import 'package:appbank/firebase/checkRegistation.dart';

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
        // Registration successful
        // Navigate to home page or show a success message
      } else {
        // Registration failed
        // Show an error message
      }
    }
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
                              controller: _firstNameController,
                              hintText: 'First Name',
                              errorText: _firstNameError,
                              obscureText: false,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: MyTextField(
                              controller: _lastNameController,
                              hintText: 'Last Name',
                              errorText: _lastNameError,
                              obscureText: false,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      MyTextField(
                        hintText: 'Email',
                        controller: _emailController,
                        errorText: _emailError,
                        obscureText: false,
                      ),
                      const SizedBox(height: 10),
                      MyTextField(
                        hintText: 'Password',
                        controller: _passwordController,
                        errorText: _passwordError,
                        obscureText: true,
                      ),
                      const SizedBox(height: 10),
                      MyTextField(
                        hintText: 'Confirm Password',
                        controller: _confirmPasswordController,
                        errorText: _confirmPasswordError,
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
