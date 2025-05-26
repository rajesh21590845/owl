import 'dart:convert';
import 'package:flutter/services.dart';
import '../../data/models/sleep_data_model.dart';

class SleepDataService {
    static Future<SleepData> loadSleepData() async {
        try {
            final String jsonString = await rootBundle.loadString('assets/data/sleep_data.json');
            print("Raw JSON: $jsonString"); // Helpful debug
            final Map<String, dynamic> jsonData = json.decode(jsonString);
            final data = SleepData.fromJson(jsonData);
            print("Parsed JSON successfully");
            return data;
        } catch (e, stacktrace) {
            print("❌ Error loading or parsing sleep data: $e");
            print("Stacktrace:\n$stacktrace");
            throw e;
        }
    }

}