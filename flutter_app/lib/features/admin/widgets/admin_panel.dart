import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../controllers/admin_controller.dart';
import '../models/admin_idea.dart';
import 'idea_form.dart';

class AdminPanel extends ConsumerWidget {
  const AdminPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adminState = ref.watch(adminControllerProvider);
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
                Text('Admin Dashboard',
                    style: TextStyle(
                        fontSize: AppTypography.fontSize3xl,
                        fontWeight: AppTypography.fontWeightBold,
                        color: theme.colorScheme.onSurface)),
                const SizedBox(height: AppSpacing.sp1),
                Text('Create and publish content ideas',
                    style: TextStyle(
                        fontSize: AppTypography.fontSizeSm,
                        color: mutedColor)),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () =>
                  ref.read(adminControllerProvider.notifier).toggleForm(),
              icon: Icon(
                adminState.showForm ? Icons.close : Icons.add,
                size: 16,
                color: adminState.showForm
                    ? AppColors.likeRed
                    : theme.colorScheme.onPrimary,
              ),
              label: Text(adminState.showForm ? 'Cancel' : 'New Idea'),
              style: ElevatedButton.styleFrom(
                backgroundColor: adminState.showForm
                    ? AppColors.likeRed.withOpacity(0.1)
                    : theme.colorScheme.primary,
                foregroundColor: adminState.showForm
                    ? AppColors.likeRed
                    : theme.colorScheme.onPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sp6),

        // Form
        if (adminState.showForm) ...[
          Container(
            padding: const EdgeInsets.all(AppSpacing.sp6),
            decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: borderColor)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Create New Idea',
                    style: TextStyle(
                        fontSize: AppTypography.fontSizeXl,
                        fontWeight: AppTypography.fontWeightSemibold,
                        color: theme.colorScheme.onSurface)),
                const SizedBox(height: AppSpacing.sp6),
                IdeaForm(
                  onSuccess: (idea) =>
                      ref.read(adminControllerProvider.notifier).addIdea(idea),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sp6),
        ],

        // Stats
        Row(
          children: [
            Expanded(
                child: _StatCard('Total Ideas',
                    adminState.ideas.length.toString(),
                    theme.colorScheme.primary,
                    borderColor: borderColor,
                    cardColor: cardColor,
                    mutedColor: mutedColor)),
            const SizedBox(width: AppSpacing.sp4),
            Expanded(
                child: _StatCard(
                    'Published', adminState.totalPublished.toString(),
                    AppColors.successGreen,
                    borderColor: borderColor,
                    cardColor: cardColor,
                    mutedColor: mutedColor)),
            const SizedBox(width: AppSpacing.sp4),
            Expanded(
                child: _StatCard(
                    'Drafts', adminState.totalDrafts.toString(),
                    AppColors.warningYellow,
                    borderColor: borderColor,
                    cardColor: cardColor,
                    mutedColor: mutedColor)),
          ],
        ),
        const SizedBox(height: AppSpacing.sp6),

        // Ideas list
        if (adminState.ideas.isNotEmpty) ...[
          Container(
            decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: borderColor)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.sp6),
                  child: Text('Recent Ideas',
                      style: TextStyle(
                          fontSize: AppTypography.fontSizeLg,
                          fontWeight: AppTypography.fontWeightSemibold,
                          color: theme.colorScheme.onSurface)),
                ),
                Divider(height: 1, color: borderColor),
                ...adminState.ideas
                    .map((idea) => _IdeaRow(idea, borderColor, mutedColor)),
              ],
            ),
          ),
        ] else if (!adminState.showForm) ...[
          Container(
            padding: const EdgeInsets.all(AppSpacing.sp8),
            decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: borderColor)),
            child: Center(
              child: Column(children: [
                Icon(Icons.add, size: 32, color: mutedColor.withOpacity(0.5)),
                const SizedBox(height: AppSpacing.sp3),
                Text('No ideas created yet. Click "New Idea" to get started.',
                    style: TextStyle(color: mutedColor)),
              ]),
            ),
          ),
        ],
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final Color borderColor;
  final Color cardColor;
  final Color mutedColor;

  const _StatCard(this.label, this.value, this.color,
      {required this.borderColor,
      required this.cardColor,
      required this.mutedColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sp4),
      decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: borderColor)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label.toUpperCase(),
            style: TextStyle(
                fontSize: AppTypography.fontSizeSm,
                fontWeight: AppTypography.fontWeightMedium,
                color: mutedColor,
                letterSpacing: 0.5)),
        const SizedBox(height: AppSpacing.sp2),
        Text(value,
            style: TextStyle(
                fontSize: AppTypography.fontSize3xl,
                fontWeight: AppTypography.fontWeightBold,
                color: color)),
      ]),
    );
  }
}

class _IdeaRow extends StatelessWidget {
  final AdminIdea idea;
  final Color borderColor;
  final Color mutedColor;

  const _IdeaRow(this.idea, this.borderColor, this.mutedColor);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPublished = idea.status == AdminIdeaStatus.published;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sp6),
      decoration:
          BoxDecoration(border: Border(bottom: BorderSide(color: borderColor))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text(idea.title,
                      style: TextStyle(
                          fontWeight: AppTypography.fontWeightSemibold,
                          color: theme.colorScheme.onSurface)),
                  const SizedBox(width: AppSpacing.sp2),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sp2, vertical: 2),
                    decoration: BoxDecoration(
                        color: (isPublished
                                ? AppColors.successGreen
                                : AppColors.warningYellow)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppRadius.sm)),
                    child: Text(isPublished ? 'Published' : 'Draft',
                        style: TextStyle(
                            fontSize: AppTypography.fontSizeXs,
                            fontWeight: AppTypography.fontWeightMedium,
                            color: isPublished
                                ? AppColors.successGreen
                                : AppColors.warningYellow)),
                  ),
                ]),
                const SizedBox(height: AppSpacing.sp1),
                Text(
                    '${idea.category} • ${idea.createdOn.month}/${idea.createdOn.day}/${idea.createdOn.year}',
                    style: TextStyle(
                        fontSize: AppTypography.fontSizeSm, color: mutedColor)),
                const SizedBox(height: AppSpacing.sp2),
                Text(idea.explanation,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: AppTypography.fontSizeSm,
                        color: theme.colorScheme.onSurface.withOpacity(0.8))),
              ],
            ),
          ),
          Icon(
            isPublished ? Icons.check_circle_outline : Icons.error_outline,
            size: 20,
            color: isPublished ? AppColors.successGreen : AppColors.warningYellow,
          ),
        ],
      ),
    );
  }
}
