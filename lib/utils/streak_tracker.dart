import 'package:shared_preferences/shared_preferences.dart';

Future<int> updateStreak() async {
  final prefs = await SharedPreferences.getInstance();
  final today = DateTime.now();
  final lastDateStr = prefs.getString('lastOpen');
  int streak = 1;

  if (lastDateStr != null) {
    final lastDate = DateTime.parse(lastDateStr);
    final diff = today.difference(lastDate).inDays;
    if (diff == 1) {
      streak = (prefs.getInt('streak') ?? 0) + 1;
    } else if (diff > 1) {
      streak = 1;
    } else {
      streak = prefs.getInt('streak') ?? 1;
    }
  }

  await prefs.setString('lastOpen', today.toIso8601String());
  await prefs.setInt('streak', streak);
  return streak;
}
