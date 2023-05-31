// ignore: file_names
import 'package:appbank/pages/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appbank/pages/payments_screens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:appbank/components/colors.dart';
import 'package:appbank/components/fonts.dart';

void _showCongratulationDialog(
    double amount, String name, BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: AppColors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Transaction finished ',
              style: AppFonts.h2,
            ),
            const Icon(
              Icons.check_circle,
              size: 16,
              color: AppColors.green,
            )
          ],
        ),
        content: Text(
          'You have successfully transfered $amount\$ to $name!',
          style: AppFonts.errorText,
        ),
        actions: [
          Center(
            child: TextButton(
              child: Text(
                'Continue',
                style: AppFonts.buttonText,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
            ),
          ),
        ],
      );
    },
  );
}

void wykonajPrzelew(Transfer transfer, BuildContext context) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    String userId = user!.uid;
    DateTime data = DateTime.now();
    final senderData =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    final receivingData = await FirebaseFirestore.instance
        .collection('users')
        .where('Bank account number', isEqualTo: transfer.accNumber)
        .get();

    if (receivingData.docs.isEmpty) {
      throw Exception('NNK');
    }

    final receivingDoc = receivingData.docs.first;
    final senderBalance = double.parse(senderData['account balance']);

    if (senderBalance < transfer.amount) {
      throw Exception('Niewystarczające środki na koncie');
    }

    final newSenderBalance = senderBalance - transfer.amount;
    final newReceivingBalance =
        double.parse(receivingDoc['account balance']) + transfer.amount;

    // Use a batched write to update multiple documents atomically
    WriteBatch batch = FirebaseFirestore.instance.batch();

    // Update sender's account balance
    batch.update(FirebaseFirestore.instance.collection('users').doc(userId),
        {'account balance': newSenderBalance.toString()});

    // Update recipient's account balance
    batch.update(
        FirebaseFirestore.instance.collection('users').doc(receivingDoc.id),
        {'account balance': newReceivingBalance.toString()});

    // Add a new transaction to the sender's transaction history
    String transactionEntry =
        "accNumber: ${transfer.accNumber.toString()}, firstName: ${senderData['First Name']}, lastName: ${senderData['Last Name']}, amount: ${transfer.amount.toString()}, wheter: false, title: ${transfer.title}, data: $data, recipient: ${transfer.recipient}";

    batch.update(FirebaseFirestore.instance.collection('users').doc(userId), {
      'transaction': FieldValue.arrayUnion([transactionEntry])
    });

    // Add a new transaction to the recipient's transaction history
    transactionEntry =
        "accNumber: ${transfer.accNumber.toString()}, firstName: ${senderData['First Name']}, lastName: ${senderData['Last Name']}, amount: ${transfer.amount.toString()}, wheter: true, title: ${transfer.title}, data: $data";

    batch.update(
        FirebaseFirestore.instance.collection('users').doc(receivingDoc.id), {
      'transaction': FieldValue.arrayUnion([transactionEntry])
    });

    // Commit the batched write
    await batch.commit();
    // ignore: use_build_context_synchronously
    _showCongratulationDialog(transfer.amount, transfer.recipient, context);
  } catch (e) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          title: Center(
            child: Text(
              'Transfer Error!',
              style: AppFonts.h2,
            ),
          ),
          content: Text(
            e.toString().contains('NNK')
                ? 'Wrong account number!'
                : 'Unknown error!',
            style: AppFonts.errorText,
          ),
          actions: [
            TextButton(
              child: Text(
                'OK',
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
  }
}
