import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DocumentPickerBottomSheet extends StatefulWidget {
  final List<Map<String, dynamic>> availableDocuments;
  final List<Map<String, dynamic>> selectedDocuments;
  final Function(List<Map<String, dynamic>>) onDocumentsSelected;

  const DocumentPickerBottomSheet({
    Key? key,
    required this.availableDocuments,
    required this.selectedDocuments,
    required this.onDocumentsSelected,
  }) : super(key: key);

  @override
  State<DocumentPickerBottomSheet> createState() =>
      _DocumentPickerBottomSheetState();
}

class _DocumentPickerBottomSheetState extends State<DocumentPickerBottomSheet> {
  List<Map<String, dynamic>> _filteredDocuments = [];
  List<Map<String, dynamic>> _tempSelectedDocuments = [];
  String _searchQuery = '';
  String _selectedFilter = 'Semua';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _filterOptions = ['Semua', 'PKS', 'Juknis', 'POC'];

  @override
  void initState() {
    super.initState();
    _filteredDocuments = List.from(widget.availableDocuments);
    _tempSelectedDocuments = List.from(widget.selectedDocuments);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterDocuments() {
    setState(() {
      _filteredDocuments = widget.availableDocuments.where((doc) {
        final matchesSearch = _searchQuery.isEmpty ||
            (doc['name'] as String)
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());
        final matchesFilter = _selectedFilter == 'Semua' ||
            (doc['type'] as String).toLowerCase() ==
                _selectedFilter.toLowerCase();
        return matchesSearch && matchesFilter;
      }).toList();
    });
  }

  void _toggleDocumentSelection(Map<String, dynamic> document) {
    setState(() {
      final index = _tempSelectedDocuments
          .indexWhere((doc) => doc['id'] == document['id']);
      if (index >= 0) {
        _tempSelectedDocuments.removeAt(index);
      } else {
        _tempSelectedDocuments.add(document);
      }
    });
  }

  bool _isDocumentSelected(Map<String, dynamic> document) {
    return _tempSelectedDocuments.any((doc) => doc['id'] == document['id']);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          _buildSearchAndFilter(),
          _buildSelectedCount(),
          Expanded(child: _buildDocumentList()),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 12.w,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 3.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pilih Dokumen',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
                  size: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: (value) {
              _searchQuery = value;
              _filterDocuments();
            },
            decoration: InputDecoration(
              hintText: 'Cari dokumen...',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'search',
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.5),
                  size: 20,
                ),
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                        _searchQuery = '';
                        _filterDocuments();
                      },
                      icon: CustomIconWidget(
                        iconName: 'clear',
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.5),
                        size: 20,
                      ),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppTheme.lightTheme.primaryColor,
                  width: 2,
                ),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
            ),
          ),
          SizedBox(height: 2.h),
          _buildFilterChips(),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _filterOptions.map((filter) {
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: EdgeInsets.only(right: 2.w),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter;
                  _filterDocuments();
                });
              },
              backgroundColor: AppTheme.lightTheme.colorScheme.surface,
              selectedColor:
                  AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              checkmarkColor: AppTheme.lightTheme.primaryColor,
              labelStyle: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.7),
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              ),
              side: BorderSide(
                color: isSelected
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSelectedCount() {
    if (_tempSelectedDocuments.isEmpty) return SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'check_circle',
            color: AppTheme.lightTheme.primaryColor,
            size: 16,
          ),
          SizedBox(width: 2.w),
          Text(
            '${_tempSelectedDocuments.length} dokumen dipilih',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentList() {
    if (_filteredDocuments.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      itemCount: _filteredDocuments.length,
      itemBuilder: (context, index) {
        final document = _filteredDocuments[index];
        return _buildDocumentItem(document);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'search_off',
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.4),
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'Tidak ada dokumen ditemukan',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Coba ubah kata kunci atau filter pencarian',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentItem(Map<String, dynamic> document) {
    final isSelected = _isDocumentSelected(document);
    final documentName = document['name'] as String;
    final documentType = document['type'] as String;
    final expiryDate = document['expiryDate'] as String;
    final status = document['status'] as String;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? AppTheme.lightTheme.primaryColor
              : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () => _toggleDocumentSelection(document),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Row(
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: _getDocumentTypeColor(documentType),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    _getDocumentTypeInitial(documentType),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      documentName,
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: _getDocumentTypeColor(documentType)
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            documentType.toUpperCase(),
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: _getDocumentTypeColor(documentType),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color:
                                _getStatusColor(status).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            status,
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: _getStatusColor(status),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'schedule',
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.5),
                          size: 14,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'Berakhir: $expiryDate',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 2.w),
              Container(
                width: 6.w,
                height: 6.w,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.primaryColor
                      : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.lightTheme.primaryColor
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.5),
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? CustomIconWidget(
                        iconName: 'check',
                        color: Colors.white,
                        size: 12,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Batal',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.7),
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 3.h),
                side: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                  width: 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _tempSelectedDocuments.isNotEmpty
                  ? () {
                      widget.onDocumentsSelected(_tempSelectedDocuments);
                      Navigator.pop(context);
                    }
                  : null,
              child: Text(
                'Pilih (${_tempSelectedDocuments.length})',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _tempSelectedDocuments.isNotEmpty
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                padding: EdgeInsets.symmetric(vertical: 3.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'aktif':
        return AppTheme.getSuccessColor(true);
      case 'akan berakhir':
        return AppTheme.getWarningColor(true);
      case 'berakhir':
        return AppTheme.lightTheme.colorScheme.error;
      default:
        return AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6);
    }
  }
}
