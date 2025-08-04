import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DocumentToolbarWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onExtensionRequest;
  final Function(int) onPageChanged;

  const DocumentToolbarWidget({
    Key? key,
    required this.currentPage,
    required this.totalPages,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onExtensionRequest,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 10.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            offset: Offset(0, -2),
            blurRadius: 4,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Column(
            children: [
              // Page indicator and zoom controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Page navigation
                  Row(
                    children: [
                      GestureDetector(
                        onTap: currentPage > 1
                            ? () => onPageChanged(currentPage - 1)
                            : null,
                        child: Container(
                          width: 10.w,
                          height: 4.h,
                          decoration: BoxDecoration(
                            color: currentPage > 1
                                ? AppTheme.lightTheme.colorScheme.primary
                                    .withValues(alpha: 0.1)
                                : AppTheme.lightTheme.colorScheme.outline
                                    .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: CustomIconWidget(
                              iconName: 'chevron_left',
                              color: currentPage > 1
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : AppTheme.lightTheme.colorScheme.outline,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: AppTheme
                              .lightTheme.colorScheme.primaryContainer
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '$currentPage / $totalPages',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      GestureDetector(
                        onTap: currentPage < totalPages
                            ? () => onPageChanged(currentPage + 1)
                            : null,
                        child: Container(
                          width: 10.w,
                          height: 4.h,
                          decoration: BoxDecoration(
                            color: currentPage < totalPages
                                ? AppTheme.lightTheme.colorScheme.primary
                                    .withValues(alpha: 0.1)
                                : AppTheme.lightTheme.colorScheme.outline
                                    .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: CustomIconWidget(
                              iconName: 'chevron_right',
                              color: currentPage < totalPages
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : AppTheme.lightTheme.colorScheme.outline,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Zoom controls
                  Row(
                    children: [
                      GestureDetector(
                        onTap: onZoomOut,
                        child: Container(
                          width: 10.w,
                          height: 4.h,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: CustomIconWidget(
                              iconName: 'zoom_out',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      GestureDetector(
                        onTap: onZoomIn,
                        child: Container(
                          width: 10.w,
                          height: 4.h,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: CustomIconWidget(
                              iconName: 'zoom_in',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              // Extension request button
              SizedBox(
                width: double.infinity,
                height: 5.h,
                child: ElevatedButton(
                  onPressed: onExtensionRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                    foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'extension',
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Ajukan Perpanjangan',
                        style:
                            AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
