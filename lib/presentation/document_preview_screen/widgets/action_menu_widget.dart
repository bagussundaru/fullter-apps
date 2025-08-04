import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActionMenuWidget extends StatelessWidget {
  final VoidCallback onDownload;
  final VoidCallback onShare;
  final VoidCallback onExtend;
  final VoidCallback onShowMetadata;
  final VoidCallback onDismiss;
  final bool isVisible;

  const ActionMenuWidget({
    Key? key,
    required this.onDownload,
    required this.onShare,
    required this.onExtend,
    required this.onShowMetadata,
    required this.onDismiss,
    required this.isVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isVisible
        ? GestureDetector(
            onTap: onDismiss,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.transparent,
              child: Stack(
                children: [
                  Positioned(
                    top: 12.h,
                    right: 4.w,
                    child: Container(
                      width: 50.w,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.lightTheme.colorScheme.shadow,
                            offset: Offset(0, 4),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildMenuItem(
                            'Unduh Dokumen',
                            'download',
                            onDownload,
                          ),
                          Divider(
                            height: 1,
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.2),
                          ),
                          _buildMenuItem(
                            'Bagikan',
                            'share',
                            onShare,
                          ),
                          Divider(
                            height: 1,
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.2),
                          ),
                          _buildMenuItem(
                            'Perpanjang',
                            'extension',
                            onExtend,
                          ),
                          Divider(
                            height: 1,
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.2),
                          ),
                          _buildMenuItem(
                            'Info Dokumen',
                            'info',
                            onShowMetadata,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : SizedBox.shrink();
  }

  Widget _buildMenuItem(String title, String iconName, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        onDismiss();
        onTap();
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 20,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                title,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
