import 'package:flutter/material.dart';

class TipsPage extends StatelessWidget {
  final List<String> tips = [
    "Go to bed and wake up at the same time every day.",
    "Avoid caffeine and heavy meals before sleep.",
    "Create a calming bedtime routine.",
    "Keep your bedroom cool and dark.",
    "Limit screen time 30 minutes before bed.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sleep Tips")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tips.length,
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: Colors.indigo[50],
            child: ListTile(
              leading: CircleAvatar(child: Text('${index + 1}')),
              title: Text(tips[index]),
            ),
          );
        },
      ),
    );
  }
}
