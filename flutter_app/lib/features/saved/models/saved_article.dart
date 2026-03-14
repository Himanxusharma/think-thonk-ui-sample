/// Saved article model
class SavedArticle {
  final int id;
  final String category;
  final String headline;
  final String preview;
  final String savedDate;

  const SavedArticle({
    required this.id,
    required this.category,
    required this.headline,
    required this.preview,
    required this.savedDate,
  });
}
