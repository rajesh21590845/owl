class SleepEntry {
  final DateTime startTime;
  final DateTime endTime;
  final Duration duration;
  final int quality; // e.g., 1–5 stars
  final String? notes;

  SleepEntry({
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.quality,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'duration': duration.inMinutes,
      'quality': quality,
      'notes': notes,
    };
  }

  factory SleepEntry.fromJson(Map<String, dynamic> json) {
    return SleepEntry(
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      duration: Duration(minutes: json['duration']),
      quality: json['quality'],
      notes: json['notes'],
    );
  }
}
