import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  final _formKey = GlobalKey<FormState>();
  double sleepHours = 0;
  double sleepQuality = 5;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  List<double> analyticsData = [];

  late FlutterLocalNotificationsPlugin notificationsPlugin;

  @override
  void initState() {
    super.initState();
    notificationsPlugin = FlutterLocalNotificationsPlugin();
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    notificationsPlugin.initialize(initializationSettings);
  } 

  Future<void> _showMissedSleepNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'missed_sleep',
      'Sleep Alert',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const details = NotificationDetails(android: androidDetails);

    await notificationsPlugin.show(
      0,
      'Sleep Rebel Detected 😴',
      'Missing your bedtime again? Even your pillow misses you!',
      details,
    );
  }

  void _submitData() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        analyticsData.add(sleepHours);
      });
      if (sleepHours < 5) {
        _showMissedSleepNotification();
      }
    }
  }

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        isStart ? startTime = picked : endTime = picked;
      });
    }
  }

  double get averageSleep {
    if (analyticsData.isEmpty) return 0;
    return analyticsData.reduce((a, b) => a + b) / analyticsData.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sleep Analytics')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Left Form
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const Text("Enter Sleep Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Sleep Hours"),
                      validator: (value) {
                        if (value == null || value.isEmpty) return "Enter hours";
                        return null;
                      },
                      onChanged: (value) => sleepHours = double.tryParse(value) ?? 0,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () => _pickTime(true),
                          child: Text(startTime == null ? "Start Time" : "Start: ${startTime!.format(context)}"),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () => _pickTime(false),
                          child: Text(endTime == null ? "End Time" : "End: ${endTime!.format(context)}"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text("Sleep Quality: ${sleepQuality.round()}"),
                    Slider(
                      value: sleepQuality,
                      min: 1,
                      max: 10,
                      divisions: 9,
                      label: sleepQuality.round().toString(),
                      onChanged: (value) => setState(() => sleepQuality = value),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _submitData,
                      child: const Text("Save Data"),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20),
            // Right Chart
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Sleep Hours Chart", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  analyticsData.isEmpty
                      ? const Text("No data yet.")
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Daily Entries: ${analyticsData.length}"),
                            Text("Average Sleep: ${averageSleep.toStringAsFixed(1)} hrs"),
                          ],
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
