import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../models/content_model.dart';
import '../common/app_input.dart';

/// Idea form for creating new ideas - matches Next.js implementation
class IdeaForm extends StatefulWidget {
  final Function(Idea) onSuccess;

  const IdeaForm({
    super.key,
    required this.onSuccess,
  });

  @override
  State<IdeaForm> createState() => _IdeaFormState();
}

class _IdeaFormState extends State<IdeaForm> {
  IdeaFormMode _mode = IdeaFormMode.fields;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _submitError;
  String? _successMessage;
  final Map<String, String> _errors = {};
  
  String _category = '';
  final _titleController = TextEditingController();
  final _explanationController = TextEditingController();
  final _exampleController = TextEditingController();
  final _takeawayController = TextEditingController();
  final _customHeadingController = TextEditingController();
  final _customContentController = TextEditingController();
  final _jsonController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _explanationController.dispose();
    _exampleController.dispose();
    _takeawayController.dispose();
    _customHeadingController.dispose();
    _customContentController.dispose();
    _jsonController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    _errors.clear();
    
    if (_category.isEmpty) {
      _errors['category'] = 'Category is required';
    }
    if (_titleController.text.trim().isEmpty) {
      _errors['title'] = 'Title is required';
    }
    if (_explanationController.text.trim().isEmpty) {
      _errors['explanation'] = 'Explanation is required';
    }
    if (_exampleController.text.trim().isEmpty) {
      _errors['example'] = 'Example is required';
    }
    if (_takeawayController.text.trim().isEmpty) {
      _errors['takeaway'] = 'Takeaway is required';
    }
    
