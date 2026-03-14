import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../models/content_model.dart';
import '../widgets/common/category_badge.dart';

/// Saved articles screen
class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  String _searchQuery = '';
  final _searchController = TextEditingController();

  final List<SavedArticle> _savedArticles = [
    const SavedArticle(
      id: 1,
      category: 'Psychology',
      headline: 'The Horse Effect Theory',
      preview: 'Understanding how our brains process information through metaphorical thinking...',
      savedDate: 'March 10, 2024',
    ),
    const SavedArticle(
      id: 3,
      category: 'Behavioral Science',
      headline: 'The Paradox of Choice',
      preview: 'How having too many options can lead to decision paralysis and decreased satisfaction...',
      savedDate: 'March 8, 2024',
    ),
    const SavedArticle(
      id: 5,
      category: 'Philosophy',
      headline: 'The Nature of Consciousness',
      preview: 'Exploring the hard problem of consciousness and what it means to be aware...',
      savedDate: 'March 5, 2024',
    ),
  ];

  List<SavedArticle> get _filteredArticles {
    if (_searchQuery.isEmpty) return _savedArticles;
    return _savedArticles.where((article) =>
        article.headline.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        article.category.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  void _handleRemove(int id) {
    setState(() {
      _savedArticles.removeWhere((article) => article.id == id);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = theme.brightness == Brightness.dark
        ? AppColors.darkBorder
        : AppColors.lightBorder;
    final cardColor = theme.brightness == Brightness.dark
        ? AppColors.darkCard
        : AppColors.lightCard;
    final mutedColor = theme.brightness == Brightness.dark
        ? AppColors.darkMutedForeground
        : AppColors.lightMutedForeground;
    final mutedBg = theme.brightness == Brightness.dark
        ? AppColors.darkMuted
        : AppColors.lightMuted;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            pinned: true,
            backgroundColor: theme.scaffoldBackgroundColor.withOpacity(0.8),
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
            ),
            title: const Text(
              'Saved Articles',
              style: TextStyle(
                fontSize: AppTypography.fontSize2xl,
                fontWeight: AppTypography.fontWeightBold,
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.sp4),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Search Bar
                TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Search saved articles...',
                    prefixIcon: Icon(
                      Icons.search,
                      color: mutedColor,
                    ),
                    filled: true,
                    fillColor: cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sp4,
                      vertical: AppSpacing.sp3,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sp6),

                // Articles List
                if (_filteredArticles.isNotEmpty)
                  ..._filteredArticles.map((article) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sp3),
                    child: _buildArticleCard(article),
                  ))
                else
                  // Empty State
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sp12),
                      child: Column(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: mutedBg,
                              borderRadius: BorderRadius.circular(AppRadius.lg),
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.bookmark_outline,
                              size: 24,
                              color: mutedColor,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sp4),
                          Text(
                            _searchQuery.isNotEmpty
                                ? 'No articles found'
                                : 'No saved articles yet',
                            style: TextStyle(
                              fontSize: AppTypography.fontSizeLg,
                              fontWeight: AppTypography.fontWeightSemibold,
                              color: theme.colorScheme.onBackground,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sp1),
                          Text(
                            _searchQuery.isNotEmpty
                                ? 'Try a different search term'
                                : 'Articles you save will appear here',
                            style: TextStyle(
                              fontSize: AppTypography.fontSizeSm,
                              color: mutedColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleCard(SavedArticle article) {
    final theme = Theme.of(context);
    final borderColor = theme.brightness == Brightness.dark
        ? AppColors.darkBorder
        : AppColors.lightBorder;
    final cardColor = theme.brightness == Brightness.dark
        ? AppColors.darkCard
        : AppColors.lightCard;
    final mutedColor = theme.brightness == Brightness.dark
        ? AppColors.darkMutedForeground
        : AppColors.lightMutedForeground;
    final mutedBg = theme.brightness == Brightness.dark
        ? AppColors.darkMuted.withOpacity(0.5)
        : AppColors.lightMuted.withOpacity(0.5);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // TODO: Navigate to article
        },
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.sp4),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category and Date
                    Row(
                      children: [
                        CategoryBadge(
                          category: article.category,
                          isPrimary: true,
                        ),
                        const SizedBox(width: AppSpacing.sp2),
                        Text(
                          article.savedDate,
                          style: TextStyle(
                            fontSize: AppTypography.fontSizeXs,
                            color: mutedColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sp2),
                    
                    // Headline
                    Text(
                      article.headline,
                      style: TextStyle(
                        fontWeight: AppTypography.fontWeightSemibold,
                        color: theme.colorScheme.onBackground,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.sp1),
                    
                    // Preview
                    Text(
                      article.preview,
                      style: TextStyle(
                        fontSize: AppTypography.fontSizeSm,
                        color: mutedColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              
              // Delete Button
              IconButton(
                onPressed: () => _handleRemove(article.id),
                icon: const Icon(
                  Icons.delete_outline,
                  size: 18,
                  color: AppColors.likeRed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
