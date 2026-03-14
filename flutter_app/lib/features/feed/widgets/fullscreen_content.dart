import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_constants.dart';
import '../models/idea.dart';
import '../../shared/widgets/shared_widgets.dart';

/// Fullscreen / Focus mode – vertical snap-scroll reader
class FullscreenContent extends StatefulWidget {
  final List<Idea> ideas;
  final int initialIndex;
  final VoidCallback onClose;
  final Function(int) onSave;
  final Function(int) onLike;
  final Function(Idea) onShare;
  final int streak;

  const FullscreenContent({
    super.key,
    required this.ideas,
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
        now.difference(_lastSnapTime!).inMilliseconds <
            AppUI.autoScrollDebounce) return;
    _lastSnapTime = now;
    setState(() => _currentIndex = index);
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

    final current = widget.ideas[_currentIndex];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // Content pager
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              onPageChanged: _onPageChanged,
              itemCount: widget.ideas.length,
              itemBuilder: (context, index) =>
                  _buildPage(context, widget.ideas[index]),
            ),
          ),

          // Bottom bar
          Container(
            height: AppUI.bottomNavHeight,
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              border: Border(top: BorderSide(color: borderColor)),
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: AppSpacing.sp4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Streak
                Row(
                  children: [
                    const Icon(Icons.local_fire_department,
                        color: AppColors.streakOrange, size: 20),
                    const SizedBox(width: AppSpacing.sp2),
                    Text(
                      widget.streak.toString(),
                      style: TextStyle(
                        fontSize: AppTypography.fontSizeSm,
                        fontWeight: AppTypography.fontWeightSemibold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                // Actions
                Row(
                  children: [
                    _ActionBtn(
                      icon: current.saved
                          ? Icons.bookmark
                          : Icons.bookmark_outline,
                      count: current.saveCount,
                      isActive: current.saved,
                      onPressed: () => widget.onSave(current.id),
                    ),
                    const SizedBox(width: AppSpacing.sp4),
                    _ActionBtn(
                      icon: current.liked
                          ? Icons.favorite
                          : Icons.favorite_outline,
                      count: current.likeCount,
                      isActive: current.liked,
                      activeColor: AppColors.likeRed,
                      onPressed: () => widget.onLike(current.id),
                    ),
                    const SizedBox(width: AppSpacing.sp4),
                    IconButton(
                      onPressed: () => widget.onShare(current),
                      icon: Icon(Icons.share_outlined,
                          size: 20, color: mutedColor),
                    ),
                    IconButton(
                      onPressed: widget.onClose,
                      icon: Icon(Icons.close,
                          size: 24,
                          color: theme.colorScheme.onSurface),
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

  Widget _buildPage(BuildContext context, Idea idea) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints(
            minHeight: size.height - AppUI.bottomNavHeight),
        child: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: AppUI.modalMaxWidth),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width < AppBreakpoints.sm
                    ? AppSpacing.sp4
                    : AppSpacing.sp6,
                vertical: AppSpacing.sp12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CategoryBadge(category: idea.category),
                  const SizedBox(height: AppSpacing.sp8),
                  Text(
                    idea.headline,
                    style: TextStyle(
                      fontSize: size.width >= AppBreakpoints.md
                          ? AppTypography.fontSize6xl
                          : AppTypography.fontSize5xl,
                      fontWeight: AppTypography.fontWeightBold,
                      height: AppTypography.lineHeightTight,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sp8),
                  _FullscreenExpandedContent(
                      idea: idea, theme: theme, size: size),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FullscreenExpandedContent extends StatelessWidget {
  final Idea idea;
  final ThemeData theme;
  final Size size;

  const _FullscreenExpandedContent(
      {required this.idea, required this.theme, required this.size});

  @override
  Widget build(BuildContext context) {
    final paragraphs = idea.expandedContent.split('\n\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: paragraphs.map((p) => _buildParagraph(p)).toList(),
    );
  }

  Widget _buildParagraph(String paragraph) {
    if (paragraph.contains(':') && paragraph.contains('- ')) {
      final header = paragraph.split(':')[0];
      final bulletLines = paragraph
          .split('\n')
          .where((l) => l.trim().startsWith('- '))
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
              color: theme.colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: AppSpacing.sp4),
          ...bulletLines.map(
            (line) => Padding(
              padding: const EdgeInsets.only(
                  left: AppSpacing.sp4, bottom: AppSpacing.sp3),
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
                        color:
                            theme.colorScheme.onSurface.withOpacity(0.75),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sp6),
        ],
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sp6),
      child: Text(
        paragraph,
        style: TextStyle(
          fontSize: size.width >= AppBreakpoints.md
              ? AppTypography.fontSizeLg
              : AppTypography.fontSizeBase,
          height: AppTypography.lineHeightRelaxed,
          color: theme.colorScheme.onSurface.withOpacity(0.8),
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final int count;
  final bool isActive;
  final Color? activeColor;
  final VoidCallback onPressed;

  const _ActionBtn({
    required this.icon,
    required this.count,
    required this.isActive,
    this.activeColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
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
              Icon(icon, size: 20,
                  color: isActive
                      ? (activeColor ?? theme.colorScheme.onSurface)
                      : mutedColor),
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
}
