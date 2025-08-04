import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/empty_state_widget.dart';
import './widgets/loading_skeleton_card.dart';
import './widgets/request_status_card.dart';
import './widgets/status_filter_chip.dart';

class RequestStatusMonitoring extends StatefulWidget {
  const RequestStatusMonitoring({Key? key}) : super(key: key);

  @override
  State<RequestStatusMonitoring> createState() =>
      _RequestStatusMonitoringState();
}

class _RequestStatusMonitoringState extends State<RequestStatusMonitoring>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;
  bool _isRefreshing = false;
  String _selectedFilter = 'Semua';
  String _searchQuery = '';
  DateTime? _lastUpdateTime;

  final List<String> _filterOptions = [
    'Semua',
    'Menunggu',
    'Diproses',
    'Disetujui',
    'Ditolak'
  ];

  // Mock data for request status monitoring
  final List<Map<String, dynamic>> _allRequests = [
    {
      "id": "REQ-2025-001",
      "status": "pending",
      "submissionDate": "02/08/2025",
      "documentName": "Surat Keterangan Domisili",
      "documentType": "PKS",
      "estimatedCompletion": "05/08/2025",
      "reviewerComments": null,
      "supportingDocuments": ["KTP", "Surat Pengantar RT"],
      "requestHistory": [
        {
          "date": "02/08/2025 09:15",
          "status": "Permohonan Diterima",
          "description": "Permohonan telah diterima dan menunggu verifikasi"
        }
      ]
    },
    {
      "id": "REQ-2025-002",
      "status": "processing",
      "submissionDate": "01/08/2025",
      "documentName": "Surat Izin Usaha Mikro",
      "documentType": "Juknis",
      "estimatedCompletion": "04/08/2025",
      "reviewerComments": "Dokumen sedang dalam tahap verifikasi kelengkapan",
      "supportingDocuments": ["KTP", "NPWP", "Surat Keterangan Usaha"],
      "requestHistory": [
        {
          "date": "01/08/2025 14:30",
          "status": "Permohonan Diterima",
          "description": "Permohonan telah diterima dan menunggu verifikasi"
        },
        {
          "date": "02/08/2025 10:45",
          "status": "Dalam Proses Verifikasi",
          "description": "Dokumen sedang diverifikasi oleh petugas"
        }
      ]
    },
    {
      "id": "REQ-2025-003",
      "status": "approved",
      "submissionDate": "30/07/2025",
      "documentName": "Surat Keterangan Tidak Mampu",
      "documentType": "POC",
      "estimatedCompletion": "02/08/2025",
      "reviewerComments":
          "Permohonan telah disetujui. Surat dapat diambil di kantor kelurahan.",
      "supportingDocuments": ["KTP", "Kartu Keluarga", "Surat Keterangan RT"],
      "approvalLetter": "approval_letter_003.pdf",
      "requestHistory": [
        {
          "date": "30/07/2025 11:20",
          "status": "Permohonan Diterima",
          "description": "Permohonan telah diterima dan menunggu verifikasi"
        },
        {
          "date": "31/07/2025 09:15",
          "status": "Dalam Proses Verifikasi",
          "description": "Dokumen sedang diverifikasi oleh petugas"
        },
        {
          "date": "02/08/2025 13:30",
          "status": "Disetujui",
          "description": "Permohonan telah disetujui dan siap untuk diambil"
        }
      ]
    },
    {
      "id": "REQ-2025-004",
      "status": "rejected",
      "submissionDate": "29/07/2025",
      "documentName": "Surat Izin Keramaian",
      "documentType": "PKS",
      "estimatedCompletion": null,
      "reviewerComments":
          "Dokumen pendukung tidak lengkap. Harap melengkapi surat izin dari kepolisian.",
      "supportingDocuments": ["KTP", "Proposal Kegiatan"],
      "requestHistory": [
        {
          "date": "29/07/2025 16:45",
          "status": "Permohonan Diterima",
          "description": "Permohonan telah diterima dan menunggu verifikasi"
        },
        {
          "date": "30/07/2025 14:20",
          "status": "Dalam Proses Verifikasi",
          "description": "Dokumen sedang diverifikasi oleh petugas"
        },
        {
          "date": "01/08/2025 10:15",
          "status": "Ditolak",
          "description": "Permohonan ditolak karena dokumen tidak lengkap"
        }
      ]
    },
    {
      "id": "REQ-2025-005",
      "status": "processing",
      "submissionDate": "31/07/2025",
      "documentName": "Surat Keterangan Usaha",
      "documentType": "Juknis",
      "estimatedCompletion": "03/08/2025",
      "reviewerComments": "Sedang menunggu konfirmasi dari dinas terkait",
      "supportingDocuments": ["KTP", "SIUP", "TDP"],
      "requestHistory": [
        {
          "date": "31/07/2025 08:30",
          "status": "Permohonan Diterima",
          "description": "Permohonan telah diterima dan menunggu verifikasi"
        },
        {
          "date": "01/08/2025 15:45",
          "status": "Dalam Proses Verifikasi",
          "description": "Dokumen sedang diverifikasi oleh petugas"
        }
      ]
    }
  ];

  List<Map<String, dynamic>> _filteredRequests = [];

  @override
  void initState() {
    super.initState();
    _lastUpdateTime = DateTime.now();
    _filteredRequests = List.from(_allRequests);
    _loadInitialData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(Duration(milliseconds: 1500));

    setState(() {
      _isLoading = false;
      _lastUpdateTime = DateTime.now();
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API refresh
    await Future.delayed(Duration(milliseconds: 1000));

    setState(() {
      _isRefreshing = false;
      _lastUpdateTime = DateTime.now();
    });

    // Show refresh feedback
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Data berhasil diperbarui'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _filterRequests() {
    setState(() {
      _filteredRequests = _allRequests.where((request) {
        bool matchesFilter = true;
        bool matchesSearch = true;

        // Filter by status
        if (_selectedFilter != 'Semua') {
          String filterStatus = '';
          switch (_selectedFilter) {
            case 'Menunggu':
              filterStatus = 'pending';
              break;
            case 'Diproses':
              filterStatus = 'processing';
              break;
            case 'Disetujui':
              filterStatus = 'approved';
              break;
            case 'Ditolak':
              filterStatus = 'rejected';
              break;
          }
          matchesFilter = request['status'] == filterStatus;
        }

        // Filter by search query
        if (_searchQuery.isNotEmpty) {
          matchesSearch = (request['id'] as String)
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              (request['documentName'] as String)
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase());
        }

        return matchesFilter && matchesSearch;
      }).toList();
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _filterRequests();
  }

  void _onFilterSelected(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
    _filterRequests();
    HapticFeedback.selectionClick();
  }

  void _onRequestTap(Map<String, dynamic> request) {
    HapticFeedback.lightImpact();
    _showRequestDetails(request);
  }

  void _showRequestDetails(Map<String, dynamic> request) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'Detail Permohonan',
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 3.h),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    _buildDetailItem('ID Permohonan', request['id']),
                    _buildDetailItem('Nama Dokumen', request['documentName']),
                    _buildDetailItem('Jenis Dokumen', request['documentType']),
                    _buildDetailItem(
                        'Tanggal Pengajuan', request['submissionDate']),
                    if (request['estimatedCompletion'] != null)
                      _buildDetailItem(
                          'Estimasi Selesai', request['estimatedCompletion']),
                    if (request['reviewerComments'] != null)
                      _buildDetailItem(
                          'Komentar Petugas', request['reviewerComments']),
                    SizedBox(height: 2.h),
                    Text(
                      'Dokumen Pendukung',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    ...(request['supportingDocuments'] as List).map(
                      (doc) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.5.h),
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'description',
                              color: AppTheme.lightTheme.primaryColor,
                              size: 16,
                            ),
                            SizedBox(width: 2.w),
                            Text(doc,
                                style:
                                    AppTheme.lightTheme.textTheme.bodyMedium),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Riwayat Permohonan',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    ...(request['requestHistory'] as List).map(
                      (history) => Container(
                        margin: EdgeInsets.symmetric(vertical: 1.h),
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              history['status'],
                              style: AppTheme.lightTheme.textTheme.titleSmall
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              history['date'],
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              history['description'],
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
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
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
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
    );
  }

  void _onDownloadLetter(Map<String, dynamic> request) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mengunduh surat persetujuan...'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onResubmitRequest(Map<String, dynamic> request) {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/extension-request-form');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Monitoring Status'),
        elevation: 0,
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        foregroundColor: AppTheme.lightTheme.appBarTheme.foregroundColor,
        actions: [
          IconButton(
            onPressed: _refreshData,
            icon: CustomIconWidget(
              iconName: 'refresh',
              color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
              size: 24,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          color: AppTheme.lightTheme.primaryColor,
          child: Column(
            children: [
              // Search and Filter Section
              Container(
                padding: EdgeInsets.all(4.w),
                color: AppTheme.lightTheme.colorScheme.surface,
                child: Column(
                  children: [
                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                        decoration: InputDecoration(
                          hintText: 'Cari berdasarkan ID atau nama dokumen...',
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(3.w),
                            child: CustomIconWidget(
                              iconName: 'search',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                          ),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  onPressed: () {
                                    _searchController.clear();
                                    _onSearchChanged('');
                                  },
                                  icon: CustomIconWidget(
                                    iconName: 'clear',
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                    size: 20,
                                  ),
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 1.5.h,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    // Filter Chips
                    SizedBox(
                      height: 5.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _filterOptions.length,
                        itemBuilder: (context, index) {
                          final filter = _filterOptions[index];
                          return StatusFilterChip(
                            label: filter,
                            isSelected: _selectedFilter == filter,
                            onTap: () => _onFilterSelected(filter),
                          );
                        },
                      ),
                    ),
                    if (_lastUpdateTime != null) ...[
                      SizedBox(height: 1.h),
                      Text(
                        'Terakhir diperbarui: ${_lastUpdateTime!.hour.toString().padLeft(2, '0')}:${_lastUpdateTime!.minute.toString().padLeft(2, '0')}',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // Content Section
              Expanded(
                child: _isLoading
                    ? ListView.builder(
                        itemCount: 5,
                        itemBuilder: (context, index) => LoadingSkeletonCard(),
                      )
                    : _filteredRequests.isEmpty
                        ? EmptyStateWidget(
                            title: _searchQuery.isNotEmpty ||
                                    _selectedFilter != 'Semua'
                                ? 'Tidak Ada Hasil'
                                : 'Belum Ada Permohonan',
                            subtitle: _searchQuery.isNotEmpty ||
                                    _selectedFilter != 'Semua'
                                ? 'Tidak ada permohonan yang sesuai dengan filter atau pencarian Anda'
                                : 'Anda belum memiliki permohonan perpanjangan dokumen',
                            actionText: _searchQuery.isNotEmpty ||
                                    _selectedFilter != 'Semua'
                                ? 'Reset Filter'
                                : 'Buat Permohonan',
                            onActionPressed: _searchQuery.isNotEmpty ||
                                    _selectedFilter != 'Semua'
                                ? () {
                                    _searchController.clear();
                                    setState(() {
                                      _searchQuery = '';
                                      _selectedFilter = 'Semua';
                                    });
                                    _filterRequests();
                                  }
                                : () => Navigator.pushNamed(
                                    context, '/extension-request-form'),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            padding: EdgeInsets.only(bottom: 2.h),
                            itemCount: _filteredRequests.length,
                            itemBuilder: (context, index) {
                              final request = _filteredRequests[index];
                              return RequestStatusCard(
                                request: request,
                                onTap: () => _onRequestTap(request),
                                onViewDetails: () =>
                                    _showRequestDetails(request),
                                onDownloadLetter:
                                    request['status'] == 'approved'
                                        ? () => _onDownloadLetter(request)
                                        : null,
                                onResubmit: request['status'] == 'rejected'
                                    ? () => _onResubmitRequest(request)
                                    : null,
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
