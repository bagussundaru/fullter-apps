import 'dart:io' if (dart.library.io) 'dart:io';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SupportingDocumentsWidget extends StatefulWidget {
  final List<Map<String, dynamic>> attachedFiles;
  final Function(Map<String, dynamic>) onFileAdded;
  final Function(int) onFileRemoved;

  const SupportingDocumentsWidget({
    Key? key,
    required this.attachedFiles,
    required this.onFileAdded,
    required this.onFileRemoved,
  }) : super(key: key);

  @override
  State<SupportingDocumentsWidget> createState() =>
      _SupportingDocumentsWidgetState();
}

class _SupportingDocumentsWidgetState extends State<SupportingDocumentsWidget> {
  final ImagePicker _imagePicker = ImagePicker();
  List<CameraDescription> _cameras = [];
  CameraController? _cameraController;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      if (!kIsWeb) {
        _cameras = await availableCameras();
        if (_cameras.isNotEmpty) {
          final camera = _cameras.firstWhere(
            (c) => c.lensDirection == CameraLensDirection.back,
            orElse: () => _cameras.first,
          );

          _cameraController = CameraController(
            camera,
            ResolutionPreset.high,
          );

          await _cameraController!.initialize();

          if (mounted) {
            setState(() {
              _isCameraInitialized = true;
            });
          }
        }
      }
    } catch (e) {
      // Handle camera initialization error silently
    }
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;

    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<bool> _requestStoragePermission() async {
    if (kIsWeb) return true;

    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      return status.isGranted;
    }
    return true;
  }

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
                iconName: 'attach_file',
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Dokumen Pendukung',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            'Lampirkan dokumen pendukung (opsional)',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: 3.h),
          _buildUploadButtons(),
          if (widget.attachedFiles.isNotEmpty) ...[
            SizedBox(height: 3.h),
            _buildAttachedFiles(),
          ],
        ],
      ),
    );
  }

  Widget _buildUploadButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _pickFromCamera,
            icon: CustomIconWidget(
              iconName: 'camera_alt',
              color: AppTheme.lightTheme.primaryColor,
              size: 18,
            ),
            label: Text(
              'Kamera',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.lightTheme.primaryColor,
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 2.5.h),
              side: BorderSide(
                color: AppTheme.lightTheme.primaryColor,
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
          child: OutlinedButton.icon(
            onPressed: _pickFromFiles,
            icon: CustomIconWidget(
              iconName: 'folder',
              color: AppTheme.lightTheme.primaryColor,
              size: 18,
            ),
            label: Text(
              'File',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.lightTheme.primaryColor,
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 2.5.h),
              side: BorderSide(
                color: AppTheme.lightTheme.primaryColor,
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttachedFiles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'File Terlampir (${widget.attachedFiles.length})',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 2.h),
        ...widget.attachedFiles.asMap().entries.map((entry) {
          final index = entry.key;
          final file = entry.value;
          return _buildFileItem(file, index);
        }),
      ],
    );
  }

  Widget _buildFileItem(Map<String, dynamic> file, int index) {
    final fileName = file['name'] as String;
    final fileSize = file['size'] as int;
    final fileType = file['type'] as String;
    final isUploading = file['isUploading'] as bool? ?? false;
    final uploadProgress = file['uploadProgress'] as double? ?? 0.0;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: _getFileTypeColor(fileType),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: CustomIconWidget(
                  iconName: _getFileTypeIcon(fileType),
                  color: Colors.white,
                  size: 16,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fileName,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      _formatFileSize(fileSize),
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isUploading)
                IconButton(
                  onPressed: () => widget.onFileRemoved(index),
                  icon: CustomIconWidget(
                    iconName: 'delete_outline',
                    color: AppTheme.lightTheme.colorScheme.error,
                    size: 20,
                  ),
                  padding: EdgeInsets.all(1.w),
                  constraints: BoxConstraints(
                    minWidth: 8.w,
                    minHeight: 8.w,
                  ),
                ),
            ],
          ),
          if (isUploading) ...[
            SizedBox(height: 2.h),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Mengunggah...',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.primaryColor,
                      ),
                    ),
                    Text(
                      '${(uploadProgress * 100).toInt()}%',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                LinearProgressIndicator(
                  value: uploadProgress,
                  backgroundColor: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.lightTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _pickFromCamera() async {
    try {
      final hasPermission = await _requestCameraPermission();
      if (!hasPermission) return;

      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        final file = {
          'name': 'Camera_${DateTime.now().millisecondsSinceEpoch}.jpg',
          'size': bytes.length,
          'type': 'image',
          'path': image.path,
          'bytes': bytes,
          'isUploading': true,
          'uploadProgress': 0.0,
        };

        widget.onFileAdded(file);
        _simulateUpload(file);
      }
    } catch (e) {
      _showErrorSnackBar('Gagal mengambil foto dari kamera');
    }
  }

  Future<void> _pickFromFiles() async {
    try {
      final hasPermission = await _requestStoragePermission();
      if (!hasPermission) return;

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final pickedFile = result.files.first;
        final bytes = kIsWeb
            ? pickedFile.bytes!
            : await File(pickedFile.path!).readAsBytes();

        final file = {
          'name': pickedFile.name,
          'size': pickedFile.size,
          'type': _getFileTypeFromExtension(pickedFile.extension ?? ''),
          'path': pickedFile.path,
          'bytes': bytes,
          'isUploading': true,
          'uploadProgress': 0.0,
        };

        widget.onFileAdded(file);
        _simulateUpload(file);
      }
    } catch (e) {
      _showErrorSnackBar('Gagal memilih file');
    }
  }

  void _simulateUpload(Map<String, dynamic> file) {
    // Simulate file upload progress
    final index = widget.attachedFiles.indexOf(file);
    if (index == -1) return;

    double progress = 0.0;
    const duration = Duration(milliseconds: 100);

    void updateProgress() {
      if (progress >= 1.0) {
        file['isUploading'] = false;
        file['uploadProgress'] = 1.0;
        if (mounted) setState(() {});
        return;
      }

      progress += 0.1;
      file['uploadProgress'] = progress;
      if (mounted) setState(() {});

      Future.delayed(duration, updateProgress);
    }

    updateProgress();
  }

  String _getFileTypeFromExtension(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return 'pdf';
      case 'doc':
      case 'docx':
        return 'document';
      case 'jpg':
      case 'jpeg':
      case 'png':
        return 'image';
      default:
        return 'file';
    }
  }

  Color _getFileTypeColor(String type) {
    switch (type) {
      case 'pdf':
        return Color(0xFFEF4444);
      case 'document':
        return Color(0xFF3B82F6);
      case 'image':
        return Color(0xFF10B981);
      default:
        return AppTheme.lightTheme.primaryColor;
    }
  }

  String _getFileTypeIcon(String type) {
    switch (type) {
      case 'pdf':
        return 'picture_as_pdf';
      case 'document':
        return 'description';
      case 'image':
        return 'image';
      default:
        return 'insert_drive_file';
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
