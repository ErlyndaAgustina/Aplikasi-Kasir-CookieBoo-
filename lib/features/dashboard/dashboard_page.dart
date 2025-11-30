import 'package:flutter/material.dart';
import '../dashboard/widgets/dashboard_header.dart';
import '../dashboard/widgets/ringkasan_card.dart';
import '../dashboard/widgets/dashboard_grafik.dart';
import '../dashboard/widgets/recent_transactions.dart';

class DashboardPage extends StatefulWidget {
  final VoidCallback onMenuTap;

  const DashboardPage({super.key, required this.onMenuTap});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(246, 231, 212, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DashboardHeader(onMenuTap: widget.onMenuTap),
              const SizedBox(height: 12),
              RingkasanCard(),
              const SizedBox(height: 15),
              DashboardChartWidget(),
              const SizedBox(height: 30),
              RecentTransactionsCard()
            ],
          ),
        ),
      ),
    );
  }
}
