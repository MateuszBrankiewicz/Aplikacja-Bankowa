import 'package:appbank/components/my_button.dart';
import 'package:appbank/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:appbank/components/transactions.dart';
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
    // required transaction,
    // required this.transaction,
  });
}

class TransactionData {
  final List<String> accNumber;
  final List<String> firstNameT;
  final List<String> lastNameT;
  final List<String> amount;
  final List<String> weather;
  final List<String> titleT;
  final List<String> data;
  final int transactionSize;
  final List<String> recipient;

  TransactionData(
      {required this.accNumber,
      required this.firstNameT,
      required this.lastNameT,
      required this.amount,
      required this.weather,
      required this.titleT,
      required this.data,
      required this.transactionSize,
      required this.recipient});
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  UserData? userData;
  String userId = '';
  TransactionData? transactionData;
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

  void _handleTransactionDataChanged(TransactionData? newTransaction) {
    setState(() {
      transactionData = newTransaction;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      HomeScreen(
        userId: '',
        onUserDataChanged: _handleUserDataChanged,
        transactionDataChanged: _handleTransactionDataChanged,
      ),
      PaymentsScreen(userData: userData),
      HistoryScreen(transactionData: transactionData),
      ProfileScreen(
        userData: userData,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: widgetOptions.elementAt(_selectedIndex),
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
  final void Function(TransactionData?) transactionDataChanged;
  const HomeScreen(
      {Key? key,
      required this.userId,
      required this.onUserDataChanged,
      required this.transactionDataChanged})
      : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserData? userData;
  TransactionData? transactionData;
  List<String> nameToTransaction = [];
  @override
  void initState() {
    super.initState();
    getUserData(widget.userId);
  }

  Future<void> getUserData(String userId) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String userId = user.uid;
      final userDataSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDataSnapshot.exists) {
        final userDoc = userDataSnapshot.data() as Map<String, dynamic>;
        UserData userData = UserData(
          firstName: userDoc['First Name'],
          lastName: userDoc['Last Name'],
          numAcc: userDoc['Bank account number'],
          expires: userDoc['expires'],
          balance: userDoc['account balance'],
        );
        List<dynamic> temp = userDoc['transaction'];
        List<String> transactions = temp.toString().split(',');
        int sizeTransaction = temp.length;
        List<String> accNumberList = [];
        List<String> firstNameTList = [];
        List<String> lastNameTList = [];
        List<String> amountList = [];
        List<String> weatherList = [];
        List<String> titleTList = [];
        List<String> dataList = [];
        List<String> recipient = [];

        for (int i = transactions.length - 1; i >= 0; i--) {
          String temp = transactions[i];

          temp = temp.replaceAll('[', '');
          temp = temp.replaceAll(']', '');
          List<String> czesci = temp.split(':');

          if (czesci.length >= 2) {
            String key = czesci[0].trim();
            String value = czesci.sublist(1).join(':').trim();
            switch (key) {
              case 'accNumber':
                accNumberList.add(value);
                break;
              case 'firstName':
                firstNameTList.add(value);
                break;
              case 'lastName':
                lastNameTList.add(value);
                break;
              case 'amount':
                amountList.add(value);
                break;
              case 'wheter':
                weatherList.add(value);
                break;
              case 'title':
                titleTList.add(value);
                break;
              case 'data':
                value = value.split('.')[0];
                dataList.add(value);
                break;
              case 'recipient':
                recipient.add(value);
                break;
              default:
                break;
            }
          }
        }

        if (accNumberList.length < 3) {
          int remainingLength = 3 - accNumberList.length;
          for (int i = 0; i < remainingLength; i++) {
            accNumberList.add('');
            firstNameTList.add('');
            lastNameTList.add('');
            amountList.add('');
            weatherList.add('');
            titleTList.add('');
            recipient.add('');
            dataList.add('0000-00-00 00:00:00');
          }
        }

        TransactionData transactionData = TransactionData(
            accNumber: accNumberList,
            firstNameT: firstNameTList,
            lastNameT: lastNameTList,
            amount: amountList,
            weather: weatherList,
            titleT: titleTList,
            data: dataList,
            transactionSize: sizeTransaction,
            recipient: recipient);
        setState(() {
          this.userData = userData;
          this.transactionData = transactionData;
        });
        transactionScreen(transactionData, nameToTransaction);
        widget.onUserDataChanged(userData);
        widget.transactionDataChanged(transactionData);
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
                  currentBalance: userData!.balance,
                  cardHolder: '${userData!.firstName} ${userData!.lastName}',
                  cardNumber: userData!.numAcc,
                  expiryDate: userData!.expires,
                ),
              ),
              const SizedBox(
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
                      destPage: TransferPayment(
                        balance: userData!.balance,
                      ),
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

              RecentTransactionsWidget(
                tranzakcje: [
                  Tranzakcja(
                      name: nameToTransaction[0],
                      description: transactionData?.titleT[0],
                      amount: transactionData?.amount[0],
                      weather: transactionData?.weather[0]),
                  Tranzakcja(
                      name: nameToTransaction[1],
                      description: transactionData?.titleT[1],
                      amount: transactionData?.amount[1],
                      weather: transactionData?.weather[1]),
                  Tranzakcja(
                      name: nameToTransaction[2],
                      description: transactionData?.titleT[2],
                      amount: transactionData?.amount[2],
                      weather: transactionData?.weather[2]),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  double parseAmount(String? value) {
    try {
      return double.parse(value ?? '0');
    } catch (e) {
      return 0;
    }
  }

  void transactionScreen(
      TransactionData transactionData, List<String> nameTotransaction) {
    for (int i = 0; i < 3; i++) {
      if (transactionData.weather[i] == "true") {
        nameToTransaction.add(
            '${transactionData.firstNameT[i]} ${transactionData.lastNameT[i]}');
      } else {
        nameToTransaction.add(transactionData.recipient[i]);
      }
    }
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
                    destPage: TransferPayment(balance: userData!.balance),
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
class HistoryScreen extends StatelessWidget {
  TransactionData? transactionData;
  List<dynamic> tranzakcje = [];

  HistoryScreen({Key? key, this.transactionData}) : super(key: key) {
    createMap();
  }

  void createMap() {
    final int dataLength = transactionData?.firstNameT.length ?? 0;
    for (int i = 0; i < dataLength; i++) {
      final String firstName = transactionData?.firstNameT[i] ?? '';
      final String title = transactionData?.titleT[i] ?? '';
      final String accNumber = transactionData?.accNumber[i] ?? '';
      final String amount = transactionData?.amount[i] ?? '';
      final String data = transactionData?.data[i] ?? '';
      final String weather = transactionData?.weather[i] ?? '';
      final String recipient = transactionData?.recipient[i] ?? '';
      Map<String, dynamic> transactionMap = {
        'type': 'przelew', // Add the appropriate value for 'type' key
        'name': firstName,
        'description': title,
        'account': accNumber,
        'amount': amount,
        'data': data,
        'weather': weather,
        'recipient': recipient
      };
      tranzakcje.add(transactionMap);
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
              itemCount: transactionData?.transactionSize,
              itemBuilder: (context, index) {
                final tranzakcja = tranzakcje[index];
                final dateString = tranzakcja['data'];
                final formattedDateString = dateString.replaceAll(' ', 'T');
                final name;
                final currentDate = DateTime.parse(formattedDateString);
                String formattedDate = currentDate.toString().substring(0, 10);

                final isNegative = tranzakcja['weather'] == 'false';

                final amountText =
                    '${isNegative ? '-' : ''}${tranzakcja['amount'] ?? 'N/A'}\$';
                if (tranzakcja['weather'] == 'false') {
                  name = tranzakcja['recipient'];
                } else {
                  name = tranzakcja['name'];
                }
                bool showDivider = true;

                if (index > 0) {
                  final previousDate =
                      DateTime.parse(tranzakcje[index - 1]['data']);
                  final previousDateStr =
                      previousDate.toString().substring(0, 10);
                  showDivider = formattedDate != previousDateStr;
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (showDivider)
                      Container(
                        color: AppColors.grey,
                        padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          formattedDate.substring(0, 10),
                          style: GoogleFonts.leagueSpartan(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: AppColors.darkGrey,
                          ),
                        ),
                      ),
                    Container(
                      padding: const EdgeInsets.all(16.0),
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
                          const SizedBox(width: 16.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: GoogleFonts.leagueSpartan(
                                  fontSize: 24,
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                tranzakcja['description'],
                                style: GoogleFonts.leagueSpartan(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.white,
                                ),
                              ),
                              const SizedBox(height: 8.0),
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
                          const Spacer(),
                          Text(
                            amountText,
                            style: GoogleFonts.leagueSpartan(
                              color: isNegative
                                  ? AppColors.white
                                  : AppColors.green,
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
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(
                    color: AppColors.white,
                    thickness: 1,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: AppColors.grey,
                            borderRadius: BorderRadius.circular(50)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                              width: 40, height: 40, "./lib/images/user.png"),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                            '${userData?.firstName} ${userData?.lastName}',
                            style: AppFonts.cardNumber),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text('Account Balance: ${userData?.balance}\$',
                      style: AppFonts.p),
                  const SizedBox(height: 8),
                  Text('Account Number: ${userData?.numAcc}',
                      style: AppFonts.p),
                  const SizedBox(height: 8),
                  Text('Credit card expire date: ${userData?.expires}r.',
                      style: AppFonts.p),
                  const SizedBox(height: 34),
                  const Divider(
                    color: AppColors.white,
                    thickness: 1,
                  ),
                  const SizedBox(height: 80),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32.0),
                    child: CustomButton(
                        text: 'Logout', onPressed: () => {signOut(context)}),
                  )
                ],
              ),
            ),
          ),
        ]));
  }

  void signOut(BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await auth.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    } catch (e) {
      print('Wystąpił błąd podczas wylogowywania: $e');
    }
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
