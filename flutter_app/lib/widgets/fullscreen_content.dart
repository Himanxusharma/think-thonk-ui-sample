import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/constants/app_constants.dart';
import '../models/content_model.dart';
import 'common/category_badge.dart';

/// Fullscreen/Focus mode content viewer
class FullscreenContent extends StatefulWidget {
  final List<ContentItem> content;
  final int initialIndex;
  final VoidCallback onClose;
  final Function(int) onSave;
  final Function(int) onLike;
  final Function(int) onShare;
  final int streak;

  const FullscreenContent({
    super.key,
    required this.content,
    required this.initialIndex,
    required this.onClose,
    required this.onSave,
    required this.onLike,
    required this.onShare,
    required this.streak,
  });

  @override
  State<FullscreenContent> createState() => _FullscreenContentState();
}

class _FullscreenContentState extends State<FullscreenContent> {
  late PageController _pageController;
  late int _currentIndex;
  DateTime? _lastSnapTime;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    HardwareKeyboard.instance.addHandler(_handleKey);
  }

  @override
  void dispose() {
    _pageController.dispose();
    HardwareKeyboard.instance.removeHandler(_handleKey);
    super.dispose();
  }

  bool _handleKey(KeyEvent event) {
    if (event is KeyDownEvent && 
        event.logicalKey == LogicalKeyboardKey.escape) {
      widget.onClose();
      return true;
    }
    return false;
  }

  void _onPageChanged(int index) {
    final now = DateTime.now();
    if (_lastSnapTime != null && 
        now.difference(_lastSnapTime!).inMilliseconds < AppUI.autoScrollDebounce) {
      return;
    }
    _lastSnapTime = now;
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = theme.brightness == Brightness.dark
        ? AppColors.darkBorder
        : AppColors.lightBorder;
    final mutedColor = theme.brightness == Brightness.dark
        ? AppColors.darkMutedForeground
        : AppColors.lightMutedForeground;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // Content Area
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              onPageChanged: _onPageChanged,
              itemCount: widget.content.length,
              itemBuilder: (context, index) {
                return _buildContentPage(context, widget.content[index]);
              },
            ),
          ),
          
          // Bottom Navigation Bar
          Container(
            height: AppUI.bottomNavHeight,
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              border: Border(
                top: BorderSide(color: borderColor),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sp4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Streak Display
                Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      color: AppColors.streakOrange,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.sp2),
                    Text(
                      widget.streak.toString(),
                      style: TextStyle(
                        fontSize: AppTypography.fontSizeSm,
                        fontWeight: AppTypography.fontWeightSemibold,
                        color: theme.colorScheme.onBackground,
                      ),
                    ),
                  ],
                ),
                
                // Action Buttons
                Row(
                  children: [
                    // Save Button
                    _buildActionButton(
                      icon: widget.content[_currentIndex].saved
                          ? Icons.bookmark
                          : Icons.bookmark_outline,
                      count: widget.content[_currentIndex].saveCount,
                      isActive: widget.content[_currentIndex].saved,
                      onPressed: () => widget.onSave(widget.content[_currentIndex].id),
                    ),
                    const SizedBox(width: AppSpacing.sp4),
                    
                    // Like Button
                    _buildActionButton(
                      icon: widget.content[_currentIndex].liked
                          ? Icons.favorite
                          : Icons.favorite_outline,
                      count: widget.content[_currentIndex].likeCount,
                      isActive: widget.content[_currentIndex].liked,
                      activeColor: AppColors.likeRed,
                      onPressed: () => widget.onLike(widget.content[_currentIndex].id),
                    ),
                    const SizedBox(width: AppSpacing.sp4),
                    
                    // Share Button
                    IconButton(
                      onPressed: () => widget.onShare(widget.content[_currentIndex].id),
                      icon: Icon(
                        Icons.share_outlined,
                        size: 20,
                        color: mutedColor,
                      ),
                    ),
                    
                    // Close Button
                    IconButton(
                      onPressed: widget.onClose,
                      icon: Icon(
                        Icons.close,
                        size: 24,
                        color: theme.colorScheme.onBackground,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required int count,
    required bool isActive,
    Color? activeColor,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);
    final mutedColor = theme.brightness == Brightness.dark
        ? AppColors.darkMutedForeground
        : AppColors.lightMutedForeground;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sp2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: isActive 
                    ? (activeColor ?? theme.colorScheme.onBackground) 
                    : mutedColor,
              ),
              const SizedBox(height: 2),
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: AppTypography.fontSizeXs,
                  color: mutedColor.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentPage(BuildContext context, ContentItem item) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints(minHeight: size.height - AppUI.bottomNavHeight),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppUI.modalMaxWidth),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width < AppBreakpoints.sm 
                    ? AppSpacing.sp4 
                    : AppSpacing.sp6,
                vertical: AppSpacing.sp12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Category
                  CategoryBadge(category: item.category),
                  const SizedBox(height: AppSpacing.sp8),
                  
                  // Headline
                  Text(
                    item.headline,
                    style: TextStyle(
                      fontSize: size.width >= AppBreakpoints.md
                          ? AppTypography.fontSize6xl
                          : AppTypography.fontSize5xl,
                      fontWeight: AppTypography.fontWeightBold,
                      height: AppTypography.lineHeightTight,
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sp8),
                  
                  // Expanded Content
                  _buildExpandedContent(context, item),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedContent(BuildContext context, ContentItem item) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final paragraphs = item.expandedContent.split('\n\n');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: paragraphs.map((paragraph) {
        // Check if paragraph contains a colon (section header)
        if (paragraph.contains(':')) {
          final parts = paragraph.split(':');
          final header = parts[0];
          
          // Check for bullet points
          if (paragraph.contains('- ')) {
            final lines = paragraph.split('\n');
            final bulletLines = lines
                .where((line) => line.trim().startsWith('- '))
                .toList();
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$header:',
                  style: TextStyle(
                    fontSize: AppTypography.fontSizeLg,
                    fontWeight: AppTypography.fontWeightSemibold,
                    height: AppTypography.lineHeightRelaxed,
                    color: theme.colorScheme.onBackground.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: AppSpacing.sp4),
                ...bulletLines.map((line) => Padding(
                  padding: const EdgeInsets.only(
                    left: AppSpacing.sp4,
                    bottom: AppSpacing.sp3,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(fontSize: 18)),
                      Expanded(
                        child: Text(
                          line.replaceFirst('- ', '').trim(),
                          style: TextStyle(
                            fontSize: size.width >= AppBreakpoints.md
                                ? AppTypography.fontSizeLg
                                : AppTypography.fontSizeBase,
                            height: AppTypography.lineHeightRelaxed,
                            color: theme.colorScheme.onBackground.withOpacity(0.75),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
                const SizedBox(height: AppSpacing.sp6),
              ],
            );
          }
        }

        // Regular paragraph
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sp6),
          child: Text(
            paragraph,
            style: TextStyle(
              fontSize: size.width >= AppBreakpoints.md
                  ? AppTypography.fontSizeLg
                  : AppTypography.fontSizeBase,
              height: AppTypography.lineHeightRelaxed,
              color: theme.colorScheme.onBackground.withOpacity(0.8),
            ),
          ),
        );
      }).toList(),
    );
  }
}
