// lib/features/sleep_tracker/smart_alarm_page.dart
import 'package:flutter/material.dart';

class SmartAlarmPage extends StatefulWidget {
  const SmartAlarmPage({Key? key}) : super(key: key);

  @override
  State<SmartAlarmPage> createState() => _SmartAlarmPageState();
}

class _SmartAlarmPageState extends State<SmartAlarmPage> {
  TimeOfDay _selectedTime = TimeOfDay.now();

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("Smart Alarm"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              "Select Wake Up Time",
              style: TextStyle(color: Colors.white70, fontSize: 20),
            ),
            const SizedBox(height: 20),
            Text(
              _selectedTime.format(context),
              style: const TextStyle(fontSize: 36, color: Colors.deepPurpleAccent),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => _selectTime(context),
              icon: const Icon(Icons.access_time),
              label: const Text("Pick Time"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Smart alarm set!")),
                );
              },
              child: const Text("Set Smart Alarm"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
