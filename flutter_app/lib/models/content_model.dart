/// Core Data Models for Think-Thonk UI
/// Mirrors the TypeScript models from lib/models/content_model.ts

class ContentItem {
  final int id;
  final String category;
  final String headline;
  final String content;
  final String expandedContent;
  bool saved;
  bool liked;
  bool shared;
  int likeCount;
  int saveCount;

  ContentItem({
    required this.id,
    required this.category,
    required this.headline,
    required this.content,
    required this.expandedContent,
    this.saved = false,
    this.liked = false,
    this.shared = false,
    required this.likeCount,
    required this.saveCount,
  });

  ContentItem copyWith({
    int? id,
    String? category,
    String? headline,
    String? content,
    String? expandedContent,
    bool? saved,
    bool? liked,
    bool? shared,
    int? likeCount,
    int? saveCount,
  }) {
    return ContentItem(
      id: id ?? this.id,
      category: category ?? this.category,
      headline: headline ?? this.headline,
      content: content ?? this.content,
      expandedContent: expandedContent ?? this.expandedContent,
      saved: saved ?? this.saved,
      liked: liked ?? this.liked,
      shared: shared ?? this.shared,
      likeCount: likeCount ?? this.likeCount,
      saveCount: saveCount ?? this.saveCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'headline': headline,
      'content': content,
      'expandedContent': expandedContent,
      'saved': saved,
      'liked': liked,
      'shared': shared,
      'likeCount': likeCount,
      'saveCount': saveCount,
    };
  }

  factory ContentItem.fromJson(Map<String, dynamic> json) {
    return ContentItem(
      id: json['id'] as int,
      category: json['category'] as String,
      headline: json['headline'] as String,
      content: json['content'] as String,
      expandedContent: json['expandedContent'] as String,
      saved: json['saved'] as bool? ?? false,
      liked: json['liked'] as bool? ?? false,
      shared: json['shared'] as bool? ?? false,
      likeCount: json['likeCount'] as int,
      saveCount: json['saveCount'] as int,
    );
  }
}

class UserEngagement {
  final int contentId;
  final bool liked;
  final bool saved;
  final bool shared;

  const UserEngagement({
    required this.contentId,
    this.liked = false,
    this.saved = false,
    this.shared = false,
  });
}

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final int streakCount;
  final int totalLikes;
  final int totalSaves;
  final String role;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.streakCount = 0,
    this.totalLikes = 0,
    this.totalSaves = 0,
    this.role = 'user',
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? avatar,
    int? streakCount,
    int? totalLikes,
    int? totalSaves,
    String? role,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      streakCount: streakCount ?? this.streakCount,
      totalLikes: totalLikes ?? this.totalLikes,
      totalSaves: totalSaves ?? this.totalSaves,
      role: role ?? this.role,
    );
  }

  bool get isAdmin => role == 'admin';
  bool get isModerator => role == 'moderator';

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}

/// Enum for Content Categories
enum ContentCategory {
  psychology('Psychology'),
  neuroscience('Neuroscience'),
  behavioralScience('Behavioral Science'),
  cognitiveScience('Cognitive Science'),
  philosophy('Philosophy'),
  technology('Technology'),
  ecology('Ecology'),
  economics('Economics'),
  other('Other');

  final String displayName;
  const ContentCategory(this.displayName);
}

/// Enum for Theme
enum AppThemeMode {
  light,
  dark,
  system,
}

/// Enum for Idea Status (Admin feature)
enum IdeaStatus {
  draft,
  published,
}

/// Enum for Idea Form Mode (Admin feature)
enum IdeaFormMode {
  json,
  fields,
}

/// Available idea categories (matches Next.js IDEA_CATEGORIES)
const List<String> IDEA_CATEGORIES = [
  'Psychology',
  'Neuroscience',
  'Behavioral Science',
  'Cognitive Science',
  'Philosophy',
  'Technology',
  'Ecology',
  'Economics',
  'Health',
  'Education',
  'Productivity',
  'Leadership',
];

/// Idea model for admin-created content
class Idea {
  final String id;
  final String category;
  final String title;
  final String explanation;
  final String example;
  final String takeaway;
  final String? customHeading;
  final String? customContent;
  final int likesCount;
  final int savesCount;
  final int shareCount;
  final int commentsCount;
  final IdeaStatus status;
  final String createdBy;
  final DateTime createdOn;
  final DateTime? publishedOn;
  final DateTime modifiedOn;

  const Idea({
    required this.id,
    required this.category,
    required this.title,
    required this.explanation,
    required this.example,
    required this.takeaway,
    this.customHeading,
    this.customContent,
    this.likesCount = 0,
    this.savesCount = 0,
    this.shareCount = 0,
    this.commentsCount = 0,
    required this.status,
    required this.createdBy,
    required this.createdOn,
    this.publishedOn,
    required this.modifiedOn,
  });

  Idea copyWith({
    String? id,
    String? category,
    String? title,
    String? explanation,
    String? example,
    String? takeaway,
    String? customHeading,
    String? customContent,
    int? likesCount,
    int? savesCount,
    int? shareCount,
    int? commentsCount,
    IdeaStatus? status,
    String? createdBy,
    DateTime? createdOn,
    DateTime? publishedOn,
    DateTime? modifiedOn,
  }) {
    return Idea(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      explanation: explanation ?? this.explanation,
      example: example ?? this.example,
      takeaway: takeaway ?? this.takeaway,
      customHeading: customHeading ?? this.customHeading,
      customContent: customContent ?? this.customContent,
      likesCount: likesCount ?? this.likesCount,
      savesCount: savesCount ?? this.savesCount,
      shareCount: shareCount ?? this.shareCount,
      commentsCount: commentsCount ?? this.commentsCount,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdOn: createdOn ?? this.createdOn,
      publishedOn: publishedOn ?? this.publishedOn,
      modifiedOn: modifiedOn ?? this.modifiedOn,
    );
  }
}

/// Admin Idea Input model
class AdminIdeaInput {
  final String category;
  final String title;
  final String explanation;
  final String example;
  final String takeaway;
  final String? customHeading;
  final String? customContent;
  final IdeaStatus status;

  const AdminIdeaInput({
    required this.category,
    required this.title,
    required this.explanation,
    required this.example,
    required this.takeaway,
    this.customHeading,
    this.customContent,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'title': title,
      'explanation': explanation,
      'example': example,
      'takeaway': takeaway,
      'customHeading': customHeading,
      'customContent': customContent,
      'status': status.name,
    };
  }
}

/// Saved Article model for saved page
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
