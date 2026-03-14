import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/constants/app_constants.dart';
import '../models/content_model.dart';
import 'common/category_badge.dart';

/// Expanded modal for full article view
class ExpandedModal extends StatefulWidget {
  final ContentItem content;
  final VoidCallback onClose;

  const ExpandedModal({
    super.key,
    required this.content,
    required this.onClose,
  });

  @override
  State<ExpandedModal> createState() => _ExpandedModalState();
}

class _ExpandedModalState extends State<ExpandedModal> {
  @override
  void initState() {
    super.initState();
    // Handle ESC key
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
          // Scrollable Content
          SingleChildScrollView(
            child: Column(
              children: [
                // Spacer for header
                const SizedBox(height: 80),
                
                // Content
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: AppUI.modalMaxWidth,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sp6,
                        vertical: AppSpacing.sp12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category
                          CategoryBadge(category: widget.content.category),
                          const SizedBox(height: AppSpacing.sp8),
                          
                          // Headline
                          Text(
                            widget.content.headline,
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
                          _buildExpandedContent(context),
                          
                          // Spacer at bottom
                          const SizedBox(height: AppSpacing.sp12),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Sticky Header with Close Button
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.sp6),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor.withOpacity(0.8),
                border: Border(
                  bottom: BorderSide(color: borderColor),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: widget.onClose,
                    icon: Icon(
                      Icons.close,
                      size: 28,
                      color: theme.colorScheme.onBackground.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedContent(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final paragraphs = widget.content.expandedContent.split('\n\n');

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
