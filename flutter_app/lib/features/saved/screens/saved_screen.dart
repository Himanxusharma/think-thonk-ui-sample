import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../shared/widgets/shared_widgets.dart';
import '../../saved/controllers/saved_controller.dart';

class SavedScreen extends ConsumerStatefulWidget {
  const SavedScreen({super.key});

  @override
  ConsumerState<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends ConsumerState<SavedScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final savedState = ref.watch(savedControllerProvider);
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
          SliverAppBar(
            pinned: true,
            backgroundColor: theme.scaffoldBackgroundColor.withOpacity(0.8),
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
            ),
            title: const Text('Saved Articles',
                style: TextStyle(
                    fontSize: AppTypography.fontSize2xl,
                    fontWeight: AppTypography.fontWeightBold)),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.sp4),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Search
                TextField(
                  controller: _searchController,
                  onChanged: (v) => ref
                      .read(savedControllerProvider.notifier)
                      .setSearch(v),
                  decoration: InputDecoration(
                    hintText: 'Search saved articles...',
                    prefixIcon: Icon(Icons.search, color: mutedColor),
                    filled: true,
                    fillColor: cardColor,
                    border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppRadius.lg),
                        borderSide: BorderSide(color: borderColor)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppRadius.lg),
                        borderSide: BorderSide(color: borderColor)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sp4,
                        vertical: AppSpacing.sp3),
                  ),
                ),
                const SizedBox(height: AppSpacing.sp6),

                if (savedState.filtered.isNotEmpty)
                  ...savedState.filtered.map((article) => Padding(
                    padding:
                        const EdgeInsets.only(bottom: AppSpacing.sp3),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius:
                            BorderRadius.circular(AppRadius.lg),
                        onTap: () {},
                        child: Container(
                          padding:
                              const EdgeInsets.all(AppSpacing.sp4),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius:
                                BorderRadius.circular(AppRadius.lg),
                            border:
                                Border.all(color: borderColor),
                          ),
                          child: Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                      CategoryBadge(
                                          category: article.category,
                                          isPrimary: true),
                                      const SizedBox(
                                          width: AppSpacing.sp2),
                                      Text(article.savedDate,
                                          style: TextStyle(
                                              fontSize:
                                                  AppTypography.fontSizeXs,
                                              color: mutedColor)),
                                    ]),
                                    const SizedBox(height: AppSpacing.sp2),
                                    Text(article.headline,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontWeight:
                                                AppTypography.fontWeightSemibold,
                                            color: theme
                                                .colorScheme.onSurface)),
                                    const SizedBox(height: AppSpacing.sp1),
                                    Text(article.preview,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize:
                                                AppTypography.fontSizeSm,
                                            color: mutedColor)),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () => ref
                                    .read(savedControllerProvider
                                        .notifier)
                                    .remove(article.id),
                                icon: const Icon(
                                    Icons.delete_outline,
                                    size: 18,
                                    color: AppColors.likeRed),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ))
                else
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.sp12),
                      child: Column(children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                              color: mutedBg,
                              borderRadius:
                                  BorderRadius.circular(AppRadius.lg)),
                          alignment: Alignment.center,
                          child: Icon(Icons.bookmark_outline,
                              size: 24, color: mutedColor),
                        ),
                        const SizedBox(height: AppSpacing.sp4),
                        Text(
                          savedState.searchQuery.isNotEmpty
                              ? 'No articles found'
                              : 'No saved articles yet',
                          style: TextStyle(
                              fontSize: AppTypography.fontSizeLg,
                              fontWeight:
                                  AppTypography.fontWeightSemibold,
                              color: theme.colorScheme.onSurface),
                        ),
                        const SizedBox(height: AppSpacing.sp1),
                        Text(
                          savedState.searchQuery.isNotEmpty
                              ? 'Try a different search term'
                              : 'Articles you save will appear here',
                          style: TextStyle(
                              fontSize: AppTypography.fontSizeSm,
                              color: mutedColor),
                        ),
                      ]),
                    ),
                  ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
