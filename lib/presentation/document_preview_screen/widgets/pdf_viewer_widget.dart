import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfViewerWidget extends StatefulWidget {
  final String pdfPath;
  final Function(int currentPage, int totalPages) onPageChanged;
  final Function() onError;

  const PdfViewerWidget({
    Key? key,
    required this.pdfPath,
    required this.onPageChanged,
    required this.onError,
  }) : super(key: key);

  @override
  State<PdfViewerWidget> createState() => _PdfViewerWidgetState();
}

class _PdfViewerWidgetState extends State<PdfViewerWidget> {
  PDFViewController? _pdfController;
  int _currentPage = 1;
  int _totalPages = 0;
  bool _isReady = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: PDFView(
        filePath: widget.pdfPath,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: false,
        pageFling: true,
        pageSnap: true,
        defaultPage: 0,
        fitPolicy: FitPolicy.BOTH,
        preventLinkNavigation: false,
        onRender: (pages) {
          setState(() {
            _totalPages = pages ?? 0;
            _isReady = true;
          });
          widget.onPageChanged(_currentPage, _totalPages);
        },
        onError: (error) {
          widget.onError();
        },
        onPageError: (page, error) {
          widget.onError();
        },
        onViewCreated: (PDFViewController pdfViewController) {
          _pdfController = pdfViewController;
        },
        onLinkHandler: (String? uri) {
          // Handle PDF links if needed
        },
        onPageChanged: (int? page, int? total) {
          setState(() {
            _currentPage = (page ?? 0) + 1;
            _totalPages = total ?? 0;
          });
          widget.onPageChanged(_currentPage, _totalPages);
        },
      ),
    );
  }

  Future<void> goToPage(int page) async {
    if (_pdfController != null && page > 0 && page <= _totalPages) {
      await _pdfController!.setPage(page - 1);
    }
  }

  Future<void> zoomIn() async {
    if (_pdfController != null) {
      // Remove zoom functionality as getZoomLevel and setZoom are not available
    }
  }

  Future<void> zoomOut() async {
    if (_pdfController != null) {
      // Remove zoom functionality as getZoomLevel and setZoom are not available
    }
  }
}