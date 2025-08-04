import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class DocumentCard extends StatelessWidget {
  final Map<String, dynamic> document;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onSwipeRight;

  const DocumentCard({
    Key? key,
    required this.document,
    required this.onTap,
    required this.onLongPress,
    required this.onSwipeRight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isExpiring = _isDocumentExpiring();
    final bool isValid = _isDocumentValid();

    return Dismissible(
      key: Key(document['id'].toString()),
      direction: DismissDirection.startToEnd,
      background: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 4.w),
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'download',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            SizedBox(height: 0.5.h),
            Text(
              'Download',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        onSwipeRight();
      },
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.shadow
                    .withValues(alpha: 0.1),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Document thumbnail
              Container(
                width: 15.w,
                height: 8.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: document['thumbnail'] != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CustomImageWidget(
                          imageUrl: document['thumbnail'] as String,
                          width: 15.w,
                          height: 8.h,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Center(
                        child: CustomIconWidget(
                          iconName: _getDocumentIcon(),
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
              ),
              SizedBox(width: 3.w),
              // Document details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            document['title'] as String,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.lightTheme.colorScheme.onSurface,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: isValid
                                ? AppTheme.getSuccessColor(true)
                                    .withValues(alpha: 0.1)
                                : isExpiring
                                    ? AppTheme.getWarningColor(true)
                                        .withValues(alpha: 0.1)
                                    : AppTheme.lightTheme.colorScheme.error
                                        .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            isValid
                                ? 'Valid'
                                : isExpiring
                                    ? 'Expiring'
                                    : 'Expired',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                              color: isValid
                                  ? AppTheme.getSuccessColor(true)
                                  : isExpiring
                                      ? AppTheme.getWarningColor(true)
                                      : AppTheme.lightTheme.colorScheme.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'calendar_today',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 14,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'Valid until: ${_formatDate(document['validUntil'] as String)}',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.3.h),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            document['type'] as String,
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.lightTheme.colorScheme.primary,
                            ),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          '${document['fileSize']} MB',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Spacer(),
                        Text(
                          _formatDate(document['createdAt'] as String),
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
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

  bool _isDocumentExpiring() {
    final validUntil = DateTime.parse(document['validUntil'] as String);
    final now = DateTime.now();
    final daysUntilExpiry = validUntil.difference(now).inDays;
    return daysUntilExpiry <= 30 && daysUntilExpiry > 0;
  }

  bool _isDocumentValid() {
    final validUntil = DateTime.parse(document['validUntil'] as String);
    final now = DateTime.now();
    return validUntil.isAfter(now) && !_isDocumentExpiring();
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
