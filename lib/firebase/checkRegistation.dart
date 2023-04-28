import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

Future<String> incrementNumber() async {
  final firestoreInstance = FirebaseFirestore.instance;
  final collectionRef = firestoreInstance.collection('numbers');
  final snapshot =
      await collectionRef.orderBy('value', descending: true).limit(1).get();
  final lastValue = snapshot.docs.first.data()['value'];
  int currentValue = 0;
  if (lastValue != null) {
    currentValue = lastValue + 1;
  } else {
    currentValue = 1;
  }
  final newValue = '0'.padRight(11, '0');
  return newValue;
}
