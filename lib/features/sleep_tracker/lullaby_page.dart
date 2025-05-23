import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class LullabyPage extends StatefulWidget {
  const LullabyPage({super.key});

  @override
  State<LullabyPage> createState() => _LullabyPageState();
}

class _LullabyPageState extends State<LullabyPage> {
  final AudioPlayer _player = AudioPlayer();

  final List<Map<String, String>> _lullabies = [
    {
      'title': 'Gentle Night',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    },
    {
      'title': 'Dream Waves',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
    },
    {
      'title': 'Sleepy Sky',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
    },
  ];

  int? _playingIndex;

  void _playLullaby(String url, int index) async {
    try {
      await _player.setUrl(url);
      _player.play();
      setState(() {
        _playingIndex = index;
      });
    } catch (e) {
      print('Error playing lullaby: $e');
    }
  }

  void _stopPlayback() {
    _player.stop();
    setState(() {
      _playingIndex = null;
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lullabies')),
      body: ListView.builder(
        itemCount: _lullabies.length,
        itemBuilder: (context, index) {
          final lullaby = _lullabies[index];
          final isPlaying = _playingIndex == index;

          return ListTile(
            leading: Icon(isPlaying ? Icons.pause_circle : Icons.play_circle),
            title: Text(lullaby['title']!),
            onTap: () {
              isPlaying
                  ? _stopPlayback()
                  : _playLullaby(lullaby['url']!, index);
            },
          );
        },
      ),
    );
  }
}
