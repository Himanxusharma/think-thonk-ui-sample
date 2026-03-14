import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../models/idea.dart';
import '../../shared/widgets/shared_widgets.dart';

/// Content card – one full-page item in the feed
class ContentCard extends StatelessWidget {
  final Idea idea;
  final VoidCallback onReadMore;
  final VoidCallback onSave;
  final VoidCallback onLike;
  final VoidCallback onShare;
  final VoidCallback onFullscreen;

  const ContentCard({
    super.key,
    required this.idea,
    required this.onReadMore,
    required this.onSave,
    required this.onLike,
    required this.onShare,
    required this.onFullscreen,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < AppBreakpoints.sm;

    return Container(
      width: double.infinity,
      height: size.height,
      color: theme.scaffoldBackgroundColor,
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? AppSpacing.sp4 : AppSpacing.sp6,
        vertical: isSmall ? AppSpacing.sp8 : AppSpacing.sp12,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppUI.cardMaxWidth),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top Section ────────────────────────────────────────────────
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CategoryBadge(category: idea.category),
                    SizedBox(
                        height:
                            isSmall ? AppSpacing.sp4 : AppSpacing.sp6),
                    Text(
                      idea.headline,
                      style: TextStyle(
                        fontSize: isSmall
                            ? AppTypography.fontSize3xl
                            : size.width >= AppBreakpoints.lg
                                ? AppTypography.fontSize5xl
                                : AppTypography.fontSize4xl,
                        fontWeight: AppTypography.fontWeightBold,
                        height: AppTypography.lineHeightTight,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(
                        height:
                            isSmall ? AppSpacing.sp4 : AppSpacing.sp6),
                    Text(
                      idea.content,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: isSmall
                            ? AppTypography.fontSizeSm
                            : size.width >= AppBreakpoints.lg
                                ? AppTypography.fontSizeLg
                                : AppTypography.fontSizeBase,
                        height: AppTypography.lineHeightRelaxed,
                        color:
                            theme.colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sp4),
                    GestureDetector(
                      onTap: onReadMore,
                      child: Text(
                        'Read More →',
                        style: TextStyle(
                          fontSize: isSmall
                              ? AppTypography.fontSizeXs
                              : AppTypography.fontSizeSm,
                          fontWeight: AppTypography.fontWeightMedium,
                          color: theme.colorScheme.onSurface,
                          decoration: TextDecoration.underline,
                          decorationColor: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Bottom Action Row ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sp8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ActionButton(
                      icon: idea.saved
                          ? Icons.bookmark
                          : Icons.bookmark_outline,
                      label: 'Save',
                      count: idea.saveCount,
                      isActive: idea.saved,
                      onPressed: onSave,
                    ),
                    SizedBox(
                        width: isSmall
                            ? AppSpacing.sp6
                            : AppSpacing.sp8),
                    ActionButton(
                      icon: idea.liked
                          ? Icons.favorite
                          : Icons.favorite_outline,
                      label: 'Like',
                      count: idea.likeCount,
                      isActive: idea.liked,
                      activeColor: AppColors.likeRed,
                      onPressed: onLike,
                    ),
                    SizedBox(
                        width: isSmall
                            ? AppSpacing.sp6
                            : AppSpacing.sp8),
                    ActionButton(
                      icon: Icons.share_outlined,
                      label: 'Share',
                      onPressed: onShare,
                    ),
                    SizedBox(
                        width: isSmall
                            ? AppSpacing.sp6
                            : AppSpacing.sp8),
                    ActionButton(
                      icon: Icons.fullscreen,
                      label: 'Focus',
                      onPressed: onFullscreen,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
