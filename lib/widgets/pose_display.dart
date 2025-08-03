import 'package:flutter/material.dart';
import 'package:yoga_app/models/yoga_session.dart.dart';

class PoseDisplay extends StatelessWidget {
  final PoseScript script;
  final String imagePath;
  final String text;
  final double audioProgress;
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final int streak;

  const PoseDisplay({
    super.key,
    required this.script,
    required this.imagePath,
    required this.text,
    required this.audioProgress,
    required this.isPlaying,
    required this.onPlayPause,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Text("Streak: $streak days", style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        Image.asset('assets/images/$imagePath', height: 300),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
        ),
        const SizedBox(height: 24),
        LinearProgressIndicator(value: audioProgress),
        const SizedBox(height: 24),
        IconButton(
          iconSize: 48,
          icon: Icon(isPlaying ? Icons.pause_circle : Icons.play_circle),
          onPressed: onPlayPause,
        ),
      ],
    );
  }
}
