import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class DocumentSkeletonLoader extends StatefulWidget {
  const DocumentSkeletonLoader({Key? key}) : super(key: key);

  @override
  State<DocumentSkeletonLoader> createState() => _DocumentSkeletonLoaderState();
}

class _DocumentSkeletonLoaderState extends State<DocumentSkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ListView.builder(
          itemCount: 6,
          padding: EdgeInsets.symmetric(vertical: 2.h),
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thumbnail skeleton
                  Container(
                    width: 15.w,
                    height: 8.h,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: _animation.value),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  // Content skeleton
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title skeleton
                        Container(
                          height: 2.h,
                          width: 70.w,
                          decoration: BoxDecoration(
                            color: AppTheme
                                .lightTheme.colorScheme.surfaceContainerHighest
                                .withValues(alpha: _animation.value),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(height: 1.h),
                        // Subtitle skeleton
                        Container(
                          height: 1.5.h,
                          width: 50.w,
                          decoration: BoxDecoration(
                            color: AppTheme
                                .lightTheme.colorScheme.surfaceContainerHighest
                                .withValues(alpha: _animation.value),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(height: 1.h),
                        // Details skeleton
                        Row(
                          children: [
                            Container(
                              height: 1.2.h,
                              width: 15.w,
                              decoration: BoxDecoration(
                                color: AppTheme
                                    .lightTheme.colorScheme.surfaceContainerHighest
                                    .withValues(alpha: _animation.value),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Container(
                              height: 1.2.h,
                              width: 12.w,
                              decoration: BoxDecoration(
                                color: AppTheme
                                    .lightTheme.colorScheme.surfaceContainerHighest
                                    .withValues(alpha: _animation.value),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            Spacer(),
                            Container(
                              height: 1.2.h,
                              width: 20.w,
                              decoration: BoxDecoration(
                                color: AppTheme
                                    .lightTheme.colorScheme.surfaceContainerHighest
                                    .withValues(alpha: _animation.value),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
