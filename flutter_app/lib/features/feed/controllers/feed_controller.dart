import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/idea.dart';
import '../repositories/feed_repository.dart';

/// Feed state
class FeedState {
  final List<Idea> ideas;
  final Idea? selectedIdea;
  final bool isModalOpen;
  final bool isFullscreenOpen;
  final int fullscreenIndex;
  final bool showTopBar;
  final bool isLoading;

  const FeedState({
    this.ideas = const [],
    this.selectedIdea,
    this.isModalOpen = false,
    this.isFullscreenOpen = false,
    this.fullscreenIndex = 0,
    this.showTopBar = true,
    this.isLoading = false,
  });

  FeedState copyWith({
    List<Idea>? ideas,
    Idea? selectedIdea,
    bool clearSelectedIdea = false,
    bool? isModalOpen,
    bool? isFullscreenOpen,
    int? fullscreenIndex,
    bool? showTopBar,
    bool? isLoading,
  }) {
    return FeedState(
      ideas: ideas ?? this.ideas,
      selectedIdea: clearSelectedIdea ? null : (selectedIdea ?? this.selectedIdea),
      isModalOpen: isModalOpen ?? this.isModalOpen,
      isFullscreenOpen: isFullscreenOpen ?? this.isFullscreenOpen,
      fullscreenIndex: fullscreenIndex ?? this.fullscreenIndex,
      showTopBar: showTopBar ?? this.showTopBar,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Feed controller using Riverpod StateNotifier
final feedControllerProvider =
    StateNotifierProvider<FeedController, FeedState>((ref) {
  return FeedController(FeedRepository.instance);
});

class FeedController extends StateNotifier<FeedState> {
  final FeedRepository _repository;

  FeedController(this._repository) : super(const FeedState()) {
    _loadFeed();
  }

  Future<void> _loadFeed() async {
    state = state.copyWith(isLoading: true);
    final ideas = await _repository.fetchFeed();
    state = state.copyWith(ideas: ideas, isLoading: false);
  }

  void toggleLike(int id) {
    final updated = state.ideas.map((idea) {
      if (idea.id != id) return idea;
      final newLiked = !idea.liked;
      return idea.copyWith(
        liked: newLiked,
        likeCount: newLiked ? idea.likeCount + 1 : idea.likeCount - 1,
      );
    }).toList();
    state = state.copyWith(ideas: updated);
  }

  void toggleSave(int id) {
    final updated = state.ideas.map((idea) {
      if (idea.id != id) return idea;
      final newSaved = !idea.saved;
      return idea.copyWith(
        saved: newSaved,
        saveCount: newSaved ? idea.saveCount + 1 : idea.saveCount - 1,
      );
    }).toList();
    state = state.copyWith(ideas: updated);
  }

  void markShared(int id) {
    final updated = state.ideas.map((idea) {
      if (idea.id != id) return idea;
      return idea.copyWith(shared: true);
    }).toList();
    state = state.copyWith(ideas: updated);
  }

  void openModal(Idea idea) {
    state = state.copyWith(selectedIdea: idea, isModalOpen: true);
  }

  void closeModal() {
    state = state.copyWith(isModalOpen: false);
  }

  void openFullscreen(int index) {
    state = state.copyWith(isFullscreenOpen: true, fullscreenIndex: index);
  }

  void closeFullscreen() {
    state = state.copyWith(isFullscreenOpen: false);
  }

  void setShowTopBar(bool show) {
    state = state.copyWith(showTopBar: show);
  }

  Idea? getById(int id) {
    return state.ideas.where((i) => i.id == id).firstOrNull;
  }
}
