/// Feed domain models
/// Mirrors ContentItem from the Next.js web app

class Idea {
  final int id;
  final String category;
  final String headline;
  final String content;
  final String expandedContent;
  final bool saved;
  final bool liked;
  final bool shared;
  final int likeCount;
  final int saveCount;

  const Idea({
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

  Idea copyWith({
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
    return Idea(
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

  Map<String, dynamic> toJson() => {
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

  factory Idea.fromJson(Map<String, dynamic> json) => Idea(
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

/// Content category enum
enum ContentCategory {
  psychology('Psychology'),
  neuroscience('Neuroscience'),
  behavioralScience('Behavioral Science'),
  cognitiveScience('Cognitive Science'),
  philosophy('Philosophy'),
  technology('Technology'),
  ecology('Ecology'),
  economics('Economics'),
  health('Health'),
  education('Education'),
  productivity('Productivity'),
  leadership('Leadership'),
  other('Other');

  final String displayName;
  const ContentCategory(this.displayName);
}

/// Available categories list (matches Next.js IDEA_CATEGORIES)
const List<String> ideaCategories = [
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