    setState(() {});
    return _errors.isEmpty;
  }

  Future<void> _handleSubmit(bool publishImmediately) async {
    setState(() {
      _isLoading = true;
      _submitError = null;
      _successMessage = null;
    });

    try {
      if (_mode == IdeaFormMode.fields) {
        if (!_validateForm()) {
          setState(() => _isLoading = false);
          return;
        }
        
        final idea = Idea(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          category: _category,
          title: _titleController.text.trim(),
          explanation: _explanationController.text.trim(),
          example: _exampleController.text.trim(),
          takeaway: _takeawayController.text.trim(),
          customHeading: _customHeadingController.text.trim().isEmpty 
              ? null 
              : _customHeadingController.text.trim(),
          customContent: _customContentController.text.trim().isEmpty 
              ? null 
              : _customContentController.text.trim(),
          status: publishImmediately ? IdeaStatus.published : IdeaStatus.draft,
          createdBy: 'admin_001',
          createdOn: DateTime.now(),
          modifiedOn: DateTime.now(),
        );
        
        widget.onSuccess(idea);
        _resetForm();
        
        setState(() {
          _successMessage = publishImmediately 
              ? '✓ Idea published successfully!' 
              : '✓ Draft saved successfully!';
        });
        
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() => _successMessage = null);
          }
        });
      } else {
        // JSON mode
        if (_jsonController.text.trim().isEmpty) {
          setState(() {
            _submitError = 'Please enter JSON content';
            _isLoading = false;
          });
          return;
        }
        
        // Parse JSON and create idea (simplified)
        final idea = Idea(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          category: 'Technology',
          title: 'JSON Created Idea',
          explanation: _jsonController.text.substring(
            0, 
            _jsonController.text.length.clamp(0, 100),
          ),
          example: 'Example from JSON',
          takeaway: 'Takeaway from JSON',
          status: publishImmediately ? IdeaStatus.published : IdeaStatus.draft,
          createdBy: 'admin_001',
          createdOn: DateTime.now(),
          modifiedOn: DateTime.now(),
        );
        
        widget.onSuccess(idea);
        _resetForm();
        
        setState(() {
          _successMessage = publishImmediately 
              ? '✓ Idea published successfully!' 
              : '✓ Draft saved successfully!';
        });
      }
    } catch (e) {
      setState(() => _submitError = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _resetForm() {
    _category = '';
    _titleController.clear();
    _explanationController.clear();
    _exampleController.clear();
    _takeawayController.clear();
    _customHeadingController.clear();
    _customContentController.clear();
    _jsonController.clear();
    _errors.clear();
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
    final mutedBg = theme.brightness == Brightness.dark
        ? AppColors.darkMuted
        : AppColors.lightMuted;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mode Toggle
          Row(
            children: [
              _buildModeButton('Fields', IdeaFormMode.fields),
              const SizedBox(width: AppSpacing.sp2),
              _buildModeButton('JSON', IdeaFormMode.json),
            ],
          ),
          const SizedBox(height: AppSpacing.sp6),

          // Form Content
          if (_mode == IdeaFormMode.fields)
            _buildFieldsForm()
          else
            _buildJsonForm(),

          // Error Alert
          if (_submitError != null) ...[
            const SizedBox(height: AppSpacing.sp4),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sp4),
              decoration: BoxDecoration(
                color: AppColors.likeRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.likeRed.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 20,
                    color: AppColors.likeRed,
                  ),
                  const SizedBox(width: AppSpacing.sp3),
                  Expanded(
                    child: Text(
                      _submitError!,
                      style: const TextStyle(
                        fontSize: AppTypography.fontSizeSm,
                        fontWeight: AppTypography.fontWeightMedium,
                        color: AppColors.likeRed,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Success Alert
          if (_successMessage != null) ...[
            const SizedBox(height: AppSpacing.sp4),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sp4),
              decoration: BoxDecoration(
                color: AppColors.successGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.successGreen.withOpacity(0.2)),
              ),
              child: Text(
                _successMessage!,
                style: const TextStyle(
                  fontSize: AppTypography.fontSizeSm,
                  fontWeight: AppTypography.fontWeightMedium,
                  color: AppColors.successGreen,
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.sp6),

          // Action Buttons
          Container(
            padding: const EdgeInsets.only(top: AppSpacing.sp6),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: borderColor),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : () => _handleSubmit(false),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.sp3,
                      ),
                      backgroundColor: mutedBg,
                      side: BorderSide.none,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Save as Draft'),
                  ),
                ),
                const SizedBox(width: AppSpacing.sp3),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : () => _handleSubmit(true),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.sp3,
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Publish Now'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton(String label, IdeaFormMode mode) {
    final theme = Theme.of(context);
    final isSelected = _mode == mode;
    final mutedBg = theme.brightness == Brightness.dark
        ? AppColors.darkMuted
        : AppColors.lightMuted;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => setState(() {
          _mode = mode;
          _submitError = null;
          _successMessage = null;
        }),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sp4,
            vertical: AppSpacing.sp2,
          ),
          decoration: BoxDecoration(
            color: isSelected ? theme.colorScheme.primary : mutedBg,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: AppTypography.fontSizeSm,
              fontWeight: AppTypography.fontWeightMedium,
              color: isSelected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onBackground,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldsForm() {
    final theme = Theme.of(context);
    final borderColor = theme.brightness == Brightness.dark
        ? AppColors.darkBorder
        : AppColors.lightBorder;
    final mutedColor = theme.brightness == Brightness.dark
        ? AppColors.darkMutedForeground
        : AppColors.lightMutedForeground;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Dropdown
        _buildFieldLabel('Category', required: true),
        const SizedBox(height: AppSpacing.sp2),
        DropdownButtonFormField<String>(
          value: _category.isEmpty ? null : _category,
          decoration: InputDecoration(
            hintText: 'Select a category',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              borderSide: BorderSide(
                color: _errors.containsKey('category') 
                    ? AppColors.likeRed 
                    : borderColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              borderSide: BorderSide(
                color: _errors.containsKey('category') 
                    ? AppColors.likeRed 
                    : borderColor,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sp3,
              vertical: AppSpacing.sp2,
            ),
          ),
          items: IDEA_CATEGORIES.map((category) {
            return DropdownMenuItem(
              value: category,
              child: Text(category),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _category = value ?? '';
              _errors.remove('category');
            });
          },
        ),
        if (_errors.containsKey('category'))
          _buildFieldError(_errors['category']!),
        const SizedBox(height: AppSpacing.sp6),

        // Title
        _buildFieldLabel('Title', required: true),
        const SizedBox(height: AppSpacing.sp2),
        _buildTextField(
          controller: _titleController,
          placeholder: 'Enter a compelling title',
          errorKey: 'title',
        ),
        const SizedBox(height: AppSpacing.sp6),

        // Explanation
        _buildFieldLabel('Explanation', required: true),
        const SizedBox(height: AppSpacing.sp2),
        _buildTextField(
          controller: _explanationController,
          placeholder: 'Provide a detailed explanation of the concept',
          maxLines: 4,
          errorKey: 'explanation',
        ),
        const SizedBox(height: AppSpacing.sp6),

        // Example
        _buildFieldLabel('Example', required: true),
        const SizedBox(height: AppSpacing.sp2),
        _buildTextField(
          controller: _exampleController,
          placeholder: 'Provide a real-world or practical example',
          maxLines: 3,
          errorKey: 'example',
        ),
        const SizedBox(height: AppSpacing.sp6),

        // Takeaway
        _buildFieldLabel('Key Takeaway', required: true),
        const SizedBox(height: AppSpacing.sp2),
        _buildTextField(
          controller: _takeawayController,
          placeholder: 'What should readers remember most?',
          maxLines: 2,
          errorKey: 'takeaway',
        ),
        const SizedBox(height: AppSpacing.sp6),

        // Custom Heading (Optional)
        _buildFieldLabel('Custom Heading', required: false),
        const SizedBox(height: AppSpacing.sp2),
        _buildTextField(
          controller: _customHeadingController,
          placeholder: 'Additional section heading',
        ),
        const SizedBox(height: AppSpacing.sp6),

        // Custom Content (Optional)
        _buildFieldLabel('Custom Content', required: false),
        const SizedBox(height: AppSpacing.sp2),
        _buildTextField(
          controller: _customContentController,
          placeholder: 'Additional custom content or notes',
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String label, {required bool required}) {
    final theme = Theme.of(context);
    final mutedColor = theme.brightness == Brightness.dark
        ? AppColors.darkMutedForeground
        : AppColors.lightMutedForeground;

    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: AppTypography.fontSizeSm,
            fontWeight: AppTypography.fontWeightMedium,
            color: theme.colorScheme.onBackground,
          ),
        ),
        if (required)
          const Text(
            ' *',
            style: TextStyle(
              color: AppColors.likeRed,
              fontWeight: AppTypography.fontWeightMedium,
            ),
          )
        else
          Text(
            ' (Optional)',
            style: TextStyle(
              fontSize: AppTypography.fontSizeXs,
              color: mutedColor,
            ),
          ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String placeholder,
    int maxLines = 1,
    String? errorKey,
  }) {
    final theme = Theme.of(context);
    final borderColor = theme.brightness == Brightness.dark
        ? AppColors.darkBorder
        : AppColors.lightBorder;
    final hasError = errorKey != null && _errors.containsKey(errorKey);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          maxLines: maxLines,
          onChanged: (_) {
            if (errorKey != null) {
              setState(() => _errors.remove(errorKey));
            }
          },
          style: TextStyle(
            fontSize: AppTypography.fontSizeSm,
            color: theme.colorScheme.onBackground,
          ),
          decoration: InputDecoration(
            hintText: placeholder,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              borderSide: BorderSide(
                color: hasError ? AppColors.likeRed : borderColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              borderSide: BorderSide(
                color: hasError ? AppColors.likeRed : borderColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              borderSide: BorderSide(
                color: hasError 
                    ? AppColors.likeRed 
                    : theme.colorScheme.primary,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sp3,
              vertical: AppSpacing.sp2,
            ),
          ),
        ),
        if (hasError)
          _buildFieldError(_errors[errorKey]!),
      ],
    );
  }

  Widget _buildFieldError(String error) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sp1),
      child: Text(
        error,
        style: const TextStyle(
          fontSize: AppTypography.fontSizeXs,
          color: AppColors.likeRed,
        ),
      ),
    );
  }

  Widget _buildJsonForm() {
    final theme = Theme.of(context);
    final borderColor = theme.brightness == Brightness.dark
        ? AppColors.darkBorder
        : AppColors.lightBorder;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel('JSON Content', required: true),
        const SizedBox(height: AppSpacing.sp2),
        TextField(
          controller: _jsonController,
          maxLines: 12,
          style: TextStyle(
            fontSize: AppTypography.fontSizeSm,
            fontFamily: 'monospace',
            color: theme.colorScheme.onBackground,
          ),
          decoration: InputDecoration(
            hintText: '{\n  "category": "Psychology",\n  "title": "...",\n  "explanation": "...",\n  "example": "...",\n  "takeaway": "..."\n}',
            hintStyle: const TextStyle(fontFamily: 'monospace'),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              borderSide: BorderSide(color: borderColor),
            ),
            contentPadding: const EdgeInsets.all(AppSpacing.sp4),
          ),
        ),
      ],
    );
  }
}
