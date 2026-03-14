import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/interaction_state.dart';
import '../repositories/interaction_repository.dart';

final interactionControllerProvider =
    StateNotifierProvider<InteractionController, InteractionState>((ref) {
  return InteractionController(InteractionRepository.instance);
});

class InteractionController extends StateNotifier<InteractionState> {
  final InteractionRepository _repository;

  InteractionController(this._repository) : super(_repository.current);

  void toggleLike(int id) {
    _repository.toggleLike(id);
    state = _repository.current;
  }

  void toggleSave(int id) {
    _repository.toggleSave(id);
    state = _repository.current;
  }

  void markShared(int id) {
    _repository.markShared(id);
    state = _repository.current;
  }
}
