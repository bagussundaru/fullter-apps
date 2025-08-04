import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/document_card_widget.dart';
import './widgets/header_widget.dart';
import './widgets/metrics_card_widget.dart';
import './widgets/pnbp_chart_widget.dart';
import './widgets/quota_gauge_widget.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({Key? key}) : super(key: key);

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard>
    with TickerProviderStateMixin {
  int _currentBottomNavIndex = 0;
  bool _isRefreshing = false;

  // Mock data for dashboard
  final List<Map<String, dynamic>> _recentDocuments = [
    {
      "id": 1,
      "title": "Pedoman Kerja Sama Teknis Bidang Kependudukan",
      "type": "PKS",
      "validUntil": "15/09/2024",
      "thumbnail":
          "https://images.unsplash.com/photo-1554224155-6726b3ff858f?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "id": 2,
      "title": "Petunjuk Teknis Penerbitan KTP Elektronik",
      "type": "JUKNIS",
      "validUntil": "28/12/2024",
      "thumbnail":
          "https://images.pexels.com/photos/5668473/pexels-photo-5668473.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    },
    {
      "id": 3,
      "title": "Proof of Concept Sistem Informasi Kependudukan",
      "type": "POC",
      "validUntil": "10/08/2024",
      "thumbnail":
          "https://images.pixabay.com/photo/2016/11/30/20/58/programming-1873854_1280.png",
    },
    {
      "id": 4,
      "title": "Standar Operasional Prosedur Pelayanan Adminduk",
      "type": "PKS",
      "validUntil": "05/11/2024",
      "thumbnail":
          "https://images.unsplash.com/photo-1450101499163-c8848c66ca85?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
  ];

  final List<Map<String, dynamic>> _dailyPnbpData = [
    {"label": "Sen", "amount": 125000.0},
    {"label": "Sel", "amount": 180000.0},
    {"label": "Rab", "amount": 95000.0},
    {"label": "Kam", "amount": 220000.0},
    {"label": "Jum", "amount": 165000.0},
    {"label": "Sab", "amount": 75000.0},
    {"label": "Min", "amount": 45000.0},
  ];

  final List<Map<String, dynamic>> _weeklyPnbpData = [
    {"label": "W1", "amount": 850000.0},
    {"label": "W2", "amount": 1200000.0},
    {"label": "W3", "amount": 950000.0},
    {"label": "W4", "amount": 1450000.0},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: AppTheme.lightTheme.colorScheme.primary,
          child: CustomScrollView(
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: HeaderWidget(
                  userName: "Budi Santoso",
                  notificationCount: 3,
                  onNotificationTap: () {
                    // Handle notification tap
                  },
                ),
              ),

              // Main Content
              SliverPadding(
                padding: EdgeInsets.all(4.w),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Metrics Cards Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MetricsCardWidget(
                          title: "Dokumen Aktif",
                          value: "24",
                          subtitle: "3 akan berakhir bulan ini",
                          icon: Icons.description,
                          accentColor: AppTheme.lightTheme.colorScheme.primary,
                          onTap: () => Navigator.pushNamed(
                              context, '/document-list-screen'),
                        ),
                        MetricsCardWidget(
                          title: "Permohonan",
                          value: "7",
                          subtitle: "2 menunggu persetujuan",
                          icon: Icons.pending_actions,
                          accentColor: Color(0xFFF59E0B),
                          onTap: () => Navigator.pushNamed(
                              context, '/request-status-monitoring'),
                        ),
                      ],
                    ),

                    SizedBox(height: 3.h),

                    // Quota Gauge
                    QuotaGaugeWidget(
                      usedQuota: 7.2,
                      totalQuota: 10.0,
                      quotaType: "Penyimpanan",
                    ),

                    SizedBox(height: 3.h),

                    // Document Quick Access Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Dokumen Terbaru',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(
                              context, '/document-list-screen'),
                          child: Text(
                            'Lihat Semua',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 2.h),

                    // Horizontal Document Cards
                    Container(
                      height: 28.h,
                      child: _recentDocuments.isNotEmpty
                          ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _recentDocuments.length,
                              itemBuilder: (context, index) {
                                final document = _recentDocuments[index];
                                return DocumentCardWidget(
                                  document: document,
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    '/document-preview-screen',
                                  ),
                                  onPreview: () => Navigator.pushNamed(
                                    context,
                                    '/document-preview-screen',
                                  ),
                                  onDownload: () =>
                                      _handleDocumentDownload(document),
                                  onExtend: () => Navigator.pushNamed(
                                    context,
                                    '/extension-request-form',
                                  ),
                                );
                              },
                            )
                          : _buildEmptyDocumentsState(),
                    ),

                    SizedBox(height: 3.h),

                    // PNBP Transaction Chart
                    PnbpChartWidget(
                      dailyData: _dailyPnbpData,
                      weeklyData: _weeklyPnbpData,
                    ),

                    SizedBox(height: 10.h), // Bottom padding for FAB
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            Navigator.pushNamed(context, '/extension-request-form'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        foregroundColor: AppTheme.lightTheme.colorScheme.onTertiary,
        icon: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.lightTheme.colorScheme.onTertiary,
          size: 5.w,
        ),
        label: Text(
          'Buat Permohonan',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onTertiary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentBottomNavIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
        unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        elevation: 8.0,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'home',
              color: _currentBottomNavIndex == 0
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'description',
              color: _currentBottomNavIndex == 1
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
            label: 'Dokumen',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'assignment',
              color: _currentBottomNavIndex == 2
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
            label: 'Permohonan',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'analytics',
              color: _currentBottomNavIndex == 3
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
            label: 'Monitoring',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _currentBottomNavIndex == 4
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyDocumentsState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'folder_open',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                .withValues(alpha: 0.5),
            size: 12.w,
          ),
          SizedBox(height: 2.h),
          Text(
            'Belum ada dokumen',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Dokumen yang Anda akses akan muncul di sini',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                  .withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          ElevatedButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/document-list-screen'),
            child: Text('Jelajahi Dokumen'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call delay
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    // Show refresh success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Dashboard berhasil diperbarui'),
        backgroundColor: Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _handleDocumentDownload(Map<String, dynamic> document) {
    final String title = (document['title'] as String?) ?? 'Document';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mengunduh: $title'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        action: SnackBarAction(
          label: 'Lihat',
          textColor: AppTheme.lightTheme.colorScheme.tertiary,
          onPressed: () {
            // Handle view downloaded file
          },
        ),
      ),
    );
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentBottomNavIndex = index;
    });

    // Navigate to respective screens based on index
    switch (index) {
      case 0:
        // Already on Home - do nothing
        break;
      case 1:
        Navigator.pushNamed(context, '/document-list-screen');
        break;
      case 2:
        Navigator.pushNamed(context, '/extension-request-form');
        break;
      case 3:
        Navigator.pushNamed(context, '/request-status-monitoring');
        break;
      case 4:
        // Navigate to profile screen (not specified in requirements)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fitur Profile akan segera hadir'),
            backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          ),
        );
        break;
    }
  }
}
