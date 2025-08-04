import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class StatusFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? selectedColor;

  const StatusFilterChip({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.selectedColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        margin: EdgeInsets.only(right: 2.w),
        decoration: BoxDecoration(
          color: isSelected
              ? (selectedColor ?? AppTheme.lightTheme.primaryColor)
              : AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? (selectedColor ?? AppTheme.lightTheme.primaryColor)
                : AppTheme.lightTheme.colorScheme.outline,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            color: isSelected
                ? Colors.white
                : AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
