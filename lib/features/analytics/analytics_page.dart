import 'package:flutter/material.dart';


class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({Key? key}) : super(key: key);

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

  void _submitData() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        analyticsData.add(sleepHours);
      });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sleep Analytics')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Left Side Form
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

            // Right Side Chart
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Sleep Hours Chart", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  analyticsData.isEmpty
                      ? const Text("No data yet.")
                      : SizedBox(
                          height: 200,

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
