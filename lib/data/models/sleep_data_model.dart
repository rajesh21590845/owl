class SleepEntry {
  final String day;
  final double duration;
  final int quality;

  SleepEntry({required this.day, required this.duration, required this.quality});

  factory SleepEntry.fromJson(Map<String, dynamic> json) {
    return SleepEntry(
      day: json['day'] ?? 'Unknown',
      duration: (json['duration'] as num).toDouble(),
      quality: json['quality'],
    );
  }
}

class SleepData {
  final List<SleepEntry> week;
  final SleepEntry today;

  SleepData({required this.week, required this.today});

  factory SleepData.fromJson(Map<String, dynamic> json) {
    List<SleepEntry> weekData = (json['week'] as List)
        .map((e) => SleepEntry.fromJson(e))
        .toList();
    SleepEntry todayData = SleepEntry.fromJson(json['today']);
    return SleepData(week: weekData, today: todayData);
  }
}