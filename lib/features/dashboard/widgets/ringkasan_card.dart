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
          iconBg: Color.fromRGBO(217, 160, 91, 1),
        ),
        DashboardCard(
          title: "Pendapatan Minggu Ini",
          value: "Rp 9.990.000",
          subtitle: "87 Transaksi",
          growth: "+20% dari minggu lalu",
          icon: Icons.trending_up,
          iconBg: Color.fromRGBO(198, 165, 128, 1),
        ),
        DashboardCard(
          title: "Total Stok Produk",
          value: "247 Box",
          subtitle: "12 Varian Cookies",
          icon: Icons.inventory_2_outlined,
          iconBg: Color.fromRGBO(139, 111, 71, 1),
        ),
        DashboardCard(
          title: "Pelanggan Aktif",
          value: "128",
          subtitle: "Member setia",
          growth: "+5% member baru",
          icon: Icons.people_outline,
          iconBg: Color.fromRGBO(198, 165, 128, 1),
        ),
      ],
    );
  }
}


class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final String? growth;
  final IconData icon;
  final Color iconBg;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    this.growth,
    required this.icon,
    required this.iconBg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.white, Color.fromRGBO(246, 231, 212, 1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.95],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Color.fromRGBO(238, 215, 190, 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
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
                    fontSize: 12,
                    color: Color.fromRGBO(107, 79, 63, 1),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    color: Color.fromRGBO(107, 79, 63, 1),
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: Color.fromRGBO(198, 165, 128, 1),
                  ),
                ),

                if (growth != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.arrow_upward,
                        size: 15,
                        color: Color.fromRGBO(217, 160, 91, 1),
                      ),
                      Text(
                        growth!,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: Color.fromRGBO(217, 160, 91, 1),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
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
              color: iconBg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.white, size: 32),
          ),
        ],
      ),
    );
  }
}
