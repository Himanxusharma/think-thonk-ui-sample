import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../models/content_model.dart';
import 'common/action_button.dart';
import 'common/category_badge.dart';

/// Content card widget - displays individual article in feed
class ContentCard extends StatelessWidget {
  final ContentItem item;
  final VoidCallback onReadMore;
  final VoidCallback onSave;
  final VoidCallback onLike;
  final VoidCallback onShare;
  final VoidCallback onFullscreen;

  const ContentCard({
    super.key,
    required this.item,
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
              // Top Section - Content
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Badge
                    CategoryBadge(category: item.category),
                    SizedBox(height: isSmall ? AppSpacing.sp4 : AppSpacing.sp6),
                    
                    // Headline
                    Text(
                      item.headline,
                      style: TextStyle(
                        fontSize: isSmall 
                            ? AppTypography.fontSize3xl 
                            : size.width >= AppBreakpoints.lg 
                                ? AppTypography.fontSize5xl 
                                : AppTypography.fontSize4xl,
                        fontWeight: AppTypography.fontWeightBold,
                        height: AppTypography.lineHeightTight,
                        color: theme.colorScheme.onBackground,
                      ),
                    ),
                    SizedBox(height: isSmall ? AppSpacing.sp4 : AppSpacing.sp6),
                    
                    // Content Preview
                    Text(
                      item.content,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: isSmall 
                            ? AppTypography.fontSizeSm 
                            : size.width >= AppBreakpoints.lg 
                                ? AppTypography.fontSizeLg 
                                : AppTypography.fontSizeBase,
                        height: AppTypography.lineHeightRelaxed,
                        color: theme.colorScheme.onBackground.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sp4),
                    
                    // Read More Button
                    GestureDetector(
                      onTap: onReadMore,
                      child: Text(
                        'Read More →',
                        style: TextStyle(
                          fontSize: isSmall 
                              ? AppTypography.fontSizeXs 
                              : AppTypography.fontSizeSm,
                          fontWeight: AppTypography.fontWeightMedium,
                          color: theme.colorScheme.onBackground,
                          decoration: TextDecoration.underline,
                          decorationColor: theme.colorScheme.onBackground,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Bottom Section - Action Buttons
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sp8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ActionButton(
                      icon: item.saved 
                          ? Icons.bookmark 
                          : Icons.bookmark_outline,
                      label: 'Save',
                      count: item.saveCount,
                      isActive: item.saved,
                      onPressed: onSave,
                    ),
                    SizedBox(width: isSmall ? AppSpacing.sp6 : AppSpacing.sp8),
                    ActionButton(
                      icon: item.liked 
                          ? Icons.favorite 
                          : Icons.favorite_outline,
                      label: 'Like',
                      count: item.likeCount,
                      isActive: item.liked,
                      activeColor: AppColors.likeRed,
                      onPressed: onLike,
                    ),
                    SizedBox(width: isSmall ? AppSpacing.sp6 : AppSpacing.sp8),
                    ActionButton(
                      icon: Icons.share_outlined,
                      label: 'Share',
                      onPressed: onShare,
                    ),
                    SizedBox(width: isSmall ? AppSpacing.sp6 : AppSpacing.sp8),
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
