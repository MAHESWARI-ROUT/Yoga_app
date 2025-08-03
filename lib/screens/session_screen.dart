import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:yoga_app/models/yoga_session.dart.dart';
import '../utils/streak_tracker.dart';
import 'preview_screen.dart';
import '../widgets/pose_display.dart';

class YogaSessionScreen extends StatefulWidget {
  const YogaSessionScreen({super.key});

  @override
  State<YogaSessionScreen> createState() => _YogaSessionScreenState();
}

class _YogaSessionScreenState extends State<YogaSessionScreen> {
  final String currentJsonPath = 'assets/poses.json';
  late AudioPlayer audioPlayer;

  YogaSession? session;
  int currentSegmentIndex = 0;
  PoseScript? currentScript;
  Duration audioPosition = Duration.zero;
  bool isPlaying = false;
  bool isLoading = true;
  int streak = 0;

  @override
  void initState() {
    super.initState();
    loadSession();
    updateStreak().then((value) => setState(() => streak = value));
  }

  Future<void> loadSession() async {
    try {
      String jsonStr = await rootBundle.loadString(currentJsonPath);
      jsonStr = jsonStr.replaceAll("{{loopCount}}", "4");

      final data = json.decode(jsonStr);
      session = YogaSession.fromJson(data);
      debugPrint('✅ Session parsed: ${session!.metadata}');

      audioPlayer = AudioPlayer();

      audioPlayer.onPositionChanged.listen((p) {
        setState(() => audioPosition = p);
        updateCurrentScript();
      });

      audioPlayer.onPlayerComplete.listen((_) => moveToNextSegment());

      await startSegment();

      setState(() => isLoading = false);
    } catch (e) {
      debugPrint('❌ ERROR loading session: $e');
    }
  }

  void updateCurrentScript() {
    if (session == null) return;

    final segment = session!.sequence[currentSegmentIndex];
    final pos = audioPosition.inSeconds.toDouble();

    if (segment.script.isEmpty) return;

    final match = segment.script.firstWhere(
      (s) => pos >= s.startSec && pos < s.endSec,
      orElse: () => segment.script.first,
    );

    if (currentScript?.text != match.text) {
      setState(() => currentScript = match);
    }
  }

  Future<void> startSegment() async {
    final segment = session!.sequence[currentSegmentIndex];
    final audioFilename = session!.audioAssets[segment.audioRef];

    if (audioFilename == null) {
      debugPrint("❌ No audio found for ${segment.audioRef}");
      return;
    }

    final audioPath = 'audio/$audioFilename';

    try {
      await audioPlayer.setSource(AssetSource(audioPath));
      await audioPlayer.resume();

      setState(() {
        isPlaying = true;
        currentScript = segment.script.isNotEmpty
            ? segment.script.first
            : PoseScript(
                startSec: 0,
                endSec: 0,
                text: "No script available.",
                imageRef: "base",
              );
      });

      await Future.delayed(const Duration(milliseconds: 500));
      updateCurrentScript();
    } catch (e) {
      debugPrint("❌ Audio error: $e");
    }
  }

  void moveToNextSegment() {
    if (currentSegmentIndex < session!.sequence.length - 1) {
      setState(() => currentSegmentIndex++);
      startSegment();
    } else {
      setState(() => isPlaying = false);
    }
  }

  void togglePlayPause() {
    if (isPlaying) {
      audioPlayer.pause();
    } else {
      audioPlayer.resume();
    }
    setState(() => isPlaying = !isPlaying);
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (session == null || currentScript == null) {
      return const Scaffold(
        body: Center(child: Text("Unable to load session. Please try again.")),
      );
    }

    final segment = session!.sequence[currentSegmentIndex];
    final totalDuration = Duration(seconds: segment.durationSec.toInt());

    final imagePath = session!.imageAssets[currentScript!.imageRef] ??
        'assets/images/Cat.png';

    return Scaffold(
      appBar: AppBar(
        title: Text(session!.metadata['title']),
        actions: [
          IconButton(
            icon: const Icon(Icons.preview),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PosePreviewScreen(session: session!),
                ),
              );
            },
          ),
        ],
      ),
      body: PoseDisplay(
        script: currentScript!,
        imagePath: imagePath,
        text: currentScript!.text,
        audioProgress: totalDuration.inMilliseconds == 0
            ? 0
            : audioPosition.inMilliseconds / totalDuration.inMilliseconds,
        isPlaying: isPlaying,
        onPlayPause: togglePlayPause,
        streak: streak,
      ),
    );
  }
}
