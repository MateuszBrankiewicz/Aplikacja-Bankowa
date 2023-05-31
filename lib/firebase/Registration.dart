// ignore: file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:fixnum/fixnum.dart';

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

Future<String> numAccGenerator(String userId) async {
  final collectionRef = FirebaseFirestore.instance.collection('numbers');

  String newNumber = '';
  bool numberExists = true;

  while (numberExists) {
    final number =
        Int64.fromInts(Random().nextInt(100000000), Random().nextInt(100000));
    newNumber = number.toString().padLeft(11, '0');
    final snapshot = await collectionRef
        .doc(userId)
        .collection('users')
        .doc('Bank Account Number')
        .get();
    numberExists = snapshot.exists;
  }

  return newNumber;
}
