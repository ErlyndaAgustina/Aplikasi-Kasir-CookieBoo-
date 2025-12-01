import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../CRUD/detail_pelanggan.dart';
import '../CRUD/edit_pelanggan.dart';

class GoldMemberCard extends StatelessWidget {
  const GoldMemberCard({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(
              Icons.military_tech_rounded,
              size: 28,
              color: Color.fromRGBO(245, 158, 11, 1),
            ),
            SizedBox(width: 5),
            Text(
              "Gold Members",
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Color.fromRGBO(107, 79, 63, 1),
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchGoldMembers(supabase),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              );
            }

            final members = snapshot.data ?? [];

            return Column(
              children: members.map((member) {
                final initials = member['nama']
                    .toString()
                    .split(' ')
                    .where((s) => s.isNotEmpty)
                    .take(2)
                    .map((s) => s[0].toUpperCase())
                    .join();

                final totalTransaksi = member['total_transaksi'] ?? 0;
                final totalBelanja = member['total_belanja'] ?? 0;
                final lastDate = member['last_transaction'] != null
                    ? _formatDate(member['last_transaction'])
                    : 'Belum ada transaksi';

                return Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color.fromRGBO(254, 243, 199, 1),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(245, 158, 11, 1),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                initials,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    member['nama'] ?? 'Tanpa Nama',
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Color.fromRGBO(107, 79, 63, 1),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                        254,
                                        243,
                                        199,
                                        1,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: const Color.fromRGBO(
                                          245,
                                          158,
                                          11,
                                          1,
                                        ),
                                        width: 1,
                                      ),
                                    ),
                                    child: const Text(
                                      'Gold',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Color.fromRGBO(162, 79, 37, 1),
                                        fontWeight: FontWeight.w900,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        Row(
                          children: [
                            const Icon(
                              Icons.email_outlined,
                              size: 18,
                              color: Color.fromRGBO(107, 79, 63, 1),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              member['email'] ?? '-',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                color: Color.fromRGBO(217, 160, 91, 1),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 5),

                        Row(
                          children: [
                            const Icon(
                              Icons.phone_outlined,
                              size: 18,
                              color: Color.fromRGBO(107, 79, 63, 1),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              member['nomor_tlpn'] ?? '-',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                color: Color.fromRGBO(217, 160, 91, 1),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(246, 231, 212, 1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Total Transaksi",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Color.fromRGBO(107, 79, 63, 1),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${totalTransaksi}x",
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Color.fromRGBO(217, 160, 91, 1),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 40),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Total Belanja",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Color.fromRGBO(107, 79, 63, 1),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Rp ${_formatRupiah(totalBelanja)}",
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Color.fromRGBO(198, 165, 128, 1),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_month,
                              size: 18,
                              color: Color.fromRGBO(107, 79, 63, 1),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "Terakhir: $lastDate",
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                color: Color.fromRGBO(217, 160, 91, 1),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => showDialog(
                                  context: context,
                                  builder: (_) => DetailPelangganPopup(
                                    pelangganId: member['id'],
                                  ),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color.fromRGBO(
                                      249,
                                      216,
                                      208,
                                      1,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.remove_red_eye_outlined,
                                        size: 20,
                                        color: Color.fromRGBO(107, 79, 63, 1),
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        "Detail",
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: Color.fromRGBO(107, 79, 63, 1),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) =>
                                      EditPelangganPopup(data: member),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color.fromRGBO(
                                      246,
                                      231,
                                      212,
                                      1,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.edit_note_rounded,
                                        size: 20,
                                        color: Color.fromRGBO(107, 79, 63, 1),
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        "Edit",
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: Color.fromRGBO(107, 79, 63, 1),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Future<List<Map<String, dynamic>>> _fetchGoldMembers(
    SupabaseClient client,
  ) async {
    try {
      final pelangganResp = await client
          .from('pelanggan')
          .select('id, nama, email, nomor_tlpn, alamat, membership')
          .eq('membership', 'gold')
          .order('nama');

      final List<Map<String, dynamic>> result = [];

      for (final p in pelangganResp) {
        final transaksi = await client
            .from('transaksi')
            .select('total_pembayaran, tanggal_waktu')
            .eq('pelanggan_id', p['id']);

        final count = transaksi.length;
        final totalBelanja = transaksi
            .fold<double>(
              0,
              (sum, t) => sum + ((t['total_pembayaran'] as double?) ?? 0),
            )
            .toInt();

        final lastDate = transaksi.isNotEmpty
            ? transaksi.first['tanggal_waktu'] as String?
            : null;

        result.add({
          ...p,
          'total_transaksi': count,
          'total_belanja': totalBelanja,
          'last_transaction': lastDate,
        });
      }

      return result;
    } catch (e) {
      debugPrint('Error fetch gold members: $e');
      return [];
    }
  }

  String _formatDate(String? iso) {
    if (iso == null) return 'Belum ada transaksi';
    final date = DateTime.tryParse(iso);
    if (date == null) return iso;
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return "${date.day} ${months[date.month - 1]} ${date.year}";
  }

  String _formatRupiah(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m.group(0)}.',
    );
  }
}
