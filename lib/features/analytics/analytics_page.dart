import 'package:flutter/material.dart';
import '../../data/models/sleep_data_model.dart';
import '../../../core/services/sleep_data_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  late Future<SleepData> _sleepDataFuture;

  @override
  void initState() {
    super.initState();
    _sleepDataFuture = SleepDataService.loadSleepData();
  }

  double _averageSleep(List<SleepEntry> week) {
    return week.map((e) => e.duration).reduce((a, b) => a + b) / week.length;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SleepData>(
      future: _sleepDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text("Error loading sleep data"));
        }

        if (!snapshot.hasData || snapshot.data!.week.isEmpty || snapshot.data!.today == null) {
          return const Center(child: Text("No valid sleep data available"));
        }

        final data = snapshot.data!;
        final averageDuration = _averageSleep(data.week).toStringAsFixed(1);

        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Scrollable 7-Day Quality Circles
                  SizedBox(
                    height: 90,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: data.week.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final entry = data.week[index];
                        return Column(
                          children: [
                            CustomPaint(
                              size: const Size(48, 48),
                              painter: SolidColorCirclePainter(entry.quality),
                              child: SizedBox(
                                width: 48,
                                height: 48,
                                child: Center(
                                  child: Text(
                                    '${entry.quality}%',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(entry.day, style: const TextStyle(color: Colors.white70)),
                          ],
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Average Duration Text
                  Text(
                    "Average Duration: $averageDuration hrs",
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),

                  const SizedBox(height: 16),

                  // Line Chart
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final index = value.toInt();
                                  if (index >= 0 && index < data.week.length) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Text(
                                        data.week[index].day,
                                        style: const TextStyle(color: Colors.white, fontSize: 12),
                                      ),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                                interval: 1,
                              ),
                            ),
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: const Border(
                              bottom: BorderSide(color: Colors.white24),
                              left: BorderSide(color: Colors.white24),
                              right: BorderSide(color: Colors.transparent),
                              top: BorderSide(color: Colors.transparent),
                            ),
                          ),
                          minY: 0,
                          maxY: 10,
                          lineBarsData: [
                            LineChartBarData(
                              spots: data.week.asMap().entries.map((e) {
                                return FlSpot(e.key.toDouble(), e.value.duration);
                              }).toList(),
                              isCurved: true,
                              color: Colors.cyanAccent,
                              barWidth: 3,
                              isStrokeCapRound: true,
                              dotData: FlDotData(show: true),
                              belowBarData: BarAreaData(
                                show: true,
                                color: Colors.cyanAccent.withOpacity(0.2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Today's Summary
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade900,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Today's Summary", style: TextStyle(fontSize: 18, color: Colors.white)),
                        const SizedBox(height: 12),
                        Text("Duration: ${data.today.duration} hrs", style: const TextStyle(color: Colors.white70)),
                        Text("Quality: ${data.today.quality}%", style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Solid Color Circle Based on Quality Value
class SolidColorCirclePainter extends CustomPainter {
  final int quality;

  SolidColorCirclePainter(this.quality);

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 6.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final backgroundPaint = Paint()
      ..color = Colors.grey.shade800
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    Color arcColor;
    if (quality < 50) {
      arcColor = Colors.red;
    } else if (quality < 70) {
      arcColor = Colors.yellow;
    } else {
      arcColor = Colors.green;
    }

    arcPaint.color = arcColor;

    canvas.drawCircle(center, radius, backgroundPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * (quality / 100),
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}