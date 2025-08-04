import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DocumentMetadataOverlayWidget extends StatelessWidget {
  final Map<String, dynamic> documentData;
  final VoidCallback onDismiss;
  final bool isVisible;

  const DocumentMetadataOverlayWidget({
    Key? key,
    required this.documentData,
    required this.onDismiss,
    required this.isVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isVisible
        ? AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withValues(alpha: 0.5),
            child: Center(
              child: Container(
                width: 85.w,
                constraints: BoxConstraints(maxHeight: 60.h),
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
                    // Header
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Informasi Dokumen',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          GestureDetector(
                            onTap: onDismiss,
                            child: CustomIconWidget(
                              iconName: 'close',
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Content
                    Flexible(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(4.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildMetadataItem(
                              'Nama Dokumen',
                              documentData['title'] as String? ??
                                  'Tidak tersedia',
                              Icons.description,
                            ),
                            SizedBox(height: 3.h),
                            _buildMetadataItem(
                              'Tanggal Dibuat',
                              documentData['createdDate'] as String? ??
                                  'Tidak tersedia',
                              Icons.calendar_today,
                            ),
                            SizedBox(height: 3.h),
                            _buildMetadataItem(
                              'Masa Berlaku',
                              documentData['validityPeriod'] as String? ??
                                  'Tidak tersedia',
                              Icons.schedule,
                            ),
                            SizedBox(height: 3.h),
                            _buildMetadataItem(
                              'Ukuran File',
                              documentData['fileSize'] as String? ??
                                  'Tidak tersedia',
                              Icons.storage,
                            ),
                            SizedBox(height: 3.h),
                            _buildMetadataItem(
                              'Klasifikasi Keamanan',
                              documentData['securityClassification']
                                      as String? ??
                                  'Tidak tersedia',
                              Icons.security,
                            ),
                            SizedBox(height: 3.h),
                            _buildMetadataItem(
                              'Kategori',
                              documentData['category'] as String? ??
                                  'Tidak tersedia',
                              Icons.category,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : SizedBox.shrink();
  }

  Widget _buildMetadataItem(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 10.w,
          height: 5.h,
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: icon.toString().split('.').last,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 20,
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                value,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
