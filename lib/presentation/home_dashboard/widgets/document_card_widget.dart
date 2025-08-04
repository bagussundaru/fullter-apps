import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DocumentCardWidget extends StatelessWidget {
  final Map<String, dynamic> document;
  final VoidCallback? onTap;
  final VoidCallback? onPreview;
  final VoidCallback? onDownload;
  final VoidCallback? onExtend;

  const DocumentCardWidget({
    Key? key,
    required this.document,
    this.onTap,
    this.onPreview,
    this.onDownload,
    this.onExtend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String documentType = (document['type'] as String?) ?? 'PKS';
    final String title = (document['title'] as String?) ?? 'Untitled Document';
    final String validUntil =
        (document['validUntil'] as String?) ?? '31/12/2024';
    final String thumbnailUrl = (document['thumbnail'] as String?) ?? '';
    final bool isExpiringSoon = _isExpiringSoon(validUntil);

    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _showQuickActions(context),
      child: Container(
        width: 65.w,
        margin: EdgeInsets.only(right: 3.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Document Thumbnail
            Container(
              height: 12.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.1),
              ),
              child: thumbnailUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(12)),
                      child: CustomImageWidget(
                        imageUrl: thumbnailUrl,
                        width: double.infinity,
                        height: 12.h,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Center(
                      child: CustomIconWidget(
                        iconName: 'description',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 8.w,
                      ),
                    ),
            ),

            // Document Info
            Padding(
              padding: EdgeInsets.all(3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Document Type Badge
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                    decoration: BoxDecoration(
                      color: _getTypeColor(documentType).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      documentType,
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: _getTypeColor(documentType),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  SizedBox(height: 2.w),

                  // Document Title
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 2.w),

                  // Validity Info
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'schedule',
                        color: isExpiringSoon
                            ? AppTheme.lightTheme.colorScheme.error
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 3.w,
                      ),
                      SizedBox(width: 1.w),
                      Expanded(
                        child: Text(
                          'Berlaku hingga $validUntil',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: isExpiringSoon
                                ? AppTheme.lightTheme.colorScheme.error
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  if (isExpiringSoon) ...[
                    SizedBox(height: 2.w),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.error
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: 'warning',
                            color: AppTheme.lightTheme.colorScheme.error,
                            size: 3.w,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            'Segera Berakhir',
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toUpperCase()) {
      case 'PKS':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'JUKNIS':
        return Color(0xFF10B981); // Success color
      case 'POC':
        return AppTheme.lightTheme.colorScheme.tertiary;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  bool _isExpiringSoon(String validUntil) {
    try {
      final parts = validUntil.split('/');
      if (parts.length == 3) {
        final expiryDate = DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
        final now = DateTime.now();
        final difference = expiryDate.difference(now).inDays;
        return difference <= 30 && difference >= 0;
      }
    } catch (e) {
      // Handle parsing error
    }
    return false;
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 1.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            _buildQuickActionItem(
              context,
              'Pratinjau',
              Icons.visibility,
              onPreview,
            ),
            _buildQuickActionItem(
              context,
              'Unduh',
              Icons.download,
              onDownload,
            ),
            _buildQuickActionItem(
              context,
              'Perpanjang',
              Icons.extension,
              onExtend,
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback? onTap,
  ) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: icon.codePoint.toString(),
        color: AppTheme.lightTheme.colorScheme.onSurface,
        size: 5.w,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        onTap?.call();
      },
    );
  }
}
