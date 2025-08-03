class YogaSession {
  final Map<String, String> imageAssets;
  final Map<String, String> audioAssets;
  final Map<String, dynamic> metadata;
  final List<PoseSegment> sequence;

  YogaSession({
    required this.imageAssets,
    required this.audioAssets,
    required this.metadata,
    required this.sequence,
  });

  factory YogaSession.fromJson(Map<String, dynamic> json) {
    return YogaSession(
      imageAssets: Map<String, String>.from(json['assets']['images']),
      audioAssets: Map<String, String>.from(json['assets']['audio']),
      metadata: json['metadata'],
      sequence: (json['sequence'] as List).map((e) => PoseSegment.fromJson(e)).toList(),
    );
  }
}

class PoseSegment {
  final String type;
  final String name;
  final String audioRef;
  final double durationSec;
  final int? iterations;
  final bool loopable;
  final List<PoseScript> script;

  PoseSegment({
    required this.type,
    required this.name,
    required this.audioRef,
    required this.durationSec,
    this.iterations,
    this.loopable = false,
    required this.script,
  });

  factory PoseSegment.fromJson(Map<String, dynamic> json) {
    return PoseSegment(
      type: json['type'],
      name: json['name'],
      audioRef: json['audioRef'],
      durationSec: (json['durationSec'] as num).toDouble(),
      iterations: json['iterations'] is String
          ? null
          : json['iterations'],
      loopable: json['loopable'] ?? false,
      script: (json['script'] as List)
          .map((e) => PoseScript.fromJson(e))
          .toList(),
    );
  }
}

class PoseScript {
  final String text;
  final double startSec;
  final double endSec;
  final String imageRef;

  PoseScript({
    required this.text,
    required this.startSec,
    required this.endSec,
    required this.imageRef,
  });

  factory PoseScript.fromJson(Map<String, dynamic> json) {
    return PoseScript(
      text: json['text'],
      startSec: (json['startSec'] as num).toDouble(),
      endSec: (json['endSec'] as num).toDouble(),
      imageRef: json['imageRef'],
    );
  }
}
