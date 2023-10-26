import 'dart:convert';

import 'package:flutter/material.dart';

//Third party library
import 'package:http/http.dart' as http;

import '../models/rate.dart';

class CurrencyRate with ChangeNotifier {
  Future<Rate> getCurrencyRate() async {
    try {
      const url = "https://api.qmdev.xyz/api/metals/rates";
      final response = await http.get(Uri.parse(url));
      switch (response.statusCode) {
        case 200:
          var responseData = json.decode(response.body);
          notifyListeners();
          return Rate.fromJson(responseData);
        default:
          throw Exception();
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
