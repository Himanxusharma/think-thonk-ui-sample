import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../models/admin_idea.dart';

/// Admin idea creation form – matches the Next.js fields-editor / JSON-editor
class IdeaForm extends StatefulWidget {
  final Function(AdminIdea) onSuccess;

  const IdeaForm({super.key, required this.onSuccess});

  @override
  State<IdeaForm> createState() => _IdeaFormState();
}

class _IdeaFormState extends State<IdeaForm> {
  AdminFormMode _mode = AdminFormMode.fields;
  bool _isLoading = false;
  String? _error;
  String? _success;
  final Map<String, String> _fieldErrors = {};

  String _category = '';
  final _titleCtrl = TextEditingController();
  final _explanationCtrl = TextEditingController();
  final _exampleCtrl = TextEditingController();
  final _takeawayCtrl = TextEditingController();
  final _customHeadingCtrl = TextEditingController();
  final _customContentCtrl = TextEditingController();
  final _jsonCtrl = TextEditingController();

  @override
  void dispose() {
    for (final c in [
      _titleCtrl, _explanationCtrl, _exampleCtrl,
      _takeawayCtrl, _customHeadingCtrl, _customContentCtrl, _jsonCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  bool _validate() {
    _fieldErrors.clear();
    if (_category.isEmpty) _fieldErrors['category'] = 'Category is required';
    if (_titleCtrl.text.trim().isEmpty) _fieldErrors['title'] = 'Title is required';
    if (_explanationCtrl.text.trim().isEmpty) _fieldErrors['explanation'] = 'Explanation is required';
    if (_exampleCtrl.text.trim().isEmpty) _fieldErrors['example'] = 'Example is required';
    if (_takeawayCtrl.text.trim().isEmpty) _fieldErrors['takeaway'] = 'Takeaway is required';
    setState(() {});
    return _fieldErrors.isEmpty;
  }

  Future<void> _submit(bool publish) async {
    setState(() { _isLoading = true; _error = null; _success = null; });

    if (_mode == AdminFormMode.fields && !_validate()) {
      setState(() => _isLoading = false);
      return;
    }

    final now = DateTime.now();
    final idea = AdminIdea(
      id: now.millisecondsSinceEpoch.toString(),
      category: _mode == AdminFormMode.fields ? _category : 'Technology',
      title: _mode == AdminFormMode.fields
          ? _titleCtrl.text.trim()
          : 'JSON Idea',
      explanation: _mode == AdminFormMode.fields
          ? _explanationCtrl.text.trim()
          : _jsonCtrl.text.substring(0, _jsonCtrl.text.length.clamp(0, 100)),
      example: _mode == AdminFormMode.fields ? _exampleCtrl.text.trim() : 'Example',
      takeaway: _mode == AdminFormMode.fields ? _takeawayCtrl.text.trim() : 'Takeaway',
      customHeading: _customHeadingCtrl.text.trim().isEmpty
          ? null
          : _customHeadingCtrl.text.trim(),
      customContent: _customContentCtrl.text.trim().isEmpty
          ? null
          : _customContentCtrl.text.trim(),
      status: publish ? AdminIdeaStatus.published : AdminIdeaStatus.draft,
      createdBy: 'admin_001',
      createdOn: now,
      modifiedOn: now,
      publishedOn: publish ? now : null,
    );

    widget.onSuccess(idea);
    _reset();

    setState(() {
      _isLoading = false;
      _success = publish
          ? '✓ Idea published successfully!'
          : '✓ Draft saved successfully!';
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _success = null);
    });
  }

  void _reset() {
    _category = '';
    for (final c in [
      _titleCtrl, _explanationCtrl, _exampleCtrl,
      _takeawayCtrl, _customHeadingCtrl, _customContentCtrl, _jsonCtrl,
    ]) {
      c.clear();
    }
    _fieldErrors.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = theme.brightness == Brightness.dark
        ? AppColors.darkBorder
        : AppColors.lightBorder;
    final mutedBg = theme.brightness == Brightness.dark
        ? AppColors.darkMuted
        : AppColors.lightMuted;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mode toggle
        Row(children: [
          _ModeBtn('Fields', AdminFormMode.fields, _mode,
              () => setState(() { _mode = AdminFormMode.fields; _error = null; _success = null; })),
          const SizedBox(width: AppSpacing.sp2),
          _ModeBtn('JSON', AdminFormMode.json, _mode,
              () => setState(() { _mode = AdminFormMode.json; _error = null; _success = null; })),
        ]),
        const SizedBox(height: AppSpacing.sp6),

        if (_mode == AdminFormMode.fields)
          _FieldsForm(
            category: _category,
            onCategoryChanged: (v) => setState(() { _category = v; _fieldErrors.remove('category'); }),
            titleCtrl: _titleCtrl,
            explanationCtrl: _explanationCtrl,
            exampleCtrl: _exampleCtrl,
            takeawayCtrl: _takeawayCtrl,
            customHeadingCtrl: _customHeadingCtrl,
            customContentCtrl: _customContentCtrl,
            errors: _fieldErrors,
            onFieldChanged: (key) => setState(() => _fieldErrors.remove(key)),
          )
        else
          _JsonForm(ctrl: _jsonCtrl, borderColor: borderColor),

        if (_error != null) ...[
          const SizedBox(height: AppSpacing.sp4),
          _Alert(_error!, AppColors.likeRed),
        ],
        if (_success != null) ...[
          const SizedBox(height: AppSpacing.sp4),
          _Alert(_success!, AppColors.successGreen),
        ],

        const SizedBox(height: AppSpacing.sp6),
        Container(
          padding: const EdgeInsets.only(top: AppSpacing.sp6),
          decoration: BoxDecoration(border: Border(top: BorderSide(color: borderColor))),
          child: Row(children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _isLoading ? null : () => _submit(false),
                style: OutlinedButton.styleFrom(
                    backgroundColor: mutedBg,
                    side: BorderSide.none,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sp3)),
                child: _isLoading
                    ? const SizedBox(width: 16, height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Save as Draft'),
              ),
            ),
            const SizedBox(width: AppSpacing.sp3),
            Expanded(
              child: ElevatedButton(
                onPressed: _isLoading ? null : () => _submit(true),
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sp3)),
                child: _isLoading
                    ? const SizedBox(width: 16, height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Publish Now'),
              ),
            ),
          ]),
        ),
      ],
    );
  }
}

