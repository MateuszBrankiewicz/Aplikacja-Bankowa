import 'package:appbank/components/colors.dart';
import 'package:appbank/components/fonts.dart';
import 'package:flutter/material.dart';

class CreditCardWidget extends StatelessWidget {
  final String cardHolder;
  final String cardNumber;
  final String expiryDate;
  final String currentBalance;

  const CreditCardWidget({
    Key? key,
    required this.cardHolder,
    required this.cardNumber,
    required this.expiryDate,
    required this.currentBalance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedcardNumber = cardNumber.replaceAllMapped(
        RegExp(r'^(\d{4})(\d{4})(\d{4})(\d{4})(\d+)$'),
        (Match match) =>
            '${match[1]} ${match[2]} ${match[3]} ${match[4]} ${match[5]}');

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: AppColors.black,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 5),
              spreadRadius: 8,
              blurRadius: 0,
              color: AppColors.darkGrey,
            )
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.credit_card,
                    color: AppColors.white,
                    size: 20,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    'BALANCE: $currentBalance\$',
                    style: AppFonts.cardH1,
                  ),
                ],
              ),
              Text(
                'VISA',
                style: AppFonts.cardH1,
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                formattedcardNumber,
                style: AppFonts.cardNumber,
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('CARDHOLDER', style: AppFonts.cardH2),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(cardHolder.toUpperCase(), style: AppFonts.cardH1),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'EXPIRES',
                    style: AppFonts.cardH2,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(expiryDate, style: AppFonts.cardH1),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
