import 'dart:html' as html if (dart.library.html) 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/action_menu_widget.dart';
import './widgets/document_header_widget.dart';
import './widgets/document_metadata_overlay_widget.dart';
import './widgets/document_toolbar_widget.dart';
import './widgets/loading_skeleton_widget.dart';
import './widgets/pdf_viewer_widget.dart';

class DocumentPreviewScreen extends StatefulWidget {
  const DocumentPreviewScreen({Key? key}) : super(key: key);

  @override
  State<DocumentPreviewScreen> createState() => _DocumentPreviewScreenState();
}

class _DocumentPreviewScreenState extends State<DocumentPreviewScreen> {
  bool _isLoading = true;
  bool _hasError = false;
  bool _showMetadataOverlay = false;
  bool _showActionMenu = false;
  int _currentPage = 1;
  int _totalPages = 0;
  String _pdfPath = '';

  // Mock document data
  final Map<String, dynamic> _documentData = {
    "id": "DOC-2025-001",
    "title": "Pedoman Kerja Sama Daerah - Kementerian Dalam Negeri",
    "category": "PKS",
    "type": "Pedoman Kerja Sama",
    "createdDate": "15 Januari 2025",
    "validityPeriod": "15 Januari 2025 - 15 Januari 2027",
    "fileSize": "2.4 MB",
    "securityClassification": "Terbatas",
    "description":
        "Dokumen pedoman kerja sama antar daerah dalam rangka peningkatan pelayanan publik dan pembangunan daerah",
    "pdfUrl":
        "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf",
    "thumbnailUrl":
        "https://images.unsplash.com/photo-1568667256549-094345857637?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    "status": "Aktif",
    "downloadCount": 1247,
    "lastViewed": "2 Agustus 2025, 10:29"
  };

  @override
  void initState() {
    super.initState();
    _loadDocument();
  }

  Future<void> _loadDocument() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      // Simulate document loading
      await Future.delayed(Duration(seconds: 2));

      // In real implementation, this would download/cache the PDF
      _pdfPath = _documentData['pdfUrl'] as String;

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void _onPageChanged(int currentPage, int totalPages) {
    setState(() {
      _currentPage = currentPage;
      _totalPages = totalPages;
    });
  }

  void _onPdfError() {
    setState(() {
      _hasError = true;
      _isLoading = false;
    });
    _showErrorToast('Gagal memuat dokumen PDF');
  }

  void _showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.error,
      textColor: AppTheme.lightTheme.colorScheme.onError,
    );
  }

  void _showSuccessToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.getSuccessColor(true),
      textColor: Colors.white,
    );
  }

  Future<void> _downloadDocument() async {
    try {
      _showSuccessToast('Mengunduh dokumen...');

      if (kIsWeb) {
        // Web download implementation
        final anchor = html.AnchorElement(href: _documentData['pdfUrl'])
          ..setAttribute('download', '${_documentData['title']}.pdf')
          ..click();
      } else {
        // Mobile download would use path_provider and dio
        _showSuccessToast('Dokumen berhasil diunduh');
      }
    } catch (e) {
      _showErrorToast('Gagal mengunduh dokumen');
    }
  }

  Future<void> _shareDocument() async {
    try {
      if (kIsWeb) {
        // Web share using clipboard
        await Clipboard.setData(ClipboardData(text: _documentData['pdfUrl']));
        _showSuccessToast('Link dokumen disalin ke clipboard');
      } else {
        // Mobile share would use share_plus package
        _showSuccessToast('Dokumen berhasil dibagikan');
      }
    } catch (e) {
      _showErrorToast('Gagal membagikan dokumen');
    }
  }

  void _requestExtension() {
    Navigator.pushNamed(
      context,
      '/extension-request-form',
      arguments: _documentData,
    );
  }

  void _showMetadata() {
    setState(() {
      _showMetadataOverlay = true;
    });
  }

  void _hideMetadata() {
    setState(() {
      _showMetadataOverlay = false;
    });
  }

  void _showMenu() {
    setState(() {
      _showActionMenu = true;
    });
  }

  void _hideMenu() {
    setState(() {
      _showActionMenu = false;
    });
  }

  void _goToPage(int page) {
    // This would be handled by the PDF viewer widget
  }

  void _zoomIn() {
    // This would be handled by the PDF viewer widget
  }

  void _zoomOut() {
    // This would be handled by the PDF viewer widget
  }

  void _retryLoading() {
    _loadDocument();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          Column(
            children: [
              // Header
              DocumentHeaderWidget(
                documentTitle: _documentData['title'] as String,
                onBackPressed: () => Navigator.pop(context),
                onMenuPressed: _showMenu,
              ),
              // Content
              Expanded(
                child: _isLoading
                    ? LoadingSkeletonWidget()
                    : _hasError
                        ? _buildErrorView()
                        : _buildPdfView(),
              ),
              // Toolbar
              if (!_isLoading && !_hasError)
                DocumentToolbarWidget(
                  currentPage: _currentPage,
                  totalPages: _totalPages,
                  onZoomIn: _zoomIn,
                  onZoomOut: _zoomOut,
                  onExtensionRequest: _requestExtension,
                  onPageChanged: _goToPage,
                ),
            ],
          ),
          // Overlays
          ActionMenuWidget(
            isVisible: _showActionMenu,
            onDownload: _downloadDocument,
            onShare: _shareDocument,
            onExtend: _requestExtension,
            onShowMetadata: _showMetadata,
            onDismiss: _hideMenu,
          ),
          DocumentMetadataOverlayWidget(
            isVisible: _showMetadataOverlay,
            documentData: _documentData,
            onDismiss: _hideMetadata,
          ),
        ],
      ),
    );
  }

  Widget _buildPdfView() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: PdfViewerWidget(
        pdfPath: _pdfPath,
        onPageChanged: _onPageChanged,
        onError: _onPdfError,
      ),
    );
  }

  Widget _buildErrorView() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.all(6.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 20.w,
            height: 10.h,
            decoration: BoxDecoration(
              color:
                  AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'error_outline',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 48,
              ),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Gagal Memuat Dokumen',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            'Terjadi kesalahan saat memuat dokumen PDF. Periksa koneksi internet Anda dan coba lagi.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Kembali'),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: _retryLoading,
                  child: Text('Coba Lagi'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
