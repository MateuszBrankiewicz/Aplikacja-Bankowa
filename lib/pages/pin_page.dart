import 'package:flutter/material.dart';

class PinInputScreen extends StatefulWidget {
  @override
  _PinInputScreenState createState() => _PinInputScreenState();
}

class _PinInputScreenState extends State<PinInputScreen> {
  final TextEditingController _pinController = TextEditingController();
  String _pin = "";

  void _submitPin() {
    setState(() {
      _pin = _pinController.text;
      _pinController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Wprowadzony PIN: $_pin")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wprowadź kod PIN"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _pinController,
                maxLength: 4,
                keyboardType: TextInputType.number,
                obscureText: true,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "Wprowadź kod PIN",
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitPin,
                child: Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
