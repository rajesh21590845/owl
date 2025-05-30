import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:path_provider/path_provider.dart';

class TrackerPage extends StatefulWidget {
  @override
  _TrackerPageState createState() => _TrackerPageState();
}

class _TrackerPageState extends State<TrackerPage> {
  late File localJsonFile;
  late Directory appDir;

  bool fileReady = false;

  Map<String, dynamic> fullData = {};
  List<String> availableDates = [];
  String selectedDate = '';

  List<String> hours = [];
  Map<String, int> todayUsage = {};

  int totalUsage = 0;
  int sleepQuality = 100;

  @override
  void initState() {
    super.initState();
    loadUsageData();
  }

  Future<void> loadUsageData() async {
    appDir = await getApplicationDocumentsDirectory();
    localJsonFile = File('${appDir.path}/screen_usage.json');

    if (!await localJsonFile.exists()) {
      final rawJson = await rootBundle.loadString('assets/data/screen_usage.json');
      await localJsonFile.writeAsString(rawJson);
    }

    final content = await localJsonFile.readAsString();
    final data = json.decode(content);

    fullData = Map<String, dynamic>.from(data);

    availableDates = fullData.keys.toList()..sort();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    selectedDate = availableDates.last;

    generateSleepWindow();
    loadSelectedDateUsage();

    setState(() => fileReady = true);
  }

  void generateSleepWindow() {
    if (!fullData.containsKey(selectedDate)) return;

    final sleepWindowStart = fullData[selectedDate]['windowStart'] as String?;
    final sleepWindowEnd = fullData[selectedDate]['windowEnd'] as String?;

    if (sleepWindowStart == null || sleepWindowEnd == null) return;

    int startHour = int.parse(sleepWindowStart.split(":")[0]);
    int endHour = int.parse(sleepWindowEnd.split(":")[0]);

    hours.clear();
    for (int h = startHour; h != endHour; h = (h + 1) % 24) {
      hours.add("${h.toString().padLeft(2, '0')}:00");
    }
    hours.add("${endHour.toString().padLeft(2, '0')}:00");
  }

  void loadSelectedDateUsage() {
    todayUsage = {};
    if (!fullData.containsKey(selectedDate)) return;

    final usageMap = fullData[selectedDate]['usage'] ?? {};
    todayUsage = Map<String, int>.from(usageMap);

    totalUsage = todayUsage.values.fold(0, (sum, val) => sum + val);
    sleepQuality = (100 - totalUsage).clamp(0, 100);

    setState(() {});
  }

  List<BarChartGroupData> _buildBarGroups() {
    return hours.map((hour) {
      final usage = todayUsage[hour] ?? 0;
      return BarChartGroupData(
        x: hours.indexOf(hour),
        barRods: [
          BarChartRodData(toY: usage.toDouble(), color: Colors.blueAccent),
        ],
      );
    }).toList();
  }

  Widget _buildTimePicker(String label, String currentTime) {
    return Row(
      children: [
        Text("$label: $currentTime", style: TextStyle(fontSize: 16)),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: () async {
            final timeParts = currentTime.split(":");
            TimeOfDay? picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay(
                hour: int.parse(timeParts[0]),
                minute: int.parse(timeParts[1]),
              ),
            );
            if (picked != null) {
              final newTime =
                  "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
              setState(() {
                fullData[selectedDate][label.toLowerCase()] = newTime;
                generateSleepWindow();
                loadSelectedDateUsage();
              });
              await localJsonFile.writeAsString(json.encode(fullData));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$label time updated to $newTime')),
              );
            }
          },
          child: Text("Change"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!fileReady) {
      return Scaffold(
        appBar: AppBar(title: Text("Sleep Tracker")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final startTime = fullData[selectedDate]['windowStart'] ?? 'Unknown';
    final endTime = fullData[selectedDate]['windowEnd'] ?? 'Unknown';

    return Scaffold(
      appBar: AppBar(title: Text("Sleep Tracker")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Sleep Quality: $sleepQuality / 100", style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedDate,
              items: availableDates.map((date) {
                return DropdownMenuItem<String>(
                  value: date,
                  child: Text(date),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDate = value!;
                  generateSleepWindow();
                  loadSelectedDateUsage();
                });
              },
            ),
            SizedBox(height: 20),
            _buildTimePicker('Start', startTime),
            SizedBox(height: 10),
            _buildTimePicker('End', endTime),
            SizedBox(height: 20),
            Expanded(
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceBetween,
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < hours.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(hours[index], style: TextStyle(fontSize: 10)),
                            );
                          }
                          return SizedBox.shrink();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: 5,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: _buildBarGroups(),
                  maxY: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}