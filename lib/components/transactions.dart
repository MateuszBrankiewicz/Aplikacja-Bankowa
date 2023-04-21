import 'package:appbank/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecentTransactionsWidget extends StatelessWidget {
  final List<Transaction> transactions;

  RecentTransactionsWidget({required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(1.058, -0.003),
            end: Alignment(-0.933, -0.003),
            colors: <Color>[Color(0x70f7f7f7), Color(0x35f7f7f7)],
            stops: <double>[0.073, 0.536],
          ),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Last Transactions',
                    style: GoogleFonts.leagueSpartan(
                      color: white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  Text(
                    'More',
                    style: GoogleFonts.leagueSpartan(
                      color: white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 190,
              child: Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    final isNegative = transaction.amount < 0;
                    final amountText =
                        '${isNegative ? '-' : ''}${transaction.amount.abs()}\$';

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${transaction.firstName} ${transaction.lastName}',
                                  style: GoogleFonts.leagueSpartan(
                                    color: white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  transaction.description,
                                  style: GoogleFonts.leagueSpartan(
                                    color: Colors.white70,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              amountText,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color:
                                    isNegative ? darkGrey : Color(0xff1fe9ad),
                                fontWeight: FontWeight.bold,
                                fontSize: 21,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Divider(
                    height: 24,
                    color: lightRed,
                    thickness: 3,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Transaction {
  final String firstName;
  final String lastName;
  final String description;
  final double amount;

  Transaction({
    required this.firstName,
    required this.lastName,
    required this.description,
    required this.amount,
  });
}
