import '../models/streak_model.dart';

/// Streak repository – persists streak locally.
/// In a production app this would sync with Firestore.
class StreakRepository {
  StreakRepository._();
  static final StreakRepository instance = StreakRepository._();

  StreakModel _current = const StreakModel();

  StreakModel get current => _current;

  void increment() {
    _current = _current.copyWith(
      count: _current.count + 1,
      lastActivity: DateTime.now(),
    );
  }
}
