import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class PnbpChartWidget extends StatefulWidget {
  final List<Map<String, dynamic>> dailyData;
  final List<Map<String, dynamic>> weeklyData;

  const PnbpChartWidget({
    Key? key,
    required this.dailyData,
    required this.weeklyData,
  }) : super(key: key);

  @override
  State<PnbpChartWidget> createState() => _PnbpChartWidgetState();
}

class _PnbpChartWidgetState extends State<PnbpChartWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isDaily = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _isDaily = _tabController.index == 0;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          // Header with Tab Selection
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Transaksi PNBP',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  labelColor: AppTheme.lightTheme.colorScheme.onPrimary,
                  unselectedLabelColor:
                      AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  labelStyle:
                      AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle:
                      AppTheme.lightTheme.textTheme.labelMedium,
                  tabs: [
                    Tab(text: 'Harian'),
                    Tab(text: 'Mingguan'),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Chart
          Container(
            height: 25.h,
            child: Semantics(
              label: "${_isDaily ? 'Daily' : 'Weekly'} PNBP Transaction Chart",
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: _isDaily ? 50000 : 200000,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.2),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final data =
                              _isDaily ? widget.dailyData : widget.weeklyData;
                          if (value.toInt() >= 0 &&
                              value.toInt() < data.length) {
                            return Padding(
                              padding: EdgeInsets.only(top: 1.w),
                              child: Text(
                                (data[value.toInt()]['label'] as String?) ?? '',
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            );
                          }
                          return SizedBox.shrink();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 60,
                        interval: _isDaily ? 100000 : 500000,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            _formatCurrency(value),
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: (_isDaily
                              ? widget.dailyData.length
                              : widget.weeklyData.length)
                          .toDouble() -
                      1,
                  minY: 0,
                  maxY: _getMaxY(),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _getSpots(),
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.lightTheme.colorScheme.primary,
                          AppTheme.lightTheme.colorScheme.tertiary,
                        ],
                      ),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: AppTheme.lightTheme.colorScheme.surface,
                            strokeWidth: 2,
                            strokeColor:
                                AppTheme.lightTheme.colorScheme.primary,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.3),
                            AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((LineBarSpot touchedSpot) {
                          return LineTooltipItem(
                            _formatCurrency(touchedSpot.y),
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.w600,
                                ) ??
                                TextStyle(),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Summary Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                'Total',
                _formatCurrency(_getTotalAmount()),
                AppTheme.lightTheme.colorScheme.primary,
              ),
              _buildStatItem(
                'Rata-rata',
                _formatCurrency(_getAverageAmount()),
                AppTheme.lightTheme.colorScheme.tertiary,
              ),
              _buildStatItem(
                'Tertinggi',
                _formatCurrency(_getMaxAmount()),
                Color(0xFF10B981),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<FlSpot> _getSpots() {
    final data = _isDaily ? widget.dailyData : widget.weeklyData;
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final amount = (item['amount'] as num?)?.toDouble() ?? 0.0;
      return FlSpot(index.toDouble(), amount);
    }).toList();
  }

  double _getMaxY() {
    final data = _isDaily ? widget.dailyData : widget.weeklyData;
    double maxValue = 0;
    for (final item in data) {
      final amount = (item['amount'] as num?)?.toDouble() ?? 0.0;
      if (amount > maxValue) maxValue = amount;
    }
    return maxValue * 1.2; // Add 20% padding
  }

  double _getTotalAmount() {
    final data = _isDaily ? widget.dailyData : widget.weeklyData;
    return data.fold(0.0,
        (sum, item) => sum + ((item['amount'] as num?)?.toDouble() ?? 0.0));
  }

  double _getAverageAmount() {
    final data = _isDaily ? widget.dailyData : widget.weeklyData;
    if (data.isEmpty) return 0.0;
    return _getTotalAmount() / data.length;
  }

  double _getMaxAmount() {
    final data = _isDaily ? widget.dailyData : widget.weeklyData;
    double maxValue = 0;
    for (final item in data) {
      final amount = (item['amount'] as num?)?.toDouble() ?? 0.0;
      if (amount > maxValue) maxValue = amount;
    }
    return maxValue;
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return 'Rp ${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return 'Rp ${(amount / 1000).toStringAsFixed(0)}K';
    } else {
      return 'Rp ${amount.toStringAsFixed(0)}';
    }
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
