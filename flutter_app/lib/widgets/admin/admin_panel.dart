import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../models/content_model.dart';
import 'idea_form.dart';

/// Admin panel with idea management
class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final List<Idea> _createdIdeas = [];
  bool _showForm = false;

  void _handleIdeaCreated(Idea idea) {
    setState(() {
      _createdIdeas.insert(0, idea);
    });
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Admin Dashboard',
                  style: TextStyle(
                    fontSize: AppTypography.fontSize3xl,
                    fontWeight: AppTypography.fontWeightBold,
                    color: theme.colorScheme.onBackground,
                  ),
                ),
                const SizedBox(height: AppSpacing.sp1),
                Text(
                  'Create and publish content ideas',
                  style: TextStyle(
                    fontSize: AppTypography.fontSizeSm,
                    color: mutedColor,
                  ),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () => setState(() => _showForm = !_showForm),
              icon: Icon(
                Icons.add,
                size: 16,
                color: _showForm 
                    ? AppColors.likeRed 
                    : theme.colorScheme.onPrimary,
              ),
              label: Text(_showForm ? 'Cancel' : 'New Idea'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _showForm
                    ? AppColors.likeRed.withOpacity(0.1)
                    : theme.colorScheme.primary,
                foregroundColor: _showForm
                    ? AppColors.likeRed
                    : theme.colorScheme.onPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sp6),

        // Form Section
        if (_showForm) ...[
          Container(
            padding: const EdgeInsets.all(AppSpacing.sp6),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create New Idea',
                  style: TextStyle(
                    fontSize: AppTypography.fontSizeXl,
                    fontWeight: AppTypography.fontWeightSemibold,
                    color: theme.colorScheme.onBackground,
                  ),
                ),
                const SizedBox(height: AppSpacing.sp6),
                IdeaForm(onSuccess: _handleIdeaCreated),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sp6),
        ],

        // Stats
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Ideas',
                _createdIdeas.length.toString(),
                theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.sp4),
            Expanded(
              child: _buildStatCard(
                'Published',
                _createdIdeas
                    .where((i) => i.status == IdeaStatus.published)
                    .length
                    .toString(),
                AppColors.successGreen,
              ),
            ),
            const SizedBox(width: AppSpacing.sp4),
            Expanded(
              child: _buildStatCard(
                'Drafts',
                _createdIdeas
                    .where((i) => i.status == IdeaStatus.draft)
                    .length
                    .toString(),
                AppColors.warningYellow,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sp6),

        // Recent Ideas List
        if (_createdIdeas.isNotEmpty) ...[
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.sp6),
                  child: Text(
                    'Recent Ideas',
                    style: TextStyle(
                      fontSize: AppTypography.fontSizeLg,
                      fontWeight: AppTypography.fontWeightSemibold,
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                ),
                Divider(height: 1, color: borderColor),
                ..._createdIdeas.map((idea) => _buildIdeaItem(idea)),
              ],
            ),
          ),
        ] else if (!_showForm) ...[
          // Empty State
          Container(
            padding: const EdgeInsets.all(AppSpacing.sp8),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: borderColor),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.add,
                    size: 32,
                    color: mutedColor.withOpacity(0.5),
                  ),
                  const SizedBox(height: AppSpacing.sp3),
                  Text(
                    'No ideas created yet. Click "New Idea" to get started.',
                    style: TextStyle(
                      color: mutedColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
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

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sp4),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: AppTypography.fontSizeSm,
              fontWeight: AppTypography.fontWeightMedium,
              color: mutedColor,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: AppSpacing.sp2),
          Text(
            value,
            style: TextStyle(
              fontSize: AppTypography.fontSize3xl,
              fontWeight: AppTypography.fontWeightBold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdeaItem(Idea idea) {
    final theme = Theme.of(context);
    final borderColor = theme.brightness == Brightness.dark
        ? AppColors.darkBorder
        : AppColors.lightBorder;
    final mutedColor = theme.brightness == Brightness.dark
        ? AppColors.darkMutedForeground
        : AppColors.lightMutedForeground;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sp6),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: borderColor),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      idea.title,
                      style: TextStyle(
                        fontWeight: AppTypography.fontWeightSemibold,
                        color: theme.colorScheme.onBackground,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sp2),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sp2,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: idea.status == IdeaStatus.published
                            ? AppColors.successGreen.withOpacity(0.1)
                            : AppColors.warningYellow.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Text(
                        idea.status == IdeaStatus.published 
                            ? 'Published' 
                            : 'Draft',
                        style: TextStyle(
                          fontSize: AppTypography.fontSizeXs,
                          fontWeight: AppTypography.fontWeightMedium,
                          color: idea.status == IdeaStatus.published
                              ? AppColors.successGreen
                              : AppColors.warningYellow,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sp1),
                Text(
                  '${idea.category} • ${_formatDate(idea.createdOn)}',
                  style: TextStyle(
                    fontSize: AppTypography.fontSizeSm,
                    color: mutedColor,
                  ),
                ),
                const SizedBox(height: AppSpacing.sp2),
                Text(
                  idea.explanation,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: AppTypography.fontSizeSm,
                    color: theme.colorScheme.onBackground.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            idea.status == IdeaStatus.published
                ? Icons.check_circle_outline
                : Icons.error_outline,
            size: 20,
            color: idea.status == IdeaStatus.published
                ? AppColors.successGreen
                : AppColors.warningYellow,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}
