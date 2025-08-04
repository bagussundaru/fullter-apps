import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DocumentSelectionWidget extends StatelessWidget {
  final List<Map<String, dynamic>> selectedDocuments;
  final VoidCallback onAddDocument;
  final Function(int) onRemoveDocument;

  const DocumentSelectionWidget({
    Key? key,
    required this.selectedDocuments,
    required this.onAddDocument,
    required this.onRemoveDocument,
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
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'description',
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Dokumen yang Diperpanjang',
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
          selectedDocuments.isEmpty
              ? _buildEmptyState()
              : _buildSelectedDocuments(),
          SizedBox(height: 3.h),
          _buildAddDocumentButton(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'folder_open',
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.4),
            size: 32,
          ),
          SizedBox(height: 2.h),
          Text(
            'Belum ada dokumen dipilih',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Pilih dokumen yang ingin diperpanjang',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedDocuments() {
    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: selectedDocuments.asMap().entries.map((entry) {
        final index = entry.key;
        final document = entry.value;
        return _buildDocumentChip(document, index);
      }).toList(),
    );
  }

  Widget _buildDocumentChip(Map<String, dynamic> document, int index) {
    return Container(
      constraints: BoxConstraints(maxWidth: 85.w),
      child: Chip(
        avatar: CircleAvatar(
          backgroundColor: _getDocumentTypeColor(document['type'] as String),
          child: Text(
            _getDocumentTypeInitial(document['type'] as String),
            style: TextStyle(
              color: Colors.white,
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        label: Flexible(
          child: Text(
            document['name'] as String,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        deleteIcon: CustomIconWidget(
          iconName: 'close',
          color: AppTheme.lightTheme.colorScheme.error,
          size: 16,
        ),
        onDeleted: () => onRemoveDocument(index),
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        side: BorderSide(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _buildAddDocumentButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onAddDocument,
        icon: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.lightTheme.primaryColor,
          size: 18,
        ),
        label: Text(
          'Pilih Dokumen',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color: AppTheme.lightTheme.primaryColor,
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 3.h),
          side: BorderSide(
            color: AppTheme.lightTheme.primaryColor,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Color _getDocumentTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'pks':
        return Color(0xFF3B82F6);
      case 'juknis':
        return Color(0xFF8B5CF6);
      case 'poc':
        return Color(0xFF10B981);
      default:
        return AppTheme.lightTheme.primaryColor;
    }
  }

  String _getDocumentTypeInitial(String type) {
    switch (type.toLowerCase()) {
      case 'pks':
        return 'P';
      case 'juknis':
        return 'J';
      case 'poc':
        return 'C';
      default:
        return 'D';
    }
  }
}
