import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class DocumentFilterBottomSheet extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersChanged;

  const DocumentFilterBottomSheet({
    Key? key,
    required this.currentFilters,
    required this.onFiltersChanged,
  }) : super(key: key);

  @override
  State<DocumentFilterBottomSheet> createState() =>
      _DocumentFilterBottomSheetState();
}

class _DocumentFilterBottomSheetState extends State<DocumentFilterBottomSheet> {
  late Map<String, dynamic> _filters;
  bool _isDocumentTypeExpanded = true;
  bool _isValidityPeriodExpanded = false;
  bool _isCreationDateExpanded = false;

  final List<String> _documentTypes = ['PKS', 'Juknis', 'POC'];
  final List<String> _validityPeriods = ['Valid', 'Expiring Soon', 'Expired'];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.only(top: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Text(
                  'Filter Documents',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                Spacer(),
                TextButton(
                  onPressed: _clearAllFilters,
                  child: Text(
                    'Clear All',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3)),
          // Filter sections
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                children: [
                  _buildFilterSection(
                    'Document Type',
                    _isDocumentTypeExpanded,
                    () => setState(() =>
                        _isDocumentTypeExpanded = !_isDocumentTypeExpanded),
                    _buildDocumentTypeFilters(),
                  ),
                  _buildFilterSection(
                    'Validity Period',
                    _isValidityPeriodExpanded,
                    () => setState(() =>
                        _isValidityPeriodExpanded = !_isValidityPeriodExpanded),
                    _buildValidityPeriodFilters(),
                  ),
                  _buildFilterSection(
                    'Creation Date',
                    _isCreationDateExpanded,
                    () => setState(() =>
                        _isCreationDateExpanded = !_isCreationDateExpanded),
                    _buildCreationDateFilters(),
                  ),
                ],
              ),
            ),
          ),
          // Apply button
          Container(
            padding: EdgeInsets.all(4.w),
            child: SizedBox(
              width: double.infinity,
              height: 6.h,
              child: ElevatedButton(
                onPressed: () {
                  widget.onFiltersChanged(_filters);
                  Navigator.pop(context);
                },
                child: Text(
                  'Apply Filters',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(
      String title, bool isExpanded, VoidCallback onToggle, Widget content) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onToggle,
            child: Container(
              padding: EdgeInsets.all(3.w),
              child: Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                  Spacer(),
                  CustomIconWidget(
                    iconName: isExpanded ? 'expand_less' : 'expand_more',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            Divider(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2)),
            Padding(
              padding: EdgeInsets.all(3.w),
              child: content,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDocumentTypeFilters() {
    return Column(
      children: _documentTypes.map((type) {
        final isSelected =
            (_filters['documentTypes'] as List<String>? ?? []).contains(type);
        return CheckboxListTile(
          title: Text(
            type,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          value: isSelected,
          onChanged: (value) {
            setState(() {
              final types =
                  (_filters['documentTypes'] as List<String>? ?? []).toList();
              if (value == true) {
                types.add(type);
              } else {
                types.remove(type);
              }
              _filters['documentTypes'] = types;
            });
          },
          contentPadding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }

  Widget _buildValidityPeriodFilters() {
    return Column(
      children: _validityPeriods.map((period) {
        final isSelected = (_filters['validityPeriods'] as List<String>? ?? [])
            .contains(period);
        return CheckboxListTile(
          title: Text(
            period,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          value: isSelected,
          onChanged: (value) {
            setState(() {
              final periods =
                  (_filters['validityPeriods'] as List<String>? ?? []).toList();
              if (value == true) {
                periods.add(period);
              } else {
                periods.remove(period);
              }
              _filters['validityPeriods'] = periods;
            });
          },
          contentPadding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }

  Widget _buildCreationDateFilters() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'From Date',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  GestureDetector(
                    onTap: () => _selectDate(context, 'fromDate'),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 3.w, vertical: 1.5.h),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _filters['fromDate'] != null
                                  ? _formatDate(
                                      _filters['fromDate'] as DateTime)
                                  : 'Select date',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: _filters['fromDate'] != null
                                    ? AppTheme.lightTheme.colorScheme.onSurface
                                    : AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                              ),
                            ),
                          ),
                          CustomIconWidget(
                            iconName: 'calendar_today',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'To Date',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  GestureDetector(
                    onTap: () => _selectDate(context, 'toDate'),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 3.w, vertical: 1.5.h),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _filters['toDate'] != null
                                  ? _formatDate(_filters['toDate'] as DateTime)
                                  : 'Select date',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: _filters['toDate'] != null
                                    ? AppTheme.lightTheme.colorScheme.onSurface
                                    : AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                              ),
                            ),
                          ),
                          CustomIconWidget(
                            iconName: 'calendar_today',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, String dateType) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _filters[dateType] as DateTime? ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _filters[dateType] = picked;
      });
    }
  }

  void _clearAllFilters() {
    setState(() {
      _filters = {
        'documentTypes': <String>[],
        'validityPeriods': <String>[],
        'fromDate': null,
        'toDate': null,
      };
    });
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
