import 'package:flutter/material.dart';
import 'package:yoga_app/models/yoga_session.dart.dart';

class PosePreviewScreen extends StatelessWidget {
  final YogaSession session;
  const PosePreviewScreen({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final scripts = session.sequence.expand((s) => s.script).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Pose Preview')),
      body: ListView.builder(
        itemCount: scripts.length,
        itemBuilder: (context, index) {
          final s = scripts[index];
          return Card(
            child: ListTile(
              leading: Image.asset('assets/images/${session.imageAssets[s.imageRef]}'),
              title: Text(s.text),
              subtitle: Text('${s.startSec}s – ${s.endSec}s'),
            ),
          );
        },
      ),
    );
  }
}
