import 'package:appbank/components/my_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:appbank/components/transactions.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:appbank/pages/payments_screens.dart';
import 'package:appbank/components/colors.dart';
import 'package:appbank/components/fonts.dart';

class UserData {
  final String firstName;
  final String lastName;
  final String numAcc;
  final String expires;
  final String balance;
  // List<String> transaction;

  UserData({
    required this.firstName,
    required this.lastName,
    required this.numAcc,
    required this.expires,
    required this.balance,
    // required this.transaction,
  });
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  UserData? userData;
  String userId = '';

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _handleUserDataChanged(UserData? newData) {
    setState(() {
      userData = newData;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      HomeScreen(
        userId: '',
        onUserDataChanged: _handleUserDataChanged,
      ),
      PaymentsScreen(userData: userData),
      HistoryScreen(),
      ProfileScreen(
        userData: userData,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.white,
        selectedFontSize: 18,
        iconSize: 28,
        unselectedFontSize: 18,
        selectedLabelStyle:
            GoogleFonts.leagueSpartan(fontWeight: FontWeight.bold),
        unselectedLabelStyle:
            GoogleFonts.leagueSpartan(fontWeight: FontWeight.w500),
        unselectedItemColor: AppColors.darkGrey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Payments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.darkRed,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final String userId;
  final void Function(UserData?) onUserDataChanged;

  const HomeScreen({
    Key? key,
    required this.userId,
    required this.onUserDataChanged,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserData? userData;

  List<String> accNumber = [];
  List<String> firstNameT = [];
  List<String> lastNameT = [];
  List<String> amount = [];
  List<String> weather = [];
  List<String> titleT = [];
  List<String> data = [];
  List<dynamic> transaction = [];

  @override
  void initState() {
    super.initState();
    getUserData(widget.userId);
  }

  Future<void> getUserData(String userId) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      String temp = '';
      List<String> czesci = [];
      List<String> czesci2 = [];

      final userDataSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDataSnapshot.exists) {
        final userDoc = userDataSnapshot.data() as Map<String, dynamic>;
        setState(() {
          userData = UserData(
            firstName: userDoc['First Name'],
            lastName: userDoc['Last Name'],
            numAcc: userDoc['Bank account number'],
            expires: userDoc['expires'],
            balance: userDoc['account balance'],
            // transaction: userDoc['transaction'],
          );
          transaction = userDoc['transaction'];
          List<String> transactions = transaction.toString().split(',');

          for (int i = 0; i < transactions.length; i++) {
            String temp = transactions[i];
            List<String> czesci = temp.split(':');

            if (czesci.length >= 2) {
              String key = czesci[0].trim();
              String value = czesci.sublist(1).join(':').trim();

              switch (key) {
                case 'accNumber':
                  accNumber.add(value);
                  break;
                case 'firstName':
                  firstNameT.add(value);
                  break;
                case 'lastName':
                  lastNameT.add(value);
                  break;
                case 'amount':
                  amount.add(value);
                  break;
                case 'wheter':
                  weather.add(value);
                  break;
                case 'title':
                  titleT.add(value);
                  break;
                case 'data':
                  data.add(value);
                  break;
                default:
                  break;
              }
            }
          }
          if (accNumber.length < 3) {
            int remainingLength = 3 - accNumber.length - 1;
            for (int i = 0; i < remainingLength; i++) {
              accNumber.add('');
              firstNameT.add('');
              lastNameT.add('');
              amount.add('0');
              weather.add('');
              titleT.add('');
              data.add('');
            }
          }
        });
      } else {
        print('User with ID $userId does not exist.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    if (userData == null) {
      return const CircularProgressIndicator();
    }

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0, 0.546),
          end: Alignment(0, 1),
          colors: <Color>[AppColors.lightRed, AppColors.darkRed],
          stops: <double>[0, 1],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              './lib/images/home_bg.png',
              fit: BoxFit.fitWidth,
            ),
          ),
          Positioned(
            left: 77 * fem,
            top: 13 * fem,
            child: Image.asset(
              './lib/images/home_logo.png',
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 60,
              ),
              //Credit Card
              Padding(
                  padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                  child: CreditCardWidget(
                    currentBalance: '${userData?.balance}',
                    cardHolder: '${userData?.firstName} ${userData?.lastName}',
                    cardNumber: '${userData?.numAcc}',
                    expiryDate: '${userData?.expires}',
                  )),
              SizedBox(
                height: 15,
              ),
              //Payment Methods
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 32 * fem,
                  vertical: 14 * fem,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PaymentShortcut(
                      size: 66,
                      image: './lib/images/blik.png',
                      label: 'BLIK',
                      destPage: const BLIKPayment(),
                    ),
                    PaymentShortcut(
                      size: 66,
                      image: './lib/images/przelew.png',
                      label: 'Transfer',
                      destPage: TransferPayment(),
                    ),
                    PaymentShortcut(
                      size: 66,
                      image: './lib/images/topup.png',
                      label: 'Top up',
                      destPage: const TopAccount(),
                    ),
                  ],
                ),
              ),
              //TO DO !!!!

              // RecentTransactionsWidget(
              //   tranzakcje: (firstNameT.isNotEmpty &&
              //           lastNameT.isNotEmpty &&
              //           titleT.isNotEmpty &&
              //           amount.isNotEmpty)
              //       ? [
              //           Tranzakcja(
              //             firstName: firstNameT[0],
              //             lastName: lastNameT[0],
              //             description: titleT[0],
              //             amount: double.parse(amount[0]),
              //           ),
              //           Tranzakcja(
              //             firstName: firstNameT[1],
              //             lastName: lastNameT[1],
              //             description: titleT[1],
              //             amount: double.parse(amount[1]),
              //           ),
              //           Tranzakcja(
              //             firstName: firstNameT[2],
              //             lastName: lastNameT[2],
              //             description: titleT[2],
              //             amount: double.parse(amount[2]),
              //           ),
              //         ]
              //       : [],
              // ),
            ],
          ),
        ],
      ),
    );
  }
}

