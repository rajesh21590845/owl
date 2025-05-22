import 'package:flutter/material.dart';

class SleepHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dummyHistory = List.generate(7, (index) {
      return {
        "date": "May ${15 + index}, 2025",
        "duration": "${6 + index % 3} hrs ${30 + index % 2 * 15} mins"
      };
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Sleep History")),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: dummyHistory.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final item = dummyHistory[index];
          return ListTile(
            leading: const Icon(Icons.nights_stay),
            title: Text(item["date"]!),
            subtitle: Text("Duration: ${item["duration"]}"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          );
        },
      ),
    );
  }
}
