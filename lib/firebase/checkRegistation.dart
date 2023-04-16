import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<bool> registerUser(
  String firstName,
  String lastName,
  String email,
  String password,
  String confirmPassword,
) async {
  try {
    // Check if passwords match
    if (password != confirmPassword) {
      throw Exception('Passwords do not match');
    }

    // Create user with email and password
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Update user profile with first name and last name
    await userCredential.user?.updateProfile(
      displayName: '$firstName $lastName',
    );

    // Send verification email to the user
    await userCredential.user?.sendEmailVerification();

    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'email-already-in-use') {
      // Email already exists
      // Show an error message
      throw Exception('Email already exists');
    } else {
      // Registration failed for some other reason
      // Show an error message
      throw Exception('Registration failed. Please try again later.');
    }
  }
}
