import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/document_picker_bottom_sheet.dart';
import './widgets/document_selection_widget.dart';
import './widgets/form_progress_widget.dart';
import './widgets/reason_input_widget.dart';
import './widgets/supporting_documents_widget.dart';

class ExtensionRequestForm extends StatefulWidget {
  const ExtensionRequestForm({Key? key}) : super(key: key);

  @override
  State<ExtensionRequestForm> createState() => _ExtensionRequestFormState();
}

class _ExtensionRequestFormState extends State<ExtensionRequestForm> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();

  List<Map<String, dynamic>> _selectedDocuments = [];
  List<Map<String, dynamic>> _attachedFiles = [];
  String? _reasonError;
  bool _isSubmitting = false;
  bool _isDraftSaved = false;

  // Mock available documents
  final List<Map<String, dynamic>> _availableDocuments = [
    {
      "id": 1,
      "name": "Perjanjian Kerjasama Pembangunan Infrastruktur Digital",
      "type": "PKS",
      "expiryDate": "15/03/2025",
      "status": "Akan Berakhir",
      "thumbnail":
          "https://images.pexels.com/photos/4386321/pexels-photo-4386321.jpeg?auto=compress&cs=tinysrgb&w=400"
    },
    {
      "id": 2,
      "name": "Petunjuk Teknis Implementasi Sistem E-Government",
      "type": "Juknis",
      "expiryDate": "28/02/2025",
      "status": "Akan Berakhir",
      "thumbnail":
          "https://images.pixabay.com/photo/2016/11/30/20/58/programming-1873854_640.png"
    },
    {
      "id": 3,
      "name": "Proof of Concept Aplikasi Mobile Kependudukan",
      "type": "POC",
      "expiryDate": "10/04/2025",
      "status": "Aktif",
      "thumbnail":
          "https://images.unsplash.com/photo-1551650975-87deedd944c3?auto=format&fit=crop&w=400&q=60"
    },
    {
      "id": 4,
      "name": "Perjanjian Kerjasama Pengembangan Database Nasional",
      "type": "PKS",
      "expiryDate": "05/01/2025",
      "status": "Berakhir",
      "thumbnail":
          "https://images.pexels.com/photos/590016/pexels-photo-590016.jpeg?auto=compress&cs=tinysrgb&w=400"
    },
    {
      "id": 5,
      "name": "Petunjuk Teknis Keamanan Data Kependudukan",
      "type": "Juknis",
      "expiryDate": "20/06/2025",
      "status": "Aktif",
      "thumbnail":
          "https://images.pixabay.com/photo/2018/05/14/16/25/cyber-security-3400555_640.jpg"
    },
  ];

  final List<String> _allFormSteps = [
    'Pilih dokumen yang akan diperpanjang',
    'Isi alasan permohonan perpanjangan',
    'Lampirkan dokumen pendukung (opsional)',
    'Periksa dan kirim permohonan',
  ];

  @override
  void initState() {
    super.initState();
    _loadDraftData();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _loadDraftData() {
    // Simulate loading draft data from local storage
    // In real implementation, this would load from SharedPreferences or local database
  }

  void _saveDraft() {
    // Simulate saving draft data to local storage
    setState(() {
      _isDraftSaved = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'save',
              color: Colors.white,
              size: 16,
            ),
            SizedBox(width: 2.w),
            Text('Draft tersimpan otomatis'),
          ],
        ),
        backgroundColor: AppTheme.getSuccessColor(true),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  List<String> _getCompletedSteps() {
    List<String> completed = [];

    if (_selectedDocuments.isNotEmpty) {
      completed.add(_allFormSteps[0]);
    }

    if (_reasonController.text.trim().isNotEmpty) {
      completed.add(_allFormSteps[1]);
    }

    // Step 3 is optional, so we always consider it completed
    completed.add(_allFormSteps[2]);

    if (_selectedDocuments.isNotEmpty &&
        _reasonController.text.trim().isNotEmpty) {
      completed.add(_allFormSteps[3]);
    }

    return completed;
  }

  double _getFormProgress() {
    final completed = _getCompletedSteps();
    return completed.length / _allFormSteps.length;
  }

  bool _isFormValid() {
    return _selectedDocuments.isNotEmpty &&
        _reasonController.text.trim().isNotEmpty &&
        _reasonError == null;
  }

  void _validateReason(String value) {
    setState(() {
      if (value.trim().isEmpty) {
        _reasonError = 'Alasan permohonan harus diisi';
      } else if (value.trim().length < 10) {
        _reasonError = 'Alasan permohonan minimal 10 karakter';
      } else if (value.length > 500) {
        _reasonError = 'Alasan permohonan maksimal 500 karakter';
      } else {
        _reasonError = null;
      }
    });
  }

  void _showDocumentPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DocumentPickerBottomSheet(
        availableDocuments: _availableDocuments,
        selectedDocuments: _selectedDocuments,
        onDocumentsSelected: (documents) {
          setState(() {
            _selectedDocuments = documents;
          });
          _saveDraft();
        },
      ),
    );
  }

  void _removeDocument(int index) {
    setState(() {
      _selectedDocuments.removeAt(index);
    });
    _saveDraft();
  }

  void _addSupportingFile(Map<String, dynamic> file) {
    setState(() {
      _attachedFiles.add(file);
    });
    _saveDraft();
  }

  void _removeSupportingFile(int index) {
    setState(() {
      _attachedFiles.removeAt(index);
    });
    _saveDraft();
  }

  Future<void> _submitForm() async {
    if (!_isFormValid()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 3));

      // Generate mock request ID
      final requestId =
          'REQ${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';

      if (mounted) {
        _showSuccessDialog(requestId);
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _showSuccessDialog(String requestId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16.w,
              height: 16.w,
              decoration: BoxDecoration(
                color: AppTheme.getSuccessColor(true),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'check',
                color: Colors.white,
                size: 32,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Permohonan Berhasil Dikirim',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'ID Permohonan: $requestId',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppTheme.lightTheme.primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              'Estimasi waktu pemrosesan: 3-5 hari kerja',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pushReplacementNamed(
                      context, '/request-status-monitoring');
                },
                child: Text(
                  'Lihat Status Permohonan',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.getSuccessColor(true),
                  padding: EdgeInsets.symmetric(vertical: 3.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Go back to previous screen
                },
                child: Text(
                  'Kembali',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.7),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16.w,
              height: 16.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.error,
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'error_outline',
                color: Colors.white,
                size: 32,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Gagal Mengirim Permohonan',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'Terjadi kesalahan saat mengirim permohonan. Silakan periksa koneksi internet dan coba lagi.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            Row(
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
                      padding: EdgeInsets.symmetric(vertical: 2.5.h),
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
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _submitForm();
                    },
                    child: Text(
                      'Coba Lagi',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.lightTheme.colorScheme.error,
                      padding: EdgeInsets.symmetric(vertical: 2.5.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Permohonan Perpanjangan'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
            size: 24,
          ),
        ),
        actions: [
          if (_isDraftSaved)
            Padding(
              padding: EdgeInsets.only(right: 4.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'cloud_done',
                    color: AppTheme.getSuccessColor(true),
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    'Tersimpan',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.getSuccessColor(true),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Progress indicator
            Container(
              padding: EdgeInsets.all(4.w),
              child: FormProgressWidget(
                progress: _getFormProgress(),
                completedSteps: _getCompletedSteps(),
                allSteps: _allFormSteps,
              ),
            ),

            // Scrollable form content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  children: [
                    SizedBox(height: 2.h),

                    // Document selection
                    DocumentSelectionWidget(
                      selectedDocuments: _selectedDocuments,
                      onAddDocument: _showDocumentPicker,
                      onRemoveDocument: _removeDocument,
                    ),

                    SizedBox(height: 3.h),

                    // Reason input
                    ReasonInputWidget(
                      controller: _reasonController,
                      errorText: _reasonError,
                      onChanged: (value) {
                        _validateReason(value);
                        _saveDraft();
                      },
                    ),

                    SizedBox(height: 3.h),

                    // Supporting documents
                    SupportingDocumentsWidget(
                      attachedFiles: _attachedFiles,
                      onFileAdded: _addSupportingFile,
                      onFileRemoved: _removeSupportingFile,
                    ),

                    SizedBox(height: 8.h), // Extra space for bottom button
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom submit button
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isFormValid() && !_isSubmitting ? _submitForm : null,
              child: _isSubmitting
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          'Mengirim Permohonan...',
                          style: AppTheme.lightTheme.textTheme.labelLarge
                              ?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      'Kirim Permohonan',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                      ),
                    ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isFormValid() && !_isSubmitting
                    ? AppTheme.getSuccessColor(true)
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                padding: EdgeInsets.symmetric(vertical: 3.5.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: _isFormValid() && !_isSubmitting ? 2 : 0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
