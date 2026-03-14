import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/saved_article.dart';
import '../repositories/saved_repository.dart';

class SavedState {
  final List<SavedArticle> articles;
  final String searchQuery;

  const SavedState({
    this.articles = const [],
    this.searchQuery = '',
  });

  List<SavedArticle> get filtered {
    if (searchQuery.isEmpty) return articles;
    final q = searchQuery.toLowerCase();
    return articles.where((a) =>
        a.headline.toLowerCase().contains(q) ||
        a.category.toLowerCase().contains(q)).toList();
  }

  SavedState copyWith({List<SavedArticle>? articles, String? searchQuery}) {
    return SavedState(
      articles: articles ?? this.articles,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

final savedControllerProvider =
    StateNotifierProvider<SavedController, SavedState>((ref) {
  return SavedController(SavedRepository.instance);
});

class SavedController extends StateNotifier<SavedState> {
  final SavedRepository _repository;

  SavedController(this._repository)
      : super(SavedState(articles: _repository.articles));

  void remove(int id) {
    _repository.remove(id);
    state = state.copyWith(articles: _repository.articles);
  }

  void setSearch(String query) {
    state = state.copyWith(searchQuery: query);
  }
}