//IN PROGRESS
class PaymentsScreen extends StatelessWidget {
  final UserData? userData;

  const PaymentsScreen({Key? key, this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (userData == null) {
      return const CircularProgressIndicator();
    }

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0, 0.546),
          end: Alignment(0, 1),
          colors: <Color>[AppColors.lightRed, AppColors.darkRed],
          stops: <double>[0, 1],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            alignment: Alignment.centerLeft,
            child: Text(
              'Payments',
              style: GoogleFonts.leagueSpartan(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
          ),
          Container(
            color: AppColors.grey.withAlpha(50),
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PaymentShortcut(
                    size: 70,
                    image: './lib/images/blik.png',
                    label: 'BLIK',
                    destPage: BLIKPayment(),
                  ),
                  PaymentShortcut(
                    size: 70,
                    image: './lib/images/przelew.png',
                    label: 'Transfer',
                    destPage: TransferPayment(),
                  ),
                  PaymentShortcut(
                    size: 70,
                    image: './lib/images/topup.png',
                    label: 'Top up',
                    destPage: TopAccount(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 60,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
            child: CreditCardWidget(
              currentBalance: '${userData?.balance}',
              cardHolder: '${userData?.firstName} ${userData?.lastName}',
              cardNumber: '${userData?.numAcc}',
              expiryDate: '${userData?.expires}',
            ),
          )
        ],
      ),
    );
  }
}