class _ModeBtn extends StatelessWidget {
  final String label;
  final AdminFormMode mode;
  final AdminFormMode currentMode;
  final VoidCallback onTap;
  const _ModeBtn(this.label, this.mode, this.currentMode, this.onTap);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selected = mode == currentMode;
    final mutedBg = theme.brightness == Brightness.dark ? AppColors.darkMuted : AppColors.lightMuted;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sp4, vertical: AppSpacing.sp2),
          decoration: BoxDecoration(
              color: selected ? theme.colorScheme.primary : mutedBg,
              borderRadius: BorderRadius.circular(AppRadius.lg)),
          child: Text(label,
              style: TextStyle(
                  fontSize: AppTypography.fontSizeSm,
                  fontWeight: AppTypography.fontWeightMedium,
                  color: selected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurface)),
        ),
      ),
    );
  }
}

class _Alert extends StatelessWidget {
  final String message;
  final Color color;
  const _Alert(this.message, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sp4),
      decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: color.withOpacity(0.2))),
      child: Text(message,
          style: TextStyle(fontSize: AppTypography.fontSizeSm, color: color)),
    );
  }
}

class _FieldsForm extends StatelessWidget {
  final String category;
  final Function(String) onCategoryChanged;
  final TextEditingController titleCtrl;
  final TextEditingController explanationCtrl;
  final TextEditingController exampleCtrl;
  final TextEditingController takeawayCtrl;
  final TextEditingController customHeadingCtrl;
  final TextEditingController customContentCtrl;
  final Map<String, String> errors;
  final Function(String) onFieldChanged;

