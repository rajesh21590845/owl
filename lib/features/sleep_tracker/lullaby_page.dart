import 'package:flutter/material.dart';

class LullabyPage extends StatelessWidget {
  final List<String> lullabies = [
    "Rainfall Ambience 🌧️",
    "Forest Sounds 🌲",
    "Ocean Waves 🌊",
    "Piano Lullaby 🎹",
    "White Noise 🎧",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lullabies")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: lullabies.length,
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.music_note),
              title: Text(lullabies[index]),
              trailing: const Icon(Icons.play_arrow),
              onTap: () {}, // Later: play lullaby
            ),
          );
        },
      ),
    );
  }
}
