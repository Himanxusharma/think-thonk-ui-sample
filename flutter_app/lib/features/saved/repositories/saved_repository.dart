import '../models/saved_article.dart';

/// Saved articles repository
class SavedRepository {
  SavedRepository._();
  static final SavedRepository instance = SavedRepository._();

  final List<SavedArticle> _articles = [
    const SavedArticle(
      id: 1,
      category: 'Psychology',
      headline: 'The Horse Effect Theory',
      preview:
          'Understanding how our brains process information through metaphorical thinking...',
      savedDate: 'March 10, 2024',
    ),
    const SavedArticle(
      id: 3,
      category: 'Behavioral Science',
      headline: 'The Paradox of Choice',
      preview:
          'How having too many options can lead to decision paralysis and decreased satisfaction...',
      savedDate: 'March 8, 2024',
    ),
    const SavedArticle(
      id: 5,
      category: 'Philosophy',
      headline: 'The Nature of Consciousness',
      preview:
          'Exploring the hard problem of consciousness and what it means to be aware...',
      savedDate: 'March 5, 2024',
    ),
  ];

  List<SavedArticle> get articles => List.unmodifiable(_articles);

  void remove(int id) => _articles.removeWhere((a) => a.id == id);

  void add(SavedArticle article) {
    if (!_articles.any((a) => a.id == article.id)) {
      _articles.insert(0, article);
    }
  }
}
