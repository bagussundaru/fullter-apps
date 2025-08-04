import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _emblemController;
  late AnimationController _loadingController;
  late Animation<double> _emblemScaleAnimation;
  late Animation<double> _emblemFadeAnimation;
  late Animation<double> _loadingAnimation;

  bool _isInitializing = true;
  bool _hasError = false;
  String _statusMessage = 'Memuat aplikasi...';

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startInitialization();
  }

  void _initializeAnimations() {
    // Emblem animation controller
    _emblemController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Loading animation controller
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    // Emblem scale animation
    _emblemScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _emblemController,
      curve: Curves.elasticOut,
    ));

    // Emblem fade animation
    _emblemFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _emblemController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeInOut),
    ));

    // Loading indicator animation
    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingController,
      curve: Curves.easeInOut,
    ));

    // Start emblem animation
    _emblemController.forward();
  }

  Future<void> _startInitialization() async {
    try {
      // Set status bar color to match theme
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Color(0xFF1E293B),
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Color(0xFF1E293B),
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      );

      // Simulate initialization tasks
      await _performInitializationTasks();

      // Navigate to appropriate screen after initialization
      if (mounted) {
        await _navigateToNextScreen();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _statusMessage = 'Terjadi kesalahan saat memuat aplikasi';
        });

        // Show retry option after 3 seconds
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            _showRetryOption();
          }
        });
      }
    }
  }

  Future<void> _performInitializationTasks() async {
    // Task 1: Check authentication status
    setState(() {
      _statusMessage = 'Memeriksa status autentikasi...';
    });
    await Future.delayed(const Duration(milliseconds: 800));

    // Task 2: Load user preferences
    setState(() {
      _statusMessage = 'Memuat preferensi pengguna...';
    });
    await Future.delayed(const Duration(milliseconds: 600));

    // Task 3: Fetch government certificates
    setState(() {
      _statusMessage = 'Memuat sertifikat pemerintah...';
    });
    await Future.delayed(const Duration(milliseconds: 700));

    // Task 4: Prepare cached document data
    setState(() {
      _statusMessage = 'Menyiapkan data dokumen...';
    });
    await Future.delayed(const Duration(milliseconds: 500));

    // Task 5: Final initialization
    setState(() {
      _statusMessage = 'Menyelesaikan inisialisasi...';
      _isInitializing = false;
    });
    await Future.delayed(const Duration(milliseconds: 400));
  }

  Future<void> _navigateToNextScreen() async {
    // Simulate authentication check
    final bool isAuthenticated = await _checkAuthenticationStatus();
    final bool hasBiometricSetup = await _checkBiometricSetup();

    // Add smooth transition delay
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    // Navigation logic based on authentication status
    if (isAuthenticated && hasBiometricSetup) {
      // Authenticated users with biometric setup go to Home dashboard
      Navigator.pushReplacementNamed(context, '/home-dashboard');
    } else if (isAuthenticated && !hasBiometricSetup) {
      // Users requiring re-authentication see Login screen
      Navigator.pushReplacementNamed(context, '/home-dashboard');
    } else {
      // First-time users reach Registration screen
      Navigator.pushReplacementNamed(context, '/home-dashboard');
    }
  }

  Future<bool> _checkAuthenticationStatus() async {
    // Simulate JWT token validation
    await Future.delayed(const Duration(milliseconds: 200));
    // For demo purposes, return true (authenticated)
    return true;
  }

  Future<bool> _checkBiometricSetup() async {
    // Simulate biometric availability check
    await Future.delayed(const Duration(milliseconds: 100));
    // For demo purposes, return true (biometric available)
    return true;
  }

  void _showRetryOption() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          title: Text(
            'Koneksi Bermasalah',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          content: Text(
            'Tidak dapat memuat aplikasi. Periksa koneksi internet Anda dan coba lagi.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _hasError = false;
                  _isInitializing = true;
                  _statusMessage = 'Memuat aplikasi...';
                });
                _startInitialization();
              },
              child: Text(
                'Coba Lagi',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _emblemController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.lightTheme.colorScheme.primary,
              AppTheme.lightTheme.colorScheme.primaryContainer,
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.8),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Spacer to push content to center
              const Spacer(flex: 2),

              // Indonesian Ministry of Home Affairs Emblem
              AnimatedBuilder(
                animation: _emblemController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _emblemScaleAnimation.value,
                    child: Opacity(
                      opacity: _emblemFadeAnimation.value,
                      child: Container(
                        width: 35.w,
                        height: 35.w,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.surface,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Center(
                          child: CustomImageWidget(
                            imageUrl:
                                "https://upload.wikimedia.org/wikipedia/commons/thumb/9/9f/Coat_of_arms_of_Indonesia_Garuda_Pancasila.svg/1200px-Coat_of_arms_of_Indonesia_Garuda_Pancasila.svg.png",
                            width: 25.w,
                            height: 25.w,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 4.h),

              // Application Title
              AnimatedBuilder(
                animation: _emblemController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _emblemFadeAnimation.value,
                    child: Column(
                      children: [
                        Text(
                          'DataKependudukan',
                          style: AppTheme.lightTheme.textTheme.headlineMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Kementerian Dalam Negeri',
                          style:
                              AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onPrimary
                                .withValues(alpha: 0.8),
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.3,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          'Republik Indonesia',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onPrimary
                                .withValues(alpha: 0.7),
                            fontWeight: FontWeight.w300,
                            letterSpacing: 0.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),

              const Spacer(flex: 2),

              // Loading Section
              AnimatedBuilder(
                animation: _emblemController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _emblemFadeAnimation.value,
                    child: Column(
                      children: [
                        // Loading Indicator
                        _hasError
                            ? CustomIconWidget(
                                iconName: 'error_outline',
                                color: AppTheme.getWarningColor(true),
                                size: 8.w,
                              )
                            : SizedBox(
                                width: 8.w,
                                height: 8.w,
                                child: AnimatedBuilder(
                                  animation: _loadingAnimation,
                                  builder: (context, child) {
                                    return CircularProgressIndicator(
                                      value: _isInitializing ? null : 1.0,
                                      strokeWidth: 3.0,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppTheme.getAccentColor(true),
                                      ),
                                      backgroundColor: AppTheme
                                          .lightTheme.colorScheme.onPrimary
                                          .withValues(alpha: 0.3),
                                    );
                                  },
                                ),
                              ),

                        SizedBox(height: 2.h),

                        // Status Message
                        Container(
                          constraints: BoxConstraints(maxWidth: 80.w),
                          child: Text(
                            _statusMessage,
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: _hasError
                                  ? AppTheme.getWarningColor(true)
                                  : AppTheme.lightTheme.colorScheme.onPrimary
                                      .withValues(alpha: 0.8),
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              SizedBox(height: 6.h),

              // Footer
              AnimatedBuilder(
                animation: _emblemController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _emblemFadeAnimation.value * 0.6,
                    child: Column(
                      children: [
                        Text(
                          'Versi 1.0.0',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onPrimary
                                .withValues(alpha: 0.5),
                            fontSize: 10.sp,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          '© 2025 Kementerian Dalam Negeri RI',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onPrimary
                                .withValues(alpha: 0.4),
                            fontSize: 9.sp,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
