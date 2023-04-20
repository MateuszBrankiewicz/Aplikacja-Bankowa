import 'package:appbank/pages/pin_page.dart';
import 'package:flutter/material.dart';
import 'package:appbank/components/logo.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:appbank/components/transactions.dart';

const white = Color(0xfffefefe);
const lightRed = Color(0xffc24646);
const darkRed = Color(0xff953333);
const grey = Color(0x99fefefe);
const darkGrey = Color(0xff395263);

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    PaymentsScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: white,
        selectedFontSize: 15,
        iconSize: 28,
        unselectedFontSize: 15,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
        unselectedItemColor: darkGrey,
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
        selectedItemColor: darkRed,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment(0, 0.546),
        end: Alignment(0, 1),
        colors: <Color>[lightRed, darkRed],
        stops: <double>[0, 1],
      )),
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
            children: [
              const SizedBox(
                height: 80,
              ),

              //Credit Card
              const Padding(
                  padding: EdgeInsets.fromLTRB(36, 0, 36, 0),
                  child: CreditCardWidget(
                    cardHolder: "12",
                    cardNumber: "1234",
                    expiryDate: "2025",
                  )),

              //Payment Methods
              Padding(
                padding: EdgeInsets.all(16 * fem),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    PaymentShortcut(
                        image: './lib/images/blik.png', label: 'BLIK'),
                    PaymentShortcut(
                        image: './lib/images/przelew.png', label: 'Transfer'),
                    PaymentShortcut(
                        image: './lib/images/contactless.png',
                        label: 'Contactless'),
                    PaymentShortcut(
                        image: './lib/images/more.png', label: 'More'),
                  ],
                ),
              ),
              RecentTransactionsWidget(
                transactions: [
                  Transaction(
                    firstName: 'John',
                    lastName: 'Doe',
                    description: 'Grocery shopping',
                    amount: -50.0,
                  ),
                  Transaction(
                    firstName: 'Jane',
                    lastName: 'Doe',
                    description: 'Gas refill',
                    amount: -30.0,
                  ),
                  Transaction(
                    firstName: 'Alice',
                    lastName: 'Smith',
                    description: 'Salary',
                    amount: 1000.0,
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

class PaymentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Payments Screen'),
    );
  }
}

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('History Screen'),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Profile Screen'),
    );
  }
}

//Credit Card
class CreditCardWidget extends StatelessWidget {
  final String cardHolder;
  final String cardNumber;
  final String expiryDate;

  const CreditCardWidget({
    Key? key,
    required this.cardHolder,
    required this.cardNumber,
    required this.expiryDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(1.038, -1),
          end: Alignment(-0.805, 0.943),
          colors: <Color>[Color(0x99020202), Color(0xce000000)],
          stops: <double>[0, 0.87],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.credit_card, color: Colors.white),
              Text(
                'VISA',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            cardNumber,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Card Holder',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 4),
                  Text(
                    cardHolder.toUpperCase(),
                    style: TextStyle(
                      color: white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Expires',
                    style: TextStyle(color: white),
                  ),
                  SizedBox(height: 4),
                  Text(
                    expiryDate,
                    style: TextStyle(
                      color: white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
  final VoidCallback? onTap;

  const PaymentShortcut({
    Key? key,
    required this.image,
    required this.label,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: darkGrey,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Center(
                child: Image(
                  image: AssetImage(image),
                  width: 22,
                  height: 22,
                ),
              )),
          SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.leagueSpartan(
              fontSize: 18 * ffem,
              fontWeight: FontWeight.w500,
              height: 0.92 * ffem / fem,
              color: white,
            ),
          ),
        ],
      ),
    );
  }
}
