import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FormProgressWidget extends StatelessWidget {
  final double progress;
  final List<String> completedSteps;
  final List<String> allSteps;

  const FormProgressWidget({
    Key? key,
    required this.progress,
    required this.completedSteps,
    required this.allSteps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress Formulir',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: _getProgressColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${(progress * 100).toInt()}%',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: _getProgressColor(),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildProgressBar(),
          SizedBox(height: 3.h),
          _buildStepsList(),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Kelengkapan',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
              ),
            ),
            Text(
              '${completedSteps.length}/${allSteps.length} langkah',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          height: 8,
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                color: _getProgressColor(),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepsList() {
    return Column(
      children: allSteps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        final isCompleted = completedSteps.contains(step);
        final isLast = index == allSteps.length - 1;

        return _buildStepItem(step, isCompleted, isLast);
      }).toList(),
    );
  }

  Widget _buildStepItem(String step, bool isCompleted, bool isLast) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppTheme.getSuccessColor(true)
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted
                      ? AppTheme.getSuccessColor(true)
                      : AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? CustomIconWidget(
                      iconName: 'check',
                      color: Colors.white,
                      size: 12,
                    )
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 4.h,
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
              ),
          ],
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 0.5.h, bottom: isLast ? 0 : 2.h),
            child: Text(
              step,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: isCompleted
                    ? AppTheme.lightTheme.colorScheme.onSurface
                    : AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.6),
                fontWeight: isCompleted ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getProgressColor() {
    if (progress >= 1.0) {
      return AppTheme.getSuccessColor(true);
    } else if (progress >= 0.5) {
      return AppTheme.getWarningColor(true);
    } else {
      return AppTheme.lightTheme.primaryColor;
    }
  }
}
