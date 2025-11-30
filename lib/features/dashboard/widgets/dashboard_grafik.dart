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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Grafik Penjualan',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Color.fromRGBO(107, 79, 63, 1),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Performa Penjualan Bulan Ini',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              color: Color.fromRGBO(198, 165, 128, 1),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(246, 231, 212, 1),
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
                const SizedBox(width: 5),
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
          const SizedBox(height: 20),
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
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: Color.fromRGBO(139, 111, 71, 1),
                              fontWeight: FontWeight.w700,
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
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: Color.fromRGBO(217, 160, 91, 1),
                              fontWeight: FontWeight.w700,
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
                            Color.fromRGBO(246, 231, 212, 1),
                            Color.fromRGBO(249, 216, 208, 1),
                            Color.fromRGBO(255, 227, 191, 1),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(246, 231, 212, 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.trending_up,
                  color: Color.fromRGBO(217, 160, 91, 1),
                  size: 20,
                ),
                const SizedBox(width: 8),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      color: Color.fromRGBO(107, 79, 63, 1),
                      fontWeight: FontWeight.w500,
                    ),
                    children: const [
                      TextSpan(text: 'Penjualan meningkat '),
                      TextSpan(
                        text: '+24%',
                        style: TextStyle(
                          color: Color.fromRGBO(217, 160, 91, 1),
                        ),
                      ),
                      TextSpan(text: '\ndari periode sebelumnya'),
                    ],
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
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? const Color.fromRGBO(217, 160, 91, 1): Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : Colors.black
          ),
        ),
      ),
    );
  }
}
