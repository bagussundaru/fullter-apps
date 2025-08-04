import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class QuotaGaugeWidget extends StatelessWidget {
  final double usedQuota;
  final double totalQuota;
  final String quotaType;

  const QuotaGaugeWidget({
    Key? key,
    required this.usedQuota,
    required this.totalQuota,
    required this.quotaType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double percentage = (usedQuota / totalQuota) * 100;
    final Color gaugeColor = _getGaugeColor(percentage);

    return Container(
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
              Text(
                'Kuota $quotaType',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                decoration: BoxDecoration(
                  color: gaugeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: gaugeColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Gauge Chart
          Container(
            height: 20.h,
            child: Semantics(
              label:
                  "Quota Usage Gauge Chart showing ${percentage.toStringAsFixed(1)}% usage",
              child: PieChart(
                PieChartData(
                  startDegreeOffset: 180,
                  sectionsSpace: 2,
                  centerSpaceRadius: 8.w,
                  sections: [
                    PieChartSectionData(
                      value: usedQuota,
                      color: gaugeColor,
                      radius: 4.w,
                      showTitle: false,
                    ),
                    PieChartSectionData(
                      value: totalQuota - usedQuota,
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                      radius: 4.w,
                      showTitle: false,
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Usage Details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Terpakai',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    '${usedQuota.toStringAsFixed(0)} GB',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: gaugeColor,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Total',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    '${totalQuota.toStringAsFixed(0)} GB',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getGaugeColor(double percentage) {
    if (percentage >= 90) {
      return AppTheme.lightTheme.colorScheme.error;
    } else if (percentage >= 70) {
      return Color(0xFFF59E0B); // Warning color
    } else {
      return Color(0xFF10B981); // Success color
    }
  }
}
