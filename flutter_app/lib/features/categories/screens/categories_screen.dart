import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../feed/controllers/feed_controller.dart';
import '../../feed/models/idea.dart';
import '../../shared/widgets/shared_widgets.dart';

/// Categories screen – browse ideas by category
class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedState = ref.watch(feedControllerProvider);
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

    // Group ideas by category
    final Map<String, List<Idea>> byCategory = {};
    for (final idea in feedState.ideas) {
      byCategory.putIfAbsent(idea.category, () => []).add(idea);
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: theme.scaffoldBackgroundColor.withOpacity(0.8),
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
            ),
            title: const Text('Categories',
                style: TextStyle(
                    fontSize: AppTypography.fontSize2xl,
                    fontWeight: AppTypography.fontWeightBold)),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.sp4),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                byCategory.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sp4),
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.sp4),
                      decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                          border: Border.all(color: borderColor)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CategoryBadge(
                                  category: entry.key, isPrimary: true),
                              Text('${entry.value.length} articles',
                                  style: TextStyle(
                                      fontSize: AppTypography.fontSizeXs,
                                      color: mutedColor)),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sp3),
                          ...entry.value.map(
                            (idea) => Padding(
                              padding: const EdgeInsets.only(bottom: AppSpacing.sp2),
                              child: Text(
                                '• ${idea.headline}',
                                style: TextStyle(
                                    fontSize: AppTypography.fontSizeSm,
                                    color: theme.colorScheme.onSurface),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
