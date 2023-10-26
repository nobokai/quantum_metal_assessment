class Constant {
  static Map<String, dynamic> tester() {
    return {
      "name": 'Mr. Tester',
      "purchasedAmt": 0.0,
      "paidAmt": 0.0,
    };
  }

  static double goldPricePerGramInUSD() {
    return 62.29;
  }

  static double gramsPerOunceInGold() {
    return 31.1034768;
  }

  static const remarks = [
    '1 ounce = 31.1034768 grams',
    'Gold price per gram = 62.29 USD'
  ];
}
