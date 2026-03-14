/// Interaction models – likes and saves
class InteractionState {
  final Set<int> likedIds;
  final Set<int> savedIds;
  final Set<int> sharedIds;

  const InteractionState({
    this.likedIds = const {},
    this.savedIds = const {},
    this.sharedIds = const {},
  });

  bool isLiked(int id) => likedIds.contains(id);
  bool isSaved(int id) => savedIds.contains(id);
  bool isShared(int id) => sharedIds.contains(id);

  InteractionState copyWith({
    Set<int>? likedIds,
    Set<int>? savedIds,
    Set<int>? sharedIds,
  }) {
    return InteractionState(
      likedIds: likedIds ?? this.likedIds,
      savedIds: savedIds ?? this.savedIds,
      sharedIds: sharedIds ?? this.sharedIds,
    );
  }
}
