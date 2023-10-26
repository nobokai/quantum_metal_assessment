import 'dart:async';

import 'package:flutter/material.dart';

import '../constant.dart';

class TopUpScreen extends StatefulWidget {
  const TopUpScreen({
    required this.goldPricePerGramUSDCurrency,
    required this.updateUserF,
    super.key,
  });

  final double goldPricePerGramUSDCurrency;
  final void Function(Map<String, dynamic>) updateUserF;

  @override
  State<TopUpScreen> createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  void updateUser() {
    var currentUser = Constant.tester();
    setState(() {
      currentUser.update(
        'paidAmt',
        (value) => double.parse(amtController.text),
      );
      currentUser.update(
        'purchasedAmt',
        (value) => double.parse(priceController.text),
      );
    });
    widget.updateUserF(currentUser);
  }

  void showSuccessDialog() {
    BuildContext? dialogContext;
    if (amtController.text.trim().isEmpty) {
      setState(() {
        errorText = 'This field cannot be empty';
      });
    }
    if (errorExist()) return;
    updateUser();
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (ctx) {
        dialogContext = ctx;
        return const AlertDialog(
          title: Text(
            'Transaction Successful',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          icon: Icon(
            Icons.check_circle_rounded,
            size: 100,
            color: Colors.greenAccent,
          ),
        );
      },
    );
    Timer(const Duration(seconds: 3), () {
      Navigator.of(dialogContext!, rootNavigator: true).pop();
    });
  }

  bool errorExist() {
    return errorText != null;
  }

  final amtController = TextEditingController();
  final priceController = TextEditingController(text: "0");
  bool errorFound = false;
  String? errorText;

  @override
  void dispose() {
    amtController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        titleTextStyle: const TextStyle(
          fontSize: 14,
          color: Colors.black,
        ),
        title: Text(
          'Topup'.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 16,
              ),
              child: Material(
                elevation: 0.0,
                borderRadius: const BorderRadius.all(
                  Radius.circular(4.0),
                ),
                // shadowColor: primaryColor,
                child: TextFormField(
                  controller: amtController,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      var parsedValue = double.parse(value);
                      var calculatedValue = parsedValue *
                          widget.goldPricePerGramUSDCurrency *
                          Constant.goldPricePerGramInUSD();
                      setState(() {
                        priceController.text = calculatedValue.toString();
                        errorText = null;
                      });
                    } else {
                      priceController.text = "0";
                    }
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    filled: true,
                    isDense: true,
                    errorText: errorText,
                    labelText: 'Amount of gold to purchase (in g)',
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 16,
              ),
              child: Material(
                elevation: 0.0,
                borderRadius: const BorderRadius.all(
                  Radius.circular(4.0),
                ),
                // shadowColor: primaryColor,
                child: TextFormField(
                  controller: priceController,
                  readOnly: true,
                  focusNode: FocusNode(canRequestFocus: false),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    isDense: true,
                    enabled: false,
                    labelText: 'Price (USD)',
                    prefixIcon: Icon(Icons.attach_money_outlined),
                    prefixIconColor: Colors.grey,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: showSuccessDialog,
              child: const Text('Top up'),
            ),
          ],
        ),
      ),
    );
  }
}
