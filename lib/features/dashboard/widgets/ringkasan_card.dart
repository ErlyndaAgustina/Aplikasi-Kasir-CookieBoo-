import 'package:flutter/material.dart';

class RingkasanCard extends StatelessWidget {
  const RingkasanCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        DashboardCard(
          title: "Total Penjualan Hari Ini",
          value: "Rp 1.250.000",
          subtitle: "15 Transaksi",
          growth: "+18% dari kemarin",
          icon: Icons.cookie_outlined,
        ),
        DashboardCard(
          title: "Pendapatan Minggu Ini",
          value: "Rp 9.990.000",
          subtitle: "87 Transaksi",
          growth: "+20% dari minggu lalu",
          icon: Icons.trending_up,
        ),
        DashboardCard(
          title: "Total Stok Produk",
          value: "247 Box",
          subtitle: "12 Varian Cookies",
          icon: Icons.inventory_2_outlined,
        ),
        DashboardCard(
          title: "Pelanggan Aktif",
          value: "128",
          subtitle: "Member setia",
          growth: "+5% member baru",
          icon: Icons.people_outline,
        ),
      ],
    );
  }
}

/* ----------------------------------------------------------
   REUSABLE COMPONENT — Dashboard Card
----------------------------------------------------------- */

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final String? growth;
  final IconData icon;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    this.growth,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    color: Color(0xFF7D6653),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 22,
                    color: Color(0xFF4B3426),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    color: Color(0xFF7D6653),
                  ),
                ),

                if (growth != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.arrow_upward,
                        size: 16,
                        color: Color(0xFF34A853),
                      ),
                      Text(
                        growth!,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: Color(0xFF34A853),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF3D9B0),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: const Color(0xFF7D6653), size: 32),
          ),
        ],
      ),
    );
  }
}
