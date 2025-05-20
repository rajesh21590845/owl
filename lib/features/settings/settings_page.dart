import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  final VoidCallback? onThemeToggle;

  SettingsPage({Key? key, this.onThemeToggle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            onThemeToggle?.call();
          },
          child: Text("Toggle Theme"),
        ),
      ),
    );
  }
}
