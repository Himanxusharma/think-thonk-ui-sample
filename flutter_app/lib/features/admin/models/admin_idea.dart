/// Admin idea input model
enum AdminIdeaStatus { draft, published }

enum AdminFormMode { fields, json }

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

class AdminIdea {
  final String id;
  final String category;
  final String title;
  final String explanation;
  final String example;
  final String takeaway;
  final String? customHeading;
  final String? customContent;
  final AdminIdeaStatus status;
  final String createdBy;
  final DateTime createdOn;
  final DateTime? publishedOn;
  final DateTime modifiedOn;

  const AdminIdea({
    required this.id,
    required this.category,
    required this.title,
    required this.explanation,
    required this.example,
    required this.takeaway,
    this.customHeading,
    this.customContent,
    required this.status,
    required this.createdBy,
    required this.createdOn,
    this.publishedOn,
    required this.modifiedOn,
  });

  AdminIdea copyWith({
    AdminIdeaStatus? status,
    DateTime? publishedOn,
    DateTime? modifiedOn,
  }) {
    return AdminIdea(
      id: id,
      category: category,
      title: title,
      explanation: explanation,
      example: example,
      takeaway: takeaway,
      customHeading: customHeading,
      customContent: customContent,
      status: status ?? this.status,
      createdBy: createdBy,
      createdOn: createdOn,
      publishedOn: publishedOn ?? this.publishedOn,
      modifiedOn: modifiedOn ?? this.modifiedOn,
    );
  }
}
