import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;

class QuoteHelper {
  static Future<String> getRandomQuote() async {
    final jsonStr = await rootBundle.loadString('assets/quotes/quotes.json');
    final List quotes = json.decode(jsonStr);
    final random = Random();
    return quotes[random.nextInt(quotes.length)];
  }
}
