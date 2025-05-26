import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SleepMusicPlayerPage extends StatefulWidget {
  @override
  _SleepMusicPlayerPageState createState() => _SleepMusicPlayerPageState();
}

class _SleepMusicPlayerPageState extends State<SleepMusicPlayerPage> {
  final player = AudioPlayer();
  late ConcatenatingAudioSource playlist;

  Duration remaining = Duration(minutes: 5);
  Duration totalDuration = Duration(minutes: 5);
  Timer? countdownTimer;
  bool isPlaying = false;
  double volume = 1.0;
  String? selectedTrack;
  int selectedMinutes = 5;
  int currentIndex = 0;

  final List<String> tracks = [
    'birds_nature',
    'breath_of_life',
    'calm_waves',
    'distance_piano',
    'melancholic',
    'momentum',
    'nostalgia',
    'petals_of_memories',
    'piano',
    'serenity',
  ];

  final List<int> timerOptions = [5, 10, 15, 20, 30];

  @override
  void initState() {
    super.initState();
    _loadSavedData();

    player.currentIndexStream.listen((index) {
      if (index != null && index < tracks.length) {
        setState(() {
          selectedTrack = tracks[index];
          currentIndex = index;
        });
      }
    });

    player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (currentIndex >= tracks.length - 1) {
          countdownTimer?.cancel();
          setState(() {
            isPlaying = false;
            remaining = Duration(seconds: 0);
          });
        }
      }
    });
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    selectedTrack = prefs.getString('selectedTrack');
    int seconds = prefs.getInt('remainingSeconds') ?? 300;
    setState(() {
      remaining = Duration(seconds: seconds);
      totalDuration = remaining;
    });

    if (selectedTrack != null) {
      int index = tracks.indexOf(selectedTrack!);
      await _loadPlaylist(initialIndex: index);
    }
  }

  Future<void> _loadPlaylist({int initialIndex = 0}) async {
    playlist = ConcatenatingAudioSource(
      children: tracks
          .map((t) => AudioSource.asset('assets/music/$t.mp3'))
          .toList(),
    );
    await player.setAudioSource(playlist, initialIndex: initialIndex);
  }

  void _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedTrack', selectedTrack ?? '');
    await prefs.setInt('remainingSeconds', remaining.inSeconds);
  }

  void _startTimer() {
    countdownTimer?.cancel();
    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remaining.inSeconds <= 1) {
        timer.cancel();
        player.pause();
        setState(() {
          isPlaying = false;
          remaining = Duration(seconds: 0);
        });
      } else {
        setState(() {
          remaining -= Duration(seconds: 1);
        });
        _saveState();
      }
    });
  }

  Future<void> _playPause() async {
    if (selectedTrack == null) return;

    if (isPlaying) {
      await player.pause();
      countdownTimer?.cancel();
    } else {
      await player.setVolume(volume);
      await player.play();
      if (remaining.inSeconds == 0) {
        setState(() {
          remaining = totalDuration;
        });
      }
      _startTimer();
    }

    setState(() {
      isPlaying = !isPlaying;
    });
  }

  Future<void> _selectTrack(String track) async {
    int index = tracks.indexOf(track);
    await _loadPlaylist(initialIndex: index);

    setState(() {
      selectedTrack = track;
      currentIndex = index;
      remaining = Duration(minutes: selectedMinutes);
      totalDuration = remaining;
      isPlaying = false;
    });
    countdownTimer?.cancel();
    await player.pause();
    _saveState();
  }

  void _onTimerDropdownChange(int? value) {
    if (value != null) {
      setState(() {
        selectedMinutes = value;
        remaining = Duration(minutes: selectedMinutes);
        totalDuration = remaining;
      });
      _saveState();
    }
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    player.dispose();
    super.dispose();
  }

  String formatDuration(Duration d) =>
      d.toString().split('.').first.padLeft(8, "0");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sleep Music Player")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Sleep Timer: ${formatDuration(remaining)}",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            DropdownButton<int>(
              value: selectedMinutes,
              items: timerOptions
                  .map((min) =>
                      DropdownMenuItem(value: min, child: Text('$min minutes')))
                  .toList(),
              onChanged: _onTimerDropdownChange,
            ),
            Slider(
              value: volume,
              onChanged: (v) async {
                setState(() => volume = v);
                await player.setVolume(v);
              },
              min: 0.0,
              max: 1.0,
              divisions: 10,
              label: "Volume: ${(volume * 100).round()}%",
            ),
            ElevatedButton(
              onPressed: _playPause,
              child: Text(isPlaying ? "Pause" : "Play"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: tracks.length,
                itemBuilder: (context, index) {
                  String track = tracks[index];
                  return ListTile(
                    title: Text(track.replaceAll('_', ' ')),
                    trailing: selectedTrack == track
                        ? Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () => _selectTrack(track),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}