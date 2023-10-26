import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quantum_metal_assessment/screens/topup.dart';

import '../constant.dart';
import '../models/rate.dart';
import '../providers/rates.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> getCurrencyRate() async {
    rate = await Provider.of<CurrencyRate>(context, listen: false)
        .getCurrencyRate();
    if (rate == Rate.create()) return;
    setState(() {
      isLoading = false;
    });
  }

  List<TableRow> tableRowContents() {
    return rate.rates.entries.map(
      (e) {
        if (e.key == 'USD') {
          setState(() {
            goldPricePerGramUSDCurrency =
                e.value / Constant.gramsPerOunceInGold();
          });
        }
        var goldPricePerGramCurrency = e.value / Constant.gramsPerOunceInGold();
        return TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                e.key,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(e.value.toString()),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(goldPricePerGramCurrency.toString()),
            ),
          ],
        );
      },
    ).toList();
  }

  void showInfoDialog() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    'REMARKS',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.announcement_rounded,
                    color: Colors.red,
                    size: 20,
                  )
                ],
              ),
            ),
            const Divider(
              height: 0,
            ),
            ...Constant.remarks.asMap().entries.map(
                  (e) => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('${e.key + 1}. ${e.value}'),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  void updateUser(Map<String, dynamic> user) {
    setState(() {
      print("user: $user");
      tester.update(
        "purchasedAmt",
        (value) => tester['purchasedAmt'] + user['purchasedAmt'],
      );
      tester.update(
        "paidAmt",
        (value) => tester['paidAmt'] + user['paidAmt'],
      );
    });
  }

  String formattedDoubleValue(var value, [int numOfDigits = 3]) {
    if (value is double) {
      return value.toStringAsFixed(numOfDigits);
    }
    return value;
  }

  Rate rate = Rate.create();
  bool isLoading = true;
  double goldPricePerGramUSDCurrency = 0.0;
  var tester = Constant.tester();
  dynamic currentOrientation;

  @override
  void initState() {
    getCurrencyRate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var maxWidth = MediaQuery.of(context).size.width;
    currentOrientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        titleTextStyle: const TextStyle(
          fontSize: 14,
          color: Colors.black,
        ),
        title: Text(
          'Gold price (per gram)'.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/icons/icons8-gold-64.png',
            height: 16,
            width: 16,
          ),
        ),
        actions: [
          IconButton(
            onPressed: showInfoDialog,
            icon: const Icon(Icons.error),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => TopUpScreen(
                    goldPricePerGramUSDCurrency: goldPricePerGramUSDCurrency,
                    updateUserF: updateUser,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: SizedBox(
              width: maxWidth * 0.5,
              child: const LinearProgressIndicator(),
            ))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    top: 16.0,
                    right: 16.0,
                  ),
                  child: Card(
                    margin: EdgeInsets.zero,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: const CircleAvatar(
                              child: Icon(Icons.person_rounded),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            flex: 8,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  tester['name'].toString().toUpperCase(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Gotham',
                                    fontSize: 18,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      flex: 4,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            height: 35,
                                            width: 35,
                                            child: Image.asset(
                                              "assets/icons/icons8-gold-48.png",
                                            ),
                                          ),
                                          const Text(" : "),
                                          Expanded(
                                            child: Text(
                                              formattedDoubleValue(
                                                tester['purchasedAmt'],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child: Row(
                                        children: [
                                          const Text('Paid Amount : '),
                                          Expanded(
                                            child: Text(
                                              '\$ ${formattedDoubleValue(
                                                tester['paidAmt'],
                                                2,
                                              )}',
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: SingleChildScrollView(
                        physics: currentOrientation == Orientation.portrait
                            ? null
                            : const NeverScrollableScrollPhysics(),
                        scrollDirection:
                            currentOrientation == Orientation.portrait
                                ? Axis.horizontal
                                : Axis.vertical,
                        child: Table(
                          border: TableBorder.all(),
                          defaultColumnWidth:
                              currentOrientation == Orientation.portrait
                                  ? const IntrinsicColumnWidth()
                                  : const FlexColumnWidth(),
                          children: [
                            const TableRow(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                    'BASE',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                    'USD',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(),
                              ],
                            ),
                            const TableRow(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                    'CURRENCY',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                    'CONVERSION RATE',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                    'GOLD PRICE PER GRAM',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            ...tableRowContents(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
