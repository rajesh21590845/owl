import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class QuotesLoader {
  static Future<List<String>> loadQuotes() async {
    final String jsonString = await rootBundle.loadString('assets/quotes/sleep_quotes.json');
    final List<dynamic> jsonResponse = json.decode(jsonString);
    return jsonResponse.cast<String>();
  }
}
