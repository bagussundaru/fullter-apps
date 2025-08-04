import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class LoadingSkeletonWidget extends StatefulWidget {
  const LoadingSkeletonWidget({Key? key}) : super(key: key);

  @override
  State<LoadingSkeletonWidget> createState() => _LoadingSkeletonWidgetState();
}

class _LoadingSkeletonWidgetState extends State<LoadingSkeletonWidget>
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
        return Container(
          width: double.infinity,
          height: double.infinity,
          color: AppTheme.lightTheme.colorScheme.surface,
          child: Column(
            children: [
              // Header skeleton
              Container(
                width: double.infinity,
                height: 8.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.lightTheme.colorScheme.shadow,
                      offset: Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    child: Row(
                      children: [
                        Container(
                          width: 10.w,
                          height: 5.h,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: _animation.value * 0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Container(
                            height: 3.h,
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: _animation.value * 0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Container(
                          width: 10.w,
                          height: 5.h,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: _animation.value * 0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // PDF content skeleton
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: _animation.value * 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 4.h),
                      // Simulate PDF page content
                      ...List.generate(
                          8,
                          (index) => Container(
                                width: 80.w,
                                height: 2.h,
                                margin: EdgeInsets.symmetric(vertical: 1.h),
                                decoration: BoxDecoration(
                                  color: AppTheme.lightTheme.colorScheme.outline
                                      .withValues(
                                          alpha: _animation.value * 0.4),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              )),
                      Spacer(),
                      Container(
                        width: 60.w,
                        height: 20.h,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: _animation.value * 0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ),
              // Toolbar skeleton
              Container(
                width: double.infinity,
                height: 10.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.lightTheme.colorScheme.shadow,
                      offset: Offset(0, -2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 10.w,
                                  height: 4.h,
                                  decoration: BoxDecoration(
                                    color: AppTheme
                                        .lightTheme.colorScheme.outline
                                        .withValues(
                                            alpha: _animation.value * 0.3),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                SizedBox(width: 3.w),
                                Container(
                                  width: 20.w,
                                  height: 4.h,
                                  decoration: BoxDecoration(
                                    color: AppTheme
                                        .lightTheme.colorScheme.outline
                                        .withValues(
                                            alpha: _animation.value * 0.3),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                SizedBox(width: 3.w),
                                Container(
                                  width: 10.w,
                                  height: 4.h,
                                  decoration: BoxDecoration(
                                    color: AppTheme
                                        .lightTheme.colorScheme.outline
                                        .withValues(
                                            alpha: _animation.value * 0.3),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 10.w,
                                  height: 4.h,
                                  decoration: BoxDecoration(
                                    color: AppTheme
                                        .lightTheme.colorScheme.outline
                                        .withValues(
                                            alpha: _animation.value * 0.3),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                Container(
                                  width: 10.w,
                                  height: 4.h,
                                  decoration: BoxDecoration(
                                    color: AppTheme
                                        .lightTheme.colorScheme.outline
                                        .withValues(
                                            alpha: _animation.value * 0.3),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Container(
                          width: double.infinity,
                          height: 5.h,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: _animation.value * 0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
