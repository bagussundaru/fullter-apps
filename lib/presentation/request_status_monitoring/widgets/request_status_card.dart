import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class RequestStatusCard extends StatelessWidget {
  final Map<String, dynamic> request;
  final VoidCallback onTap;
  final VoidCallback? onViewDetails;
  final VoidCallback? onDownloadLetter;
  final VoidCallback? onResubmit;

  const RequestStatusCard({
    Key? key,
    required this.request,
    required this.onTap,
    this.onViewDetails,
    this.onDownloadLetter,
    this.onResubmit,
  }) : super(key: key);

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Color(0xFFF59E0B); // Golden yellow
      case 'approved':
        return Color(0xFF10B981); // Emerald green
      case 'rejected':
        return Color(0xFFEF4444); // Soft red
      case 'processing':
        return Color(0xFF3B82F6); // Blue
      default:
        return AppTheme.lightTheme.colorScheme.outline;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Menunggu';
      case 'approved':
        return 'Disetujui';
      case 'rejected':
        return 'Ditolak';
      case 'processing':
        return 'Diproses';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String status = request['status'] as String;
    final Color statusColor = _getStatusColor(status);

    return Dismissible(
      key: Key(request['id'].toString()),
      background: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.primaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'visibility',
              color: Colors.white,
              size: 24,
            ),
            SizedBox(height: 0.5.h),
            Text(
              'Detail',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: status.toLowerCase() == 'approved'
              ? Color(0xFF10B981)
              : status.toLowerCase() == 'rejected'
                  ? Color(0xFFF59E0B)
                  : AppTheme.lightTheme.colorScheme.outline,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: status.toLowerCase() == 'approved'
                  ? 'download'
                  : status.toLowerCase() == 'rejected'
                      ? 'refresh'
                      : 'more_horiz',
              color: Colors.white,
              size: 24,
            ),
            SizedBox(height: 0.5.h),
            Text(
              status.toLowerCase() == 'approved'
                  ? 'Unduh'
                  : status.toLowerCase() == 'rejected'
                      ? 'Kirim Ulang'
                      : 'Aksi',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd && onViewDetails != null) {
          onViewDetails!();
        } else if (direction == DismissDirection.endToStart) {
          if (status.toLowerCase() == 'approved' && onDownloadLetter != null) {
            onDownloadLetter!();
          } else if (status.toLowerCase() == 'rejected' && onResubmit != null) {
            onResubmit!();
          }
        }
      },
      child: GestureDetector(
        onTap: onTap,
        onLongPress: () => _showContextMenu(context),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: statusColor.withValues(alpha: 0.3),
              width: 1,
            ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'ID: ${request['id']}',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: statusColor,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      _getStatusText(status),
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'calendar_today',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Diajukan: ${request['submissionDate']}',
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'description',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Dokumen: ${request['documentName']}',
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (request['estimatedCompletion'] != null) ...[
                SizedBox(height: 1.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'schedule',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Estimasi: ${request['estimatedCompletion']}',
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
              SizedBox(height: 2.h),
              _buildProgressIndicator(status),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(String status) {
    final List<String> steps = ['Diajukan', 'Diproses', 'Selesai'];
    int currentStep = 0;

    switch (status.toLowerCase()) {
      case 'pending':
        currentStep = 0;
        break;
      case 'processing':
        currentStep = 1;
        break;
      case 'approved':
      case 'rejected':
        currentStep = 2;
        break;
    }

    return Row(
      children: steps.asMap().entries.map((entry) {
        final int index = entry.key;
        final String step = entry.value;
        final bool isCompleted = index < currentStep;
        final bool isCurrent = index == currentStep;

        return Expanded(
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: isCompleted || isCurrent
                      ? _getStatusColor(status)
                      : AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: isCompleted
                    ? CustomIconWidget(
                        iconName: 'check',
                        color: Colors.white,
                        size: 12,
                      )
                    : isCurrent
                        ? Container(
                            width: 8,
                            height: 8,
                            margin: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          )
                        : null,
              ),
              if (index < steps.length - 1)
                Expanded(
                  child: Container(
                    height: 2,
                    margin: EdgeInsets.symmetric(horizontal: 2.w),
                    color: isCompleted
                        ? _getStatusColor(status)
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'visibility',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: Text('Lihat Detail'),
              onTap: () {
                Navigator.pop(context);
                if (onViewDetails != null) onViewDetails!();
              },
            ),
            if (request['status'].toString().toLowerCase() == 'approved')
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'download',
                  color: Color(0xFF10B981),
                  size: 24,
                ),
                title: Text('Unduh Surat Persetujuan'),
                onTap: () {
                  Navigator.pop(context);
                  if (onDownloadLetter != null) onDownloadLetter!();
                },
              ),
            if (request['status'].toString().toLowerCase() == 'rejected')
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'refresh',
                  color: Color(0xFFF59E0B),
                  size: 24,
                ),
                title: Text('Kirim Ulang Permohonan'),
                onTap: () {
                  Navigator.pop(context);
                  if (onResubmit != null) onResubmit!();
                },
              ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
