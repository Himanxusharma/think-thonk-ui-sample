/**
 * Content Service - Business Logic Layer
 * Handles all content-related operations
 * Language agnostic - easily portable to Flutter
 */

import { ContentItem, UserEngagement } from '@/lib/models/content_model';

class ContentService {
  /**
   * Toggle like status and update count
   * @param item - The content item to toggle
   * @returns Updated content item
   */
  static toggleLike(item: ContentItem): ContentItem {
    return {
      ...item,
      liked: !item.liked,
      likeCount: item.liked ? item.likeCount - 1 : item.likeCount + 1,
    };
  }

  /**
   * Toggle save status and update count
   * @param item - The content item to toggle
   * @returns Updated content item
   */
  static toggleSave(item: ContentItem): ContentItem {
    return {
      ...item,
      saved: !item.saved,
      saveCount: item.saved ? item.saveCount - 1 : item.saveCount + 1,
    };
  }

  /**
   * Update engagement status in content list
   * @param content - Array of content items
   * @param contentId - ID of content to update
   * @param updates - Engagement updates to apply
   * @returns Updated content array
   */
  static updateContentEngagement(
    content: ContentItem[],
    contentId: number,
    updates: Partial<UserEngagement>,
  ): ContentItem[] {
    return content.map(item => {
      if (item.id !== contentId) return item;

      let updated = { ...item };

      if (updates.liked !== undefined && updates.liked !== item.liked) {
        const result = this.toggleLike(updated);
        updated = result;
      }

      if (updates.saved !== undefined && updates.saved !== item.saved) {
        const result = this.toggleSave(updated);
        updated = result;
      }

      if (updates.shared !== undefined) {
        updated.shared = updates.shared;
      }

      return updated;
    });
  }

  /**
   * Get total engagement metrics
   * @param content - Array of content items
   * @returns Object with total likes and saves
   */
  static getEngagementMetrics(content: ContentItem[]) {
    return {
      totalLikes: content.reduce((sum, item) => sum + item.likeCount, 0),
      totalSaves: content.reduce((sum, item) => sum + item.saveCount, 0),
      totalItems: content.length,
      averageLikesPerItem: Math.round(
        content.reduce((sum, item) => sum + item.likeCount, 0) / content.length,
      ),
    };
  }

  /**
   * Filter content by category
   * @param content - Array of content items
   * @param category - Category to filter by
   * @returns Filtered content array
   */
  static filterByCategory(content: ContentItem[], category: string): ContentItem[] {
    return content.filter(item => item.category === category);
  }

  /**
   * Sort content by engagement
   * @param content - Array of content items
   * @param by - Sort by 'likes' or 'saves'
   * @param order - 'asc' or 'desc'
   * @returns Sorted content array
   */
  static sortByEngagement(
    content: ContentItem[],
    by: 'likes' | 'saves' = 'likes',
    order: 'asc' | 'desc' = 'desc',
  ): ContentItem[] {
    const sorted = [...content].sort((a, b) => {
      const valueA = by === 'likes' ? a.likeCount : a.saveCount;
      const valueB = by === 'likes' ? b.likeCount : b.saveCount;
      return order === 'asc' ? valueA - valueB : valueB - valueA;
    });
    return sorted;
  }

  /**
   * Find content item by ID
   * @param content - Array of content items
   * @param id - Content ID to find
   * @returns Content item or undefined
   */
  static findById(content: ContentItem[], id: number): ContentItem | undefined {
    return content.find(item => item.id === id);
  }

  /**
   * Find index of content item
   * @param content - Array of content items
   * @param id - Content ID to find
   * @returns Index or -1
   */
  static findIndexById(content: ContentItem[], id: number): number {
    return content.findIndex(item => item.id === id);
  }
}

export default ContentService;