  const _FieldsForm({
    required this.category,
    required this.onCategoryChanged,
    required this.titleCtrl,
    required this.explanationCtrl,
    required this.exampleCtrl,
    required this.takeawayCtrl,
    required this.customHeadingCtrl,
    required this.customContentCtrl,
    required this.errors,
    required this.onFieldChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = theme.brightness == Brightness.dark
        ? AppColors.darkBorder
        : AppColors.lightBorder;

    Widget fieldLabel(String label, {bool required = true}) {
      final mutedColor = theme.brightness == Brightness.dark
          ? AppColors.darkMutedForeground
          : AppColors.lightMutedForeground;
      return Row(children: [
        Text(label,
            style: TextStyle(
                fontSize: AppTypography.fontSizeSm,
                fontWeight: AppTypography.fontWeightMedium,
                color: theme.colorScheme.onSurface)),
        if (required)
          const Text(' *',
              style: TextStyle(color: AppColors.likeRed,
                  fontWeight: AppTypography.fontWeightMedium))
        else
          Text(' (Optional)',
              style: TextStyle(
                  fontSize: AppTypography.fontSizeXs, color: mutedColor)),
      ]);
    }

    Widget fieldError(String key) {
      if (!errors.containsKey(key)) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.only(top: AppSpacing.sp1),
        child: Text(errors[key]!,
            style: const TextStyle(
                fontSize: AppTypography.fontSizeXs,
                color: AppColors.likeRed)),
      );
    }

    InputDecoration dec(String hint, String key) {
      final hasError = errors.containsKey(key);
      return InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            borderSide: BorderSide(
                color: hasError ? AppColors.likeRed : borderColor)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            borderSide: BorderSide(
                color: hasError ? AppColors.likeRed : borderColor)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            borderSide: BorderSide(
                color: hasError
                    ? AppColors.likeRed
                    : theme.colorScheme.primary,
                width: 2)),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sp3, vertical: AppSpacing.sp2),
      );
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      fieldLabel('Category'),
      const SizedBox(height: AppSpacing.sp2),
      DropdownButtonFormField<String>(
        value: category.isEmpty ? null : category,
        decoration: dec('Select a category', 'category'),
        items: ideaCategories
            .map((c) => DropdownMenuItem(value: c, child: Text(c)))
            .toList(),
        onChanged: (v) => onCategoryChanged(v ?? ''),
      ),
      fieldError('category'),
      const SizedBox(height: AppSpacing.sp6),
      fieldLabel('Title'),
      const SizedBox(height: AppSpacing.sp2),
      TextField(controller: titleCtrl, decoration: dec('Enter a compelling title', 'title'),
          onChanged: (_) => onFieldChanged('title')),
      fieldError('title'),
      const SizedBox(height: AppSpacing.sp6),
      fieldLabel('Explanation'),
      const SizedBox(height: AppSpacing.sp2),
      TextField(controller: explanationCtrl, maxLines: 4,
          decoration: dec('Provide a detailed explanation of the concept', 'explanation'),
          onChanged: (_) => onFieldChanged('explanation')),
      fieldError('explanation'),
      const SizedBox(height: AppSpacing.sp6),
      fieldLabel('Example'),
      const SizedBox(height: AppSpacing.sp2),
      TextField(controller: exampleCtrl, maxLines: 3,
          decoration: dec('Provide a real-world or practical example', 'example'),
          onChanged: (_) => onFieldChanged('example')),
      fieldError('example'),
      const SizedBox(height: AppSpacing.sp6),
      fieldLabel('Key Takeaway'),
      const SizedBox(height: AppSpacing.sp2),
      TextField(controller: takeawayCtrl, maxLines: 2,
          decoration: dec('What should readers remember most?', 'takeaway'),
          onChanged: (_) => onFieldChanged('takeaway')),
      fieldError('takeaway'),
      const SizedBox(height: AppSpacing.sp6),
      fieldLabel('Custom Heading', required: false),
      const SizedBox(height: AppSpacing.sp2),
      TextField(controller: customHeadingCtrl,
          decoration: dec('Additional section heading', 'customHeading')),
      const SizedBox(height: AppSpacing.sp6),
      fieldLabel('Custom Content', required: false),
      const SizedBox(height: AppSpacing.sp2),
      TextField(controller: customContentCtrl, maxLines: 3,
          decoration: dec('Additional custom content or notes', 'customContent')),
    ]);
  }
}

class _JsonForm extends StatelessWidget {
  final TextEditingController ctrl;
  final Color borderColor;
  const _JsonForm({required this.ctrl, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text('JSON Content',
            style: TextStyle(
                fontSize: AppTypography.fontSizeSm,
                fontWeight: AppTypography.fontWeightMedium,
                color: theme.colorScheme.onSurface)),
        const Text(' *',
            style: TextStyle(
                color: AppColors.likeRed,
                fontWeight: AppTypography.fontWeightMedium)),
      ]),
      const SizedBox(height: AppSpacing.sp2),
      TextField(
        controller: ctrl,
        maxLines: 12,
        style: TextStyle(
            fontSize: AppTypography.fontSizeSm,
            fontFamily: 'monospace',
            color: theme.colorScheme.onSurface),
        decoration: InputDecoration(
          hintText:
              '{\n  "category": "Psychology",\n  "title": "...",\n  "explanation": "...",\n  "example": "...",\n  "takeaway": "..."\n}',
          hintStyle: const TextStyle(fontFamily: 'monospace'),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              borderSide: BorderSide(color: borderColor)),
          contentPadding: const EdgeInsets.all(AppSpacing.sp4),
        ),
      ),
    ]);
  }
}
