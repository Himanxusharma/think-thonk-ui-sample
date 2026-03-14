/// Streak domain model
class StreakModel {
  final int count;
  final DateTime? lastActivity;

  const StreakModel({
    this.count = 7,
    this.lastActivity,
  });

  StreakModel copyWith({int? count, DateTime? lastActivity}) {
    return StreakModel(
      count: count ?? this.count,
      lastActivity: lastActivity ?? this.lastActivity,
    );
  }
}
