import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class LoadingSkeletonCard extends StatefulWidget {
  const LoadingSkeletonCard({Key? key}) : super(key: key);

  @override
  State<LoadingSkeletonCard> createState() => _LoadingSkeletonCardState();
}

class _LoadingSkeletonCardState extends State<LoadingSkeletonCard>
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
    _animation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
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
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.shadow,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 30.w,
                    height: 2.h,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: _animation.value * 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Container(
                    width: 20.w,
                    height: 3.h,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: _animation.value * 0.3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Container(
                width: 50.w,
                height: 1.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: _animation.value * 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(height: 1.h),
              Container(
                width: 70.w,
                height: 1.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: _animation.value * 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(height: 1.h),
              Container(
                width: 40.w,
                height: 1.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: _animation.value * 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(height: 2.h),
              Row(
                children: List.generate(3, (index) {
                  return Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: _animation.value * 0.3),
                            shape: BoxShape.circle,
                          ),
                        ),
                        if (index < 2)
                          Expanded(
                            child: Container(
                              height: 2,
                              margin: EdgeInsets.symmetric(horizontal: 2.w),
                              color: AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: _animation.value * 0.3),
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
