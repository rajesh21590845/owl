import 'dart:convert';
import '../../data/models/sleep_entry_model.dart';
import 'local_storage_provider.dart';

class SleepDataProvider {
  static const String _key = "sleep_entries";

  static Future<List<SleepEntry>> getEntries() async {
    final jsonStr = await LocalStorageProvider.getString(_key);
    if (jsonStr == null) return [];
    final List decoded = json.decode(jsonStr);
    return decoded.map((e) => SleepEntry.fromJson(e)).toList();
  }

  static Future<void> saveEntry(SleepEntry entry) async {
    final entries = await getEntries();
    entries.add(entry);
    final jsonStr = json.encode(entries.map((e) => e.toJson()).toList());
    await LocalStorageProvider.saveString(_key, jsonStr);
  }

  static Future<void> clearAll() async {
    await LocalStorageProvider.remove(_key);
  }
}
