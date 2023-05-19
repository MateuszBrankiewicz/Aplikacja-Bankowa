import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appbank/pages/payments_screens.dart';
import 'package:firebase_auth/firebase_auth.dart';

void wykonajPrzelew(Transfer transfer) async {
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
      throw Exception('Niepoprawny numer konta');
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
        "accNumber: ${transfer.accNumber.toString()}, firstName: ${senderData['First Name']}, lastName: ${senderData['Last Name']}, amount: ${transfer.amount.toString()}, wheter: false, title: ${transfer.title}, data: $data";

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
  } catch (e) {
    throw Exception('Wystąpił błąd: $e');
  }
}
