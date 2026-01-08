import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StockHistoryCard extends StatelessWidget {
  StockHistoryCard({super.key});

  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchRiwayatStok() async {
    final data = await supabase
        .from('riwayat_stok')
        .select(''' 
        id,
        produk_id,
        kasir_id,
        tipe_perubahan,
        jumlah_perubahan,
        stok_sebelum,
        stok_sesudah,
        keterangan,
        created_at,
        produk:produk_id (nama_produk),
        profile:kasir_id (name)
      ''')
        .order('created_at', ascending: false)
        .limit(10);

    return List<Map<String, dynamic>>.from(data);
  }

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
          FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchRiwayatStok(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'Gagal memuat riwayat stok',
                    style: TextStyle(color: Colors.red),
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'Belum ada riwayat perubahan stok',
                    style: TextStyle(color: Color.fromRGBO(124, 124, 126, 1)),
                  ),
                );
              }

              final riwayatList = snapshot.data!;

              return Column(
                children: riwayatList.asMap().entries.map((entry) {
                  final index = entry.key;
                  final data = entry.value;

                  final produk = data['produk'] as Map<String, dynamic>?;
                  final profile = data['profile'] as Map<String, dynamic>?;

                  final String title =
                      produk?['nama_produk'] ?? 'Produk Tidak Diketahui';

                  final DateTime dateTime = DateTime.parse(data['created_at']);
                  final String date =
                      '${dateTime.day} ${_getMonthName(dateTime.month)} ${dateTime.year}  ⦁  ${dateTime.hour.toString().padLeft(2, '0')}.${dateTime.minute.toString().padLeft(2, '0')}';

                  final String tipe = data['tipe_perubahan'];
                  final int jumlah = data['jumlah_perubahan'];
                  final String keterangan = data['keterangan'] ?? '-';
                  final String admin = profile?['name'] ?? 'Unknown';

                  final bool isMasuk = tipe == 'penambahan';
                  final Color badgeColor = isMasuk
                      ? const Color.fromRGBO(35, 65, 159, 1)
                      : const Color.fromRGBO(212, 24, 61, 1);
                  final IconData badgeIcon = isMasuk
                      ? Icons.north_east
                      : Icons.south_west;
                  final String badgeText = isMasuk
                      ? 'Stok Masuk'
                      : 'Stok Keluar';
                  final String qtyText = '${isMasuk ? '+' : '-'}$jumlah box';
                  final Color qtyColor = badgeColor;

                  final Widget item = _buildItem(
                    title: title,
                    date: date,
                    badgeColor: badgeColor,
                    badgeIcon: badgeIcon,
                    badgeText: badgeText,
                    qtyText: qtyText,
                    qtyColor: qtyColor,
                    desc: keterangan,
                    admin: admin,
                  );

                  // Tambahkan divider kecuali untuk item terakhir
                  if (index < riwayatList.length - 1) {
                    return Column(children: [item, const Divider(height: 32)]);
                  }
                  return item;
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Ags',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return months[month - 1];
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
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: Color.fromRGBO(124, 124, 126, 1),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color.fromRGBO(124, 124, 126, 1),
                        ),
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
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Color.fromRGBO(139, 111, 71, 1),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Admin: $admin',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      color: Color.fromRGBO(133, 131, 145, 1),
                      fontWeight: FontWeight.w500,
                    ),
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
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: badgeColor,
                    ),
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
