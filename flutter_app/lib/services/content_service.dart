import '../models/content_model.dart';

/// Content Service - Business Logic Layer
/// Handles all content-related operations
class ContentService {
  /// Toggle like status and update count
  static ContentItem toggleLike(ContentItem item) {
    return item.copyWith(
      liked: !item.liked,
      likeCount: item.liked ? item.likeCount - 1 : item.likeCount + 1,
    );
  }

  /// Toggle save status and update count
  static ContentItem toggleSave(ContentItem item) {
    return item.copyWith(
      saved: !item.saved,
      saveCount: item.saved ? item.saveCount - 1 : item.saveCount + 1,
    );
  }

  /// Update engagement status in content list
  static List<ContentItem> updateContentEngagement(
    List<ContentItem> content,
    int contentId,
    UserEngagement updates,
  ) {
    return content.map((item) {
      if (item.id != contentId) return item;

      ContentItem updated = item;

      if (updates.liked != item.liked) {
        updated = toggleLike(updated);
      }

      if (updates.saved != item.saved) {
        updated = toggleSave(updated);
      }

      if (updates.shared) {
        updated = updated.copyWith(shared: true);
      }

      return updated;
    }).toList();
  }

  /// Get total engagement metrics
  static Map<String, dynamic> getEngagementMetrics(List<ContentItem> content) {
    final totalLikes =
        content.fold<int>(0, (sum, item) => sum + item.likeCount);
    final totalSaves =
        content.fold<int>(0, (sum, item) => sum + item.saveCount);

    return {
      'totalLikes': totalLikes,
      'totalSaves': totalSaves,
      'totalItems': content.length,
      'averageLikesPerItem':
          content.isEmpty ? 0 : (totalLikes / content.length).round(),
    };
  }

  /// Filter content by category
  static List<ContentItem> filterByCategory(
    List<ContentItem> content,
    String category,
  ) {
    return content.where((item) => item.category == category).toList();
  }

  /// Sort content by engagement
  static List<ContentItem> sortByEngagement(
    List<ContentItem> content, {
    String by = 'likes',
    String order = 'desc',
  }) {
    final sorted = List<ContentItem>.from(content);
    sorted.sort((a, b) {
      final valueA = by == 'likes' ? a.likeCount : a.saveCount;
      final valueB = by == 'likes' ? b.likeCount : b.saveCount;
      return order == 'asc' ? valueA.compareTo(valueB) : valueB.compareTo(valueA);
    });
    return sorted;
  }

  /// Find content item by ID
  static ContentItem? findById(List<ContentItem> content, int id) {
    return content.where((item) => item.id == id).firstOrNull;
  }

  /// Find index of content item
  static int findIndexById(List<ContentItem> content, int id) {
    return content.indexWhere((item) => item.id == id);
  }
}
