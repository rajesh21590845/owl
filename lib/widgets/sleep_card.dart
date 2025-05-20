import 'package:flutter/material.dart';
import '../data/models/sleep_entry_model.dart';
import '../core/utils/date_utils_helper.dart';

class SleepCard extends StatelessWidget {
  final SleepEntry entry;

  const SleepCard({Key? key, required this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.bedtime, color: Colors.indigo),
        title: Text(DateUtilsHelper.formatDate(entry.startTime)),
        subtitle: Text(
          "${DateUtilsHelper.formatTime(entry.startTime)} - ${DateUtilsHelper.formatTime(entry.endTime)}",
        ),
        trailing: Text(DateUtilsHelper.durationToString(entry.duration)),
      ),
    );
  }
}
