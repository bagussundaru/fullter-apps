import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ReasonInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final String? errorText;
  final Function(String) onChanged;

  const ReasonInputWidget({
    Key? key,
    required this.controller,
    this.errorText,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<ReasonInputWidget> createState() => _ReasonInputWidgetState();
}

class _ReasonInputWidgetState extends State<ReasonInputWidget> {
  final List<String> suggestedReasons = [
    'Perpanjangan masa berlaku dokumen',
    'Perubahan data dalam dokumen',
    'Dokumen akan segera berakhir',
    'Kebutuhan operasional kantor',
    'Pembaruan regulasi terbaru',
    'Penyesuaian dengan kebijakan baru',
  ];

  bool _showSuggestions = false;
  final int maxCharacters = 500;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.errorText != null
              ? AppTheme.lightTheme.colorScheme.error
              : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'edit_note',
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Alasan Permohonan',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                ' *',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.error,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildTextArea(),
          if (widget.errorText != null) ...[
            SizedBox(height: 1.h),
            _buildErrorText(),
          ],
          SizedBox(height: 2.h),
          _buildCharacterCounter(),
          SizedBox(height: 3.h),
          _buildSuggestedReasonsButton(),
          if (_showSuggestions) ...[
            SizedBox(height: 2.h),
            _buildSuggestedReasons(),
          ],
        ],
      ),
    );
  }

  Widget _buildTextArea() {
    return TextFormField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      maxLines: 5,
      maxLength: maxCharacters,
      decoration: InputDecoration(
        hintText: 'Jelaskan alasan permohonan perpanjangan dokumen...',
        hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          color:
              AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppTheme.lightTheme.primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppTheme.lightTheme.colorScheme.error,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppTheme.lightTheme.colorScheme.error,
            width: 2,
          ),
        ),
        contentPadding: EdgeInsets.all(4.w),
        counterText: '',
      ),
      style: AppTheme.lightTheme.textTheme.bodyMedium,
    );
  }

  Widget _buildErrorText() {
    return Row(
      children: [
        CustomIconWidget(
          iconName: 'error_outline',
          color: AppTheme.lightTheme.colorScheme.error,
          size: 16,
        ),
        SizedBox(width: 1.w),
        Expanded(
          child: Text(
            widget.errorText!,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.error,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCharacterCounter() {
    final currentLength = widget.controller.text.length;
    final isNearLimit = currentLength > maxCharacters * 0.8;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '$currentLength/$maxCharacters',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: isNearLimit
                ? AppTheme.lightTheme.colorScheme.error
                : AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
            fontWeight: isNearLimit ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestedReasonsButton() {
    return TextButton.icon(
      onPressed: () {
        setState(() {
          _showSuggestions = !_showSuggestions;
        });
      },
      icon: CustomIconWidget(
        iconName: _showSuggestions ? 'expand_less' : 'expand_more',
        color: AppTheme.lightTheme.primaryColor,
        size: 18,
      ),
      label: Text(
        'Alasan yang Disarankan',
        style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
          color: AppTheme.lightTheme.primaryColor,
        ),
      ),
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      ),
    );
  }

  Widget _buildSuggestedReasons() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pilih salah satu alasan berikut:',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 2.h),
          ...suggestedReasons.map((reason) => _buildSuggestionItem(reason)),
        ],
      ),
    );
  }

  Widget _buildSuggestionItem(String reason) {
    return InkWell(
      onTap: () {
        widget.controller.text = reason;
        widget.onChanged(reason);
        setState(() {
          _showSuggestions = false;
        });
      },
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
        margin: EdgeInsets.only(bottom: 1.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: 'lightbulb_outline',
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.6),
              size: 16,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                reason,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.8),
                ),
              ),
            ),
            CustomIconWidget(
              iconName: 'arrow_forward_ios',
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.4),
              size: 12,
            ),
          ],
        ),
      ),
    );
  }
}
