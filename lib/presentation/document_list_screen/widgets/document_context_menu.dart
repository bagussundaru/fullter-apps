import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class DocumentContextMenu extends StatelessWidget {
  final Map<String, dynamic> document;
  final VoidCallback onPreview;
  final VoidCallback onDownload;
  final VoidCallback onRequestExtension;
  final VoidCallback onShare;

  const DocumentContextMenu({
    Key? key,
    required this.document,
    required this.onPreview,
    required this.onDownload,
    required this.onRequestExtension,
    required this.onShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Document info header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 12.w,
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: document['thumbnail'] != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: CustomImageWidget(
                            imageUrl: document['thumbnail'] as String,
                            width: 12.w,
                            height: 6.h,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Center(
                          child: CustomIconWidget(
                            iconName: _getDocumentIcon(),
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
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
                        document['title'] as String,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        '${document['type']} • ${document['fileSize']} MB',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Menu options
          _buildMenuItem(
            icon: 'visibility',
            title: 'Preview Document',
            onTap: () {
              Navigator.pop(context);
              onPreview();
            },
          ),
          _buildMenuItem(
            icon: 'download',
            title: 'Download',
            onTap: () {
              Navigator.pop(context);
              onDownload();
            },
          ),
          _buildMenuItem(
            icon: 'schedule',
            title: 'Request Extension',
            onTap: () {
              Navigator.pop(context);
              onRequestExtension();
            },
          ),
          _buildMenuItem(
            icon: 'share',
            title: 'Share',
            onTap: () {
              Navigator.pop(context);
              onShare();
            },
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          border: !isLast
              ? Border(
                  bottom: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                    width: 1,
                  ),
                )
              : null,
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
            SizedBox(width: 3.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            Spacer(),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  String _getDocumentIcon() {
    final type = document['type'] as String;
    switch (type.toLowerCase()) {
      case 'pks':
        return 'description';
      case 'juknis':
        return 'book';
      case 'poc':
        return 'assignment';
      default:
        return 'insert_drive_file';
    }
  }
}
