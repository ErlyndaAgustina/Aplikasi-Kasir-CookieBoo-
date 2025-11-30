import 'package:flutter/material.dart';

class StockHistoryCard extends StatelessWidget {
  const StockHistoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.history, color: Color.fromRGBO(139, 111, 71, 1)),
              const SizedBox(width: 8),
              const Text(
                'Riwayat Perubahan Stok',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color.fromRGBO(139, 111, 71, 1),
                ),
              ),
            ],
          ),
          Divider(color: Color.fromRGBO(255, 227, 191, 1), thickness: 1.5),
          const SizedBox(height: 8),
          _buildItem(
            title: 'Choco Chip Cookies',
            date: '18 Okt 2025  ⦁  09.00',
            badgeColor: Color.fromRGBO(35, 65, 159, 1),
            badgeIcon: Icons.north_east,
            badgeText: 'Stok Masuk',
            qtyText: '+20 box',
            qtyColor: Color.fromRGBO(35, 65, 159, 1),
            desc: 'Restock dari dapur',
            admin: 'Erlynda Agustina',
          ),
          const Divider(height: 32),
          _buildItem(
            title: 'Monster Cookies',
            date: '18 Okt 2025  ⦁  09.30',
            badgeColor: Color.fromRGBO(212, 24, 61, 1),
            badgeIcon: Icons.south_west,
            badgeText: 'Stok Keluar',
            qtyText: '-20 box',
            qtyColor: Color.fromRGBO(212, 24, 61, 1),
            desc: 'Penjualan ke Ajeng (Member Platinum)',
            admin: 'Kasir Hanzel Frey',
          ),
          const Divider(height: 32),
          _buildItem(
            title: 'Choco Marsmellow',
            date: '18 Okt 2025  ⦁  10.30',
            badgeColor: Color.fromRGBO(212, 24, 61, 1),
            badgeIcon: Icons.south_west,
            badgeText: 'Stok Keluar',
            qtyText: '-20 box',
            qtyColor: Color.fromRGBO(212, 24, 61, 1),
            desc: 'Produk rusak/kadaluarsa',
            admin: 'Erlynda Agustina',
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required String title,
    required String date,
    required Color badgeColor,
    required IconData badgeIcon,
    required String badgeText,
    required String qtyText,
    required Color qtyColor,
    required String desc,
    required String admin,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color.fromRGBO(107, 79, 63, 1),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16, color: Color.fromRGBO(124, 124, 126, 1)),
                      const SizedBox(width: 4),
                      Text(
                        date,
                        style: const TextStyle(fontSize: 13, color: Color.fromRGBO(124, 124, 126, 1)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    qtyText,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: qtyColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color.fromRGBO(139, 111, 71, 1), fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Admin: $admin',
                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color.fromRGBO(133, 131, 145, 1), fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: badgeColor.withOpacity(0.10),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: badgeColor, width: 1),
              ),
              child: Row(
                children: [
                  Icon(badgeIcon, size: 14, color: badgeColor),
                  const SizedBox(width: 4),
                  Text(
                    badgeText,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: badgeColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
