import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appbank/pages/payments_screens.dart';
import 'package:firebase_auth/firebase_auth.dart';

void wykonajPrzelew(Transfer transfer) async {
  // try {
  //   final recipient = await sprawdzNumerKonta(transfer.accNumber);
  //   if (recipient == null) {
  //     throw Exception('Niepoprawny numer konta');
  //   }

  //   User? user = FirebaseAuth.instance.currentUser;
  //   String userId = user!.uid;
  //   final db = FirebaseFirestore.instance;

  //   // Use a transaction to ensure atomic updates
  //   final result = await db.runTransaction((transaction) async {
  //     // Check if the sender has sufficient funds
  //     final senderDoc =
  //         await transaction.get(db.collection('users').doc(userId));
  //     final senderData = senderDoc.data();
  //     if (senderData == null || !senderData.containsKey('account balance')) {
  //       throw Exception('Nie znaleziono pola "account balance"');
  //     }
  //     final senderBalance = double.parse(senderData['account balance']);

  //     if (senderBalance < transfer.amount) {
  //       throw Exception('Niewystarczające środki na koncie');
  //     }

  //     // Update the recipient's account balance
  //     final recipientRef = db.collection('users').doc(recipient['userId']);
  //     final recipientBalance = double.parse(recipient['account balance']);
  //     final newRecipientBalance = recipientBalance + transfer.amount;
  //     transaction.update(
  //         recipientRef, {'account balance': newRecipientBalance.toString()});

  //     // Update the sender's account balance
  //     final senderRef = db.collection('users').doc(transfer.sender);
  //     final newSenderBalance = senderBalance - transfer.amount;
  //     transaction
  //         .update(senderRef, {'account balance': newSenderBalance.toString()});

  //     // Add a new transaction to the transaction history
  //     final transactionsRef = db.collection('transactions').doc();

  //     transaction.set(transactionsRef, transfer.toJson());
  //   });

  //   if (result == null) {
  //     throw Exception('Błąd podczas aktualizacji kont');
  //   }
  // } catch (e) {
  //   throw Exception('Wystąpił błąd: $e');
  // }
  User? user = FirebaseAuth.instance.currentUser;
  String userId = user!.uid;
  final senderData =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();
  print(transfer.accNumber);
  final receivingData = await FirebaseFirestore.instance
      .collection('users')
      .where('Bank account number', isEqualTo: transfer.accNumber)
      .get(); // Call `get()` to execute the query and retrieve the `QuerySnapshot`.

  // if (receivingData.docs.isEmpty) {
  //   // Throw an error if the `QuerySnapshot` is empty (i.e., no documents were found).
  //   throw Exception('Niepoprawny numer konta');
  // }

  final receivingDoc =
      receivingData.docs.first.data(); // Get the data for the first document.

  senderData.data();
  String senderNewBalance =
      (double.parse(senderData['account balance']) - transfer.amount)
          .toString();

  String receivingBalance =
      (double.parse(receivingDoc['account balance']) + transfer.amount)
          .toString();

  await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .update({'account balance': senderNewBalance});
  await FirebaseFirestore.instance
      .collection('users')
      .doc(receivingData.docs.first.id)
      .update({'account balance': receivingBalance});
  transfer.sender = senderData['First Name'] + ' ' + senderData['Last Name'];
  await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .update({'transaction': transfer.toJson()});
  transfer.whether = false;
  await FirebaseFirestore.instance
      .collection('users')
      .doc(receivingData.docs.first.id)
      .update({'transaction': transfer.toJson()});
}

// Future<Map<String, dynamic>?> sprawdzNumerKonta(String numerKonta) async {
//   final db = FirebaseFirestore.instance;
//   try {
//     final snapshot = await db
//         .collection('users')
//         .where('Bank account number', isEqualTo: numerKonta)
//         .get();
//     print(snapshot);
//     if (snapshot.docs.isNotEmpty) {
//       return snapshot.docs.first.data() as Map<String, dynamic>;
//     }
//   } catch (e) {
//     throw Exception('Wystąpił błąd: $e');
//   }
//   return null;
// }
