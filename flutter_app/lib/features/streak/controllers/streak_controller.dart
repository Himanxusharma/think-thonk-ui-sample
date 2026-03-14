import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/streak_model.dart';
import '../repositories/streak_repository.dart';

final streakControllerProvider =
    StateNotifierProvider<StreakController, StreakModel>((ref) {
  return StreakController(StreakRepository.instance);
});

class StreakController extends StateNotifier<StreakModel> {
  final StreakRepository _repository;

  StreakController(this._repository) : super(_repository.current);

  void increment() {
    _repository.increment();
    state = _repository.current;
  }
}