//History page
class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> tranzakcje = [];
  List<String> accNumber = [];
  List<dynamic> transaction = [];
  List<String> firstNameT = [];
  List<String> lastNameT = [];
  List<String> amount = [];
  List<String> weather = [];
  List<String> titleT = [];
  List<String> data = [];
  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;

      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      tranzakcje.clear();
      if (userData.exists) {
        final userDoc = userData.data();

        transaction = userDoc?['transaction'];
        String transactionString = transaction.toString();
        List<String> transactions = transactionString.split(',');

        for (int i = 0; i < transactions.length; i++) {
          String temp = transactions[i];
          List<String> czesci = temp.split(':');

          if (czesci.length >= 2) {
            String key = czesci[0].trim();
            String value = czesci.sublist(1).join(':').trim();

            switch (key) {
              case 'accNumber':
                accNumber.add(value);
                break;
              case 'firstName':
                firstNameT.add(value);
                break;
              case 'lastName':
                lastNameT.add(value);
                break;
              case 'amount':
                amount.add(value);
                break;
              case 'weather':
                weather.add(value);
                break;
              case 'title':
                titleT.add(value);
                break;
              case 'data':
                data.add(value);
                break;
              default:
                break;
            }
          }
        }

        for (int i = 0; i < transactions.length; i++) {
          if (i < accNumber.length &&
              i < firstNameT.length &&
              i < lastNameT.length &&
              i < amount.length &&
              i < weather.length &&
              i < titleT.length &&
              i < data.length) {
            Map<String, dynamic> transactionMap = {
              'type': 'przelew', // Add the appropriate value for 'type' key
              'name': firstNameT[i] + lastNameT[i],
              'description': titleT[i],
              'account': accNumber[i],
              'amount': amount[i],
              'date': data[i],
            };
            print(tranzakcje);
            setState(() {
              tranzakcje.add(transactionMap);
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0, 0.546),
          end: Alignment(0, 1),
          colors: <Color>[AppColors.lightRed, AppColors.darkRed],
          stops: <double>[0, 1],
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(28, 28, 28, 22),
            alignment: Alignment.centerLeft,
            child: Text(
              'History',
              style: GoogleFonts.leagueSpartan(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tranzakcje.length,
              itemBuilder: (context, index) {
                final tranzakcja = tranzakcje[index];
                final currentDate = DateTime.parse(tranzakcja['date']);
                final formatter = DateFormat('yyyy-MM-dd');
                final formattedDate = formatter.format(currentDate);
                final isNegative = tranzakcja['amount'] < 0;
                final amountText =
                    '${isNegative ? '-' : ''}${tranzakcja['amount'].abs()}\$';
                bool showDivider = true;

                if (index > 0) {
                  final previousDate =
                      DateTime.parse(tranzakcje[index - 1]['date']);
                  showDivider = currentDate != previousDate;
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (showDivider)
                      Container(
                        color: AppColors.grey,
                        padding: EdgeInsets.fromLTRB(32, 8, 32, 8),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          formattedDate,
                          style: GoogleFonts.leagueSpartan(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: AppColors.darkGrey,
                          ),
                        ),
                      ),
                    Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: AppColors.grey,
                            width: 1,
                          ),
                          bottom: BorderSide(
                            color: AppColors.grey,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            'lib/images/${tranzakcja['type']}.png',
                            width: 25,
                            height: 25,
                          ),
                          SizedBox(width: 16.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tranzakcja['name'],
                                style: GoogleFonts.leagueSpartan(
                                  fontSize: 24,
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                tranzakcja['description'],
                                style: GoogleFonts.leagueSpartan(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.white,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                tranzakcja['account'],
                                style: GoogleFonts.leagueSpartan(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.grey,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Text(
                            amountText,
                            style: GoogleFonts.leagueSpartan(
                              color: isNegative
                                  ? AppColors.white
                                  : Color(0xff1fe9ad),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key, this.userData}) : super(key: key);
  final UserData? userData;

  @override
  Widget build(BuildContext context) {
    if (userData == null) {
      return const CircularProgressIndicator();
    }
    return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0, 0.546),
            end: Alignment(0, 1),
            colors: <Color>[AppColors.lightRed, AppColors.darkRed],
            stops: <double>[0, 1],
          ),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.fromLTRB(28, 28, 28, 22),
            alignment: Alignment.centerLeft,
            child: Text('Profile', style: AppFonts.h1),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${userData?.firstName} ${userData?.lastName}',
                      style: AppFonts.h2),
                  SizedBox(height: 8),
                  Text('Account Number: ${userData?.numAcc}',
                      style: AppFonts.p),
                  SizedBox(height: 16),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32.0),
                    child: CustomButton(text: 'Logout', onPressed: () => {}),
                  )
                ],
              ),
            ),
          ),
        ]));
  }
}

//Credit Card
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
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: AppColors.black,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
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
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('CARDHOLDER', style: AppFonts.cardH2),
                  SizedBox(
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
                  SizedBox(
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

class PaymentShortcut extends StatelessWidget {
  final String image;
  final String label;
  final double size;
  final Widget destPage;

  PaymentShortcut({
    Key? key,
    required this.image,
    required this.size,
    required this.label,
    required this.destPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return GestureDetector(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destPage),
        )
      },
      child: Column(
        children: [
          Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: AppColors.darkGrey,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Center(
                child: Image(
                  image: AssetImage(image),
                  width: size / 2.5,
                  height: size / 2.5,
                ),
              )),
          SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.leagueSpartan(
              fontSize: 18 * ffem,
              fontWeight: FontWeight.w500,
              height: 0.92 * ffem / fem,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
