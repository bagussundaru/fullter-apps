import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/home_dashboard/home_dashboard.dart';
import '../presentation/document_preview_screen/document_preview_screen.dart';
import '../presentation/document_list_screen/document_list_screen.dart';
import '../presentation/extension_request_form/extension_request_form.dart';
import '../presentation/request_status_monitoring/request_status_monitoring.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splash = '/splash-screen';
  static const String homeDashboard = '/home-dashboard';
  static const String documentPreview = '/document-preview-screen';
  static const String documentList = '/document-list-screen';
  static const String extensionRequestForm = '/extension-request-form';
  static const String requestStatusMonitoring = '/request-status-monitoring';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splash: (context) => const SplashScreen(),
    homeDashboard: (context) => const HomeDashboard(),
    documentPreview: (context) => const DocumentPreviewScreen(),
    documentList: (context) => const DocumentListScreen(),
    extensionRequestForm: (context) => const ExtensionRequestForm(),
    requestStatusMonitoring: (context) => const RequestStatusMonitoring(),
    // TODO: Add your other routes here
  };
}
