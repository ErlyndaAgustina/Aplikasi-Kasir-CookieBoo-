import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../CRUD/detail_pelanggan.dart';
import '../CRUD/edit_pelanggan.dart';

class PlatinumMemberCard extends StatelessWidget {
  const PlatinumMemberCard({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(
              Icons.workspace_premium,
              size: 28,
              color: Color.fromRGBO(62, 129, 237, 1),
            ),
            SizedBox(width: 5),
            Text(
              "Platinum Members",
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
          future: _fetchPlatinumMembers(supabase),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              );
            }

            final members = snapshot.data ?? [];

            final _ = members.length.toString().padLeft(2, '0');

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
                final lastTransaction = member['last_transaction'] != null
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
                        color: const Color.fromRGBO(185, 202, 254, 1),
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
                                color: Color.fromRGBO(62, 129, 237, 1),
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
                                        219,
                                        234,
                                        254,
                                        1,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: const Color.fromRGBO(
                                          59,
                                          130,
                                          246,
                                          1,
                                        ),
                                        width: 1,
                                      ),
                                    ),
                                    child: const Text(
                                      'Platinum',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Color.fromRGBO(35, 65, 159, 1),
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
                              "Terakhir: $lastTransaction",
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

  Future<List<Map<String, dynamic>>> _fetchPlatinumMembers(
    SupabaseClient client,
  ) async {
    try {
      final pelangganResponse = await client
          .from('pelanggan')
          .select('id, nama, email, nomor_tlpn, alamat, membership')
          .eq('membership', 'platinum')
          .order('nama');

      final List<Map<String, dynamic>> result = [];

      for (final pelanggan in pelangganResponse) {
        final transaksiStats = await client
            .from('transaksi')
            .select('total_pembayaran, tanggal_waktu')
            .eq('pelanggan_id', pelanggan['id'])
            .order('tanggal_waktu', ascending: false);

        final count = transaksiStats.length;
        final totalBelanja = transaksiStats
            .fold<double>(
              0,
              (sum, t) => sum + ((t['total_pembayaran'] as double?) ?? 0),
            )
            .toInt();

        final lastDate = transaksiStats.isNotEmpty
            ? transaksiStats.first['tanggal_waktu'] as String?
            : null;

        result.add({
          ...pelanggan,
          'total_transaksi': count,
          'total_belanja': totalBelanja,
          'last_transaction': lastDate,
        });
      }

      return result;
    } catch (e) {
      debugPrint('Error fetch platinum: $e');
      return [];
    }
  }

  String _formatDate(String? isoDate) {
    if (isoDate == null) return 'Belum ada transaksi';
    final date = DateTime.tryParse(isoDate);
    if (date == null) return isoDate;
    return "${date.day} ${_getMonthName(date.month)} ${date.year}";
  }

  String _getMonthName(int month) {
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
    return months[month - 1];
  }

  String _formatRupiah(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m.group(0)}.',
    );
  }
}
