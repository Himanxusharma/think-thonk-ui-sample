import '../models/interaction_state.dart';

/// Interaction repository – locally tracks likes/saves.
/// In production this would write to Firestore.
class InteractionRepository {
  InteractionRepository._();
  static final InteractionRepository instance = InteractionRepository._();

  InteractionState _state = const InteractionState();

  InteractionState get current => _state;

  void toggleLike(int id) {
    final ids = Set<int>.from(_state.likedIds);
    if (ids.contains(id)) {
      ids.remove(id);
    } else {
      ids.add(id);
    }
    _state = _state.copyWith(likedIds: ids);
  }

  void toggleSave(int id) {
    final ids = Set<int>.from(_state.savedIds);
    if (ids.contains(id)) {
      ids.remove(id);
    } else {
      ids.add(id);
    }
    _state = _state.copyWith(savedIds: ids);
  }

  void markShared(int id) {
    final ids = Set<int>.from(_state.sharedIds)..add(id);
    _state = _state.copyWith(sharedIds: ids);
  }
}
