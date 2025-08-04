import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/document_card.dart';
import './widgets/document_context_menu.dart';
import './widgets/document_filter_bottom_sheet.dart';
import './widgets/document_filter_chip.dart';
import './widgets/document_skeleton_loader.dart';

class DocumentListScreen extends StatefulWidget {
  const DocumentListScreen({Key? key}) : super(key: key);

  @override
  State<DocumentListScreen> createState() => _DocumentListScreenState();
}

class _DocumentListScreenState extends State<DocumentListScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;
  bool _isRefreshing = false;
  String _selectedSort = 'newest';
  int _selectedTabIndex = 1; // Dokumen tab active

  Map<String, dynamic> _filters = {
    'documentTypes': <String>[],
    'validityPeriods': <String>[],
    'fromDate': null,
    'toDate': null,
  };

  List<String> _selectedFilterChips = [];
  List<Map<String, dynamic>> _documents = [];
  List<Map<String, dynamic>> _filteredDocuments = [];

  // Mock data for documents
  final List<Map<String, dynamic>> _mockDocuments = [
    {
      "id": 1,
      "title":
          "Pedoman Kerja Sama Daerah dalam Pengelolaan Administrasi Kependudukan",
      "type": "PKS",
      "fileSize": "2.4",
      "validUntil": "2025-12-31",
      "createdAt": "2024-01-15",
      "thumbnail":
          "https://images.pexels.com/photos/4226140/pexels-photo-4226140.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "downloadUrl": "https://example.com/document1.pdf"
    },
    {
      "id": 2,
      "title":
          "Petunjuk Teknis Implementasi Sistem Informasi Administrasi Kependudukan",
      "type": "Juknis",
      "fileSize": "5.1",
      "validUntil": "2024-09-30",
      "createdAt": "2024-02-20",
      "thumbnail":
          "https://images.pexels.com/photos/590016/pexels-photo-590016.jpg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "downloadUrl": "https://example.com/document2.pdf"
    },
    {
      "id": 3,
      "title":
          "Proof of Concept: Integrasi Data Kependudukan dengan Sistem Pelayanan Publik",
      "type": "POC",
      "fileSize": "3.7",
      "validUntil": "2024-08-15",
      "createdAt": "2024-03-10",
      "thumbnail":
          "https://images.pexels.com/photos/159711/books-bookstore-book-reading-159711.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "downloadUrl": "https://example.com/document3.pdf"
    },
    {
      "id": 4,
      "title":
          "Standar Operasional Prosedur Penerbitan Kartu Tanda Penduduk Elektronik",
      "type": "PKS",
      "fileSize": "1.8",
      "validUntil": "2025-06-30",
      "createdAt": "2024-01-25",
      "thumbnail":
          "https://images.pexels.com/photos/301920/pexels-photo-301920.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "downloadUrl": "https://example.com/document4.pdf"
    },
    {
      "id": 5,
      "title": "Panduan Teknis Migrasi Data Kependudukan ke Sistem Terpusat",
      "type": "Juknis",
      "fileSize": "4.2",
      "validUntil": "2023-12-31",
      "createdAt": "2023-11-15",
      "thumbnail":
          "https://images.pexels.com/photos/256541/pexels-photo-256541.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "downloadUrl": "https://example.com/document5.pdf"
    },
    {
      "id": 6,
      "title": "Evaluasi Implementasi Sistem Administrasi Kependudukan Digital",
      "type": "POC",
      "fileSize": "6.3",
      "validUntil": "2025-03-31",
      "createdAt": "2024-04-05",
      "thumbnail":
          "https://images.pexels.com/photos/267507/pexels-photo-267507.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "downloadUrl": "https://example.com/document6.pdf"
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadDocuments();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadDocuments() {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    Future.delayed(Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _documents = List.from(_mockDocuments);
          _filteredDocuments = List.from(_documents);
          _isLoading = false;
        });
        _applyFiltersAndSort();
      }
    });
  }

  Future<void> _refreshDocuments() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API refresh
    await Future.delayed(Duration(milliseconds: 1000));

    if (mounted) {
      setState(() {
        _documents = List.from(_mockDocuments);
        _isRefreshing = false;
      });
      _applyFiltersAndSort();

      Fluttertoast.showToast(
        msg: "Documents refreshed successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  void _onSearchChanged() {
    _applyFiltersAndSort();
  }

  void _applyFiltersAndSort() {
    List<Map<String, dynamic>> filtered = List.from(_documents);

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      filtered = filtered.where((doc) {
        return (doc['title'] as String)
            .toLowerCase()
            .contains(_searchController.text.toLowerCase());
      }).toList();
    }

    // Apply document type filter
    final selectedTypes = _filters['documentTypes'] as List<String>;
    if (selectedTypes.isNotEmpty) {
      filtered = filtered.where((doc) {
        return selectedTypes.contains(doc['type'] as String);
      }).toList();
    }

    // Apply validity period filter
    final selectedPeriods = _filters['validityPeriods'] as List<String>;
    if (selectedPeriods.isNotEmpty) {
      filtered = filtered.where((doc) {
        final validUntil = DateTime.parse(doc['validUntil'] as String);
        final now = DateTime.now();
        final daysUntilExpiry = validUntil.difference(now).inDays;

        for (String period in selectedPeriods) {
          switch (period) {
            case 'Valid':
              if (daysUntilExpiry > 30) return true;
              break;
            case 'Expiring Soon':
              if (daysUntilExpiry <= 30 && daysUntilExpiry > 0) return true;
              break;
            case 'Expired':
              if (daysUntilExpiry <= 0) return true;
              break;
          }
        }
        return false;
      }).toList();
    }

    // Apply date range filter
    if (_filters['fromDate'] != null) {
      final fromDate = _filters['fromDate'] as DateTime;
      filtered = filtered.where((doc) {
        final createdAt = DateTime.parse(doc['createdAt'] as String);
        return createdAt.isAfter(fromDate) ||
            createdAt.isAtSameMomentAs(fromDate);
      }).toList();
    }

    if (_filters['toDate'] != null) {
      final toDate = _filters['toDate'] as DateTime;
      filtered = filtered.where((doc) {
        final createdAt = DateTime.parse(doc['createdAt'] as String);
        return createdAt.isBefore(toDate.add(Duration(days: 1)));
      }).toList();
    }

    // Apply sorting
    switch (_selectedSort) {
      case 'newest':
        filtered.sort((a, b) => DateTime.parse(b['createdAt'] as String)
            .compareTo(DateTime.parse(a['createdAt'] as String)));
        break;
      case 'expiring':
        filtered.sort((a, b) => DateTime.parse(a['validUntil'] as String)
            .compareTo(DateTime.parse(b['validUntil'] as String)));
        break;
      case 'alphabetical':
        filtered.sort(
            (a, b) => (a['title'] as String).compareTo(b['title'] as String));
        break;
      case 'fileSize':
        filtered.sort((a, b) => double.parse(b['fileSize'] as String)
            .compareTo(double.parse(a['fileSize'] as String)));
        break;
    }

    setState(() {
      _filteredDocuments = filtered;
    });
  }

  void _toggleFilterChip(String filter) {
    setState(() {
      if (_selectedFilterChips.contains(filter)) {
        _selectedFilterChips.remove(filter);
      } else {
        _selectedFilterChips.add(filter);
      }
    });
    _applyFiltersAndSort();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DocumentFilterBottomSheet(
        currentFilters: _filters,
        onFiltersChanged: (newFilters) {
          setState(() {
            _filters = newFilters;
          });
          _applyFiltersAndSort();
        },
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sort Documents',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 2.h),
              ...[
                {'key': 'newest', 'title': 'Newest First'},
                {'key': 'expiring', 'title': 'Expiring Soon'},
                {'key': 'alphabetical', 'title': 'Alphabetical'},
                {'key': 'fileSize', 'title': 'File Size'},
              ].map((option) {
                return ListTile(
                  title: Text(
                    option['title'] as String,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                  trailing: _selectedSort == option['key']
                      ? CustomIconWidget(
                          iconName: 'check',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 20,
                        )
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedSort = option['key'] as String;
                    });
                    _applyFiltersAndSort();
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  void _showDocumentContextMenu(Map<String, dynamic> document) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: DocumentContextMenu(
          document: document,
          onPreview: () => _previewDocument(document),
          onDownload: () => _downloadDocument(document),
          onRequestExtension: () => _requestExtension(document),
          onShare: () => _shareDocument(document),
        ),
      ),
    );
  }

  void _previewDocument(Map<String, dynamic> document) {
    Navigator.pushNamed(
      context,
      '/document-preview-screen',
      arguments: document,
    );
  }

  void _downloadDocument(Map<String, dynamic> document) {
    Fluttertoast.showToast(
      msg: "Downloading ${document['title']}...",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );

    // Simulate download progress
    Future.delayed(Duration(seconds: 2), () {
      Fluttertoast.showToast(
        msg: "Download completed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    });
  }

  void _requestExtension(Map<String, dynamic> document) {
    Navigator.pushNamed(
      context,
      '/extension-request-form',
      arguments: document,
    );
  }

  void _shareDocument(Map<String, dynamic> document) {
    Fluttertoast.showToast(
      msg: "Sharing ${document['title']}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  int _getDocumentCountByType(String type) {
    return _documents.where((doc) => doc['type'] == type).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Documents'),
        actions: [
          IconButton(
            onPressed: _showSortOptions,
            icon: CustomIconWidget(
              iconName: 'sort',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 24,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: EdgeInsets.all(4.w),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search documents...',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'search',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                suffixIcon: IconButton(
                  onPressed: _showFilterBottomSheet,
                  icon: CustomIconWidget(
                    iconName: 'filter_list',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
          // Filter chips
          Container(
            height: 6.h,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                DocumentFilterChip(
                  label: 'PKS',
                  count: _getDocumentCountByType('PKS'),
                  isSelected: _selectedFilterChips.contains('PKS'),
                  onTap: () => _toggleFilterChip('PKS'),
                ),
                DocumentFilterChip(
                  label: 'Juknis',
                  count: _getDocumentCountByType('Juknis'),
                  isSelected: _selectedFilterChips.contains('Juknis'),
                  onTap: () => _toggleFilterChip('Juknis'),
                ),
                DocumentFilterChip(
                  label: 'POC',
                  count: _getDocumentCountByType('POC'),
                  isSelected: _selectedFilterChips.contains('POC'),
                  onTap: () => _toggleFilterChip('POC'),
                ),
                DocumentFilterChip(
                  label: 'Valid',
                  count: _documents.where((doc) {
                    final validUntil =
                        DateTime.parse(doc['validUntil'] as String);
                    final now = DateTime.now();
                    return validUntil.difference(now).inDays > 30;
                  }).length,
                  isSelected: _selectedFilterChips.contains('Valid'),
                  onTap: () => _toggleFilterChip('Valid'),
                ),
                DocumentFilterChip(
                  label: 'Expiring',
                  count: _documents.where((doc) {
                    final validUntil =
                        DateTime.parse(doc['validUntil'] as String);
                    final now = DateTime.now();
                    final days = validUntil.difference(now).inDays;
                    return days <= 30 && days > 0;
                  }).length,
                  isSelected: _selectedFilterChips.contains('Expiring'),
                  onTap: () => _toggleFilterChip('Expiring'),
                ),
              ],
            ),
          ),
          // Document list
          Expanded(
            child: _isLoading
                ? DocumentSkeletonLoader()
                : RefreshIndicator(
                    onRefresh: _refreshDocuments,
                    color: AppTheme.lightTheme.colorScheme.primary,
                    child: _filteredDocuments.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            controller: _scrollController,
                            itemCount: _filteredDocuments.length,
                            padding: EdgeInsets.only(bottom: 2.h),
                            itemBuilder: (context, index) {
                              final document = _filteredDocuments[index];
                              return DocumentCard(
                                document: document,
                                onTap: () => _previewDocument(document),
                                onLongPress: () =>
                                    _showDocumentContextMenu(document),
                                onSwipeRight: () => _downloadDocument(document),
                              );
                            },
                          ),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'folder_open',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'No documents found',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            _searchController.text.isNotEmpty ||
                    _filters['documentTypes'].isNotEmpty
                ? 'Try adjusting your search or filters'
                : 'Pull down to refresh',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          if (_searchController.text.isNotEmpty ||
              _filters['documentTypes'].isNotEmpty) ...[
            SizedBox(height: 2.h),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  _filters = {
                    'documentTypes': <String>[],
                    'validityPeriods': <String>[],
                    'fromDate': null,
                    'toDate': null,
                  };
                  _selectedFilterChips.clear();
                });
                _applyFiltersAndSort();
              },
              child: Text('Clear Filters'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedTabIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        setState(() {
          _selectedTabIndex = index;
        });

        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/home-dashboard');
            break;
          case 1:
            // Already on documents screen
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/extension-request-form');
            break;
          case 3:
            Navigator.pushReplacementNamed(
                context, '/request-status-monitoring');
            break;
          case 4:
            // Navigate to profile (not implemented in this screen)
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'home',
            color: _selectedTabIndex == 0
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'folder',
            color: _selectedTabIndex == 1
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Dokumen',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'assignment',
            color: _selectedTabIndex == 2
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Permohonan',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'analytics',
            color: _selectedTabIndex == 3
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Monitoring',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'person',
            color: _selectedTabIndex == 4
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Profile',
        ),
      ],
    );
  }
}
