import 'package:appbank/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecentTransactionsWidget extends StatelessWidget {
  final List<Tranzakcja> tranzakcje;

  RecentTransactionsWidget({required this.tranzakcje});

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
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
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
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  TextButton(
                    onPressed: () => {},
                    child: Text(
                      'More',
                      style: GoogleFonts.leagueSpartan(
                        color: white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Container(
              height: 186,
              child: Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    final tranzakcja = tranzakcje[index];
                    final isNegative = tranzakcja.amount < 0;
                    final amountText =
                        '${isNegative ? '-' : ''}${tranzakcja.amount.abs()}\$';

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
                                  '${tranzakcja.firstName} ${tranzakcja.lastName}',
                                  style: GoogleFonts.leagueSpartan(
                                    color: white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  tranzakcja.description,
                                  style: GoogleFonts.leagueSpartan(
                                    color: Colors.white70,
                                    fontSize: 20,
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
                                fontSize: 22,
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

class Tranzakcja {
  final String firstName;
  final String lastName;
  final String description;
  final double amount;

  Tranzakcja({
    required this.firstName,
    required this.lastName,
    required this.description,
    required this.amount,
  });
}
