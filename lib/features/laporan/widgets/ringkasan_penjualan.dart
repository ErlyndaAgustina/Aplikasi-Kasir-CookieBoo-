import 'package:flutter/material.dart';

class RingkasanPenjualanCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;

  final String sales;
  final String transaksi;
  final String itemTerjual;

  const RingkasanPenjualanCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.sales,
    required this.transaksi,
    required this.itemTerjual,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8E8E8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF333333),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF888888),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 18),

          const Text(
            "Total Penjualan",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Color(0xFF777777),
            ),
          ),
          const SizedBox(height: 4),

          Text(
            sales,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Color(0xFF333333),
            ),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.receipt_long,
                    size: 18,
                    color: Color(0xFF666666),
                  ),
                  const SizedBox(width: 6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Transaksi",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF777777),
                        ),
                      ),
                      Text(
                        transaksi,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.shopping_bag,
                    size: 18,
                    color: Color(0xFF666666),
                  ),
                  const SizedBox(width: 6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Item Terjual",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF777777),
                        ),
                      ),
                      Text(
                        itemTerjual,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

final List<Map<String, dynamic>> dummyRingkasan = [
  {
    "title": "Harian",
    "subtitle": "Hari Ini",
    "icon": Icons.calendar_today,
    "iconColor": Color(0xFF7ED8C0),
    "sales": "Rp 2.500.000",
    "transaksi": "10",
    "itemTerjual": "45",
  },
  {
    "title": "Mingguan",
    "subtitle": "7 Hari",
    "icon": Icons.calendar_view_week,
    "iconColor": Color(0xFF6CA8FF),
    "sales": "Rp 12.500.000",
    "transaksi": "40",
    "itemTerjual": "100",
  },
  {
    "title": "Bulanan",
    "subtitle": "30 Hari",
    "icon": Icons.calendar_month,
    "iconColor": Color(0xFFF7C873),
    "sales": "Rp 20.000.000",
    "transaksi": "75",
    "itemTerjual": "200",
  },
];
