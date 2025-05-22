import 'package:flutter/material.dart';

class QuotesPage extends StatelessWidget {
  final List<String> quotes = [
    "“Sleep is the best meditation.” — Dalai Lama",
    "“A good laugh and a long sleep are the best cures.”",
    "“Sleep is the golden chain that ties health and our bodies together.”",
    "“Your future depends on your dreams, so go to sleep.”",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sleep Quotes")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: quotes.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                quotes[index],
                style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
            ),
          );
        },
      ),
    );
  }
}
