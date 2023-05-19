import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:appbank/components/colors.dart';

class RecentTransactionsWidget extends StatelessWidget {
  final List<Tranzakcja> tranzakcje;

  const RecentTransactionsWidget({Key? key, required this.tranzakcje})
      : super(key: key);

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
                      color: AppColors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  TextButton(
                    onPressed: () => {},
                    child: Text(
                      'More',
                      style: GoogleFonts.leagueSpartan(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 186,
              child: ListView.separated(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: tranzakcje.length,
                itemBuilder: (context, index) {
                  final tranzakcja = tranzakcje[index];
                  final isNegative = tranzakcja.weather == 'false';
                  final amountText =
                      '${isNegative ? '-' : ''}${tranzakcja.amount ?? 'N/A'}\$';

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
                                '${tranzakcja.firstName ?? 'N/A'} ${tranzakcja.lastName ?? 'N/A'}',
                                style: GoogleFonts.leagueSpartan(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                tranzakcja.description ?? 'N/A',
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
                              color: isNegative
                                  ? AppColors.darkGrey
                                  : Color(0xff1fe9ad),
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(
                  height: 24,
                  color: AppColors.lightRed,
                  thickness: 3,
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
  final String? firstName;
  final String? lastName;
  final String? description;
  final String? amount;
  final String? weather;

  Tranzakcja(
      {this.firstName,
      this.lastName,
      this.description,
      this.amount,
      this.weather});
}
