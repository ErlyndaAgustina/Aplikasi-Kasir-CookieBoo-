import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardChartWidget extends StatefulWidget {
  const DashboardChartWidget({super.key});

  @override
  State<DashboardChartWidget> createState() => _DashboardChartWidgetState();
}

class _DashboardChartWidgetState extends State<DashboardChartWidget> {
  bool isWeekly = true;

  final List<double> weeklyData = [0.8, 1.2, 1.1, 1.4, 1.6, 1.9, 2.3];
  final List<double> monthlyData = [1.6, 1.8, 2.0, 2.2, 2.6, 3.1];

  @override
  Widget build(BuildContext context) {
    final data = isWeekly ? weeklyData : monthlyData;

    final labels = isWeekly
        ? ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min']
        : ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun'];
    final maxY = (data.reduce((a, b) => a > b ? a : b)) + 0.5;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Grafik Penjualan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF5D4037),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Performa Penjualan Bulan Ini',
            style: TextStyle(fontSize: 13, color: Colors.brown.shade600),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF5E6D3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _tabButton(
                  label: 'Mingguan',
                  selected: isWeekly,
                  onTap: () {
                    setState(() => isWeekly = true);
                  },
                ),
                _tabButton(
                  label: 'Bulanan',
                  selected: !isWeekly,
                  onTap: () {
                    setState(() => isWeekly = false);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        if (value % 1 != 0) return const SizedBox();
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(
                            '${value.toInt()}jt',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF8D6E63),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final i = value.toInt();
                        if (i < 0 || i >= labels.length)
                          return const SizedBox();
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(
                            labels[i],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF8D6E63),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(
                  data.length,
                  (i) => BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: data[i],
                        width: 28,
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFBCAAA4),
                            Color(0xFF8D6E63),
                            Color(0xFF5D4037),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: maxY,
                          color: Color(0xFFF5E6D3).withOpacity(0.3),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.trending_up,
                  color: Colors.orange.shade700,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Penjualan meningkat +24%\ndari periode sebelumnya',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.orange.shade800,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabButton({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFD7CCC8) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? const Color(0xFF5D4037) : const Color(0xFF8D6E63),
          ),
        ),
      ),
    );
  }
}
