import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_constants.dart';
import '../models/idea.dart';
import '../../shared/widgets/shared_widgets.dart';

/// Expanded modal – full article overlay
class ExpandedModal extends StatefulWidget {
  final Idea idea;
  final VoidCallback onClose;

  const ExpandedModal({super.key, required this.idea, required this.onClose});

  @override
  State<ExpandedModal> createState() => _ExpandedModalState();
}

class _ExpandedModalState extends State<ExpandedModal> {
  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_handleKey);
  }

  @override
  void dispose() {
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final borderColor = theme.brightness == Brightness.dark
        ? AppColors.darkBorder
        : AppColors.lightBorder;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor.withOpacity(0.95),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 80),
                Center(
                  child: ConstrainedBox(
                    constraints:
                        const BoxConstraints(maxWidth: AppUI.modalMaxWidth),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sp6,
                          vertical: AppSpacing.sp12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CategoryBadge(category: widget.idea.category),
                          const SizedBox(height: AppSpacing.sp8),
                          Text(
                            widget.idea.headline,
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
                          _ExpandedContent(
                              idea: widget.idea, theme: theme, size: size),
                          const SizedBox(height: AppSpacing.sp12),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Sticky close header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.sp6),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor.withOpacity(0.8),
                border:
                    Border(bottom: BorderSide(color: borderColor)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: widget.onClose,
                    icon: Icon(Icons.close,
                        size: 28,
                        color: theme.colorScheme.onSurface.withOpacity(0.6)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpandedContent extends StatelessWidget {
  final Idea idea;
  final ThemeData theme;
  final Size size;

  const _ExpandedContent(
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
                        color: theme.colorScheme.onSurface.withOpacity(0.75),
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
