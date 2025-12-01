import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailPelangganPopup extends StatelessWidget {
  final String pelangganId;

  DetailPelangganPopup({super.key, required this.pelangganId});

  final supabase = Supabase.instance.client;

  Color getMembershipColor(String? membership) {
    switch (membership?.toLowerCase()) {
      case 'platinum':
        return const Color.fromRGBO(62, 129, 237, 1);
      case 'gold':
        return const Color.fromRGBO(245, 158, 11, 1);
      case 'silver':
        return const Color.fromRGBO(100, 116, 139, 1);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: size.height * 0.95,
          maxWidth: size.width * 0.95,
        ),
        child: FutureBuilder<Map<String, dynamic>>(
          future: _fetchPelangganDetail(pelangganId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError || !snapshot.hasData) {
              return _buildErrorState(context);
            }

            final data = snapshot.data!;
            final stats = data['stats'] as Map<String, dynamic>;
            final riwayat = data['riwayat'] as List<Map<String, dynamic>>;

            return Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        _buildHeader(context),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildCustomerCard(data),
                                  const SizedBox(height: 15),
                                  _buildStatsRow(stats),
                                  const SizedBox(height: 15),
                                  const Text(
                                    "Riwayat Pembelian",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Color.fromRGBO(107, 79, 63, 1),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  ..._buildHistoryList(riwayat),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Hapus Pelanggan?"),
                          content: const Text("Data akan dihapus permanen."),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text("Batal"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text(
                                "Hapus",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        await supabase
                            .from('pelanggan')
                            .delete()
                            .eq('id', pelangganId);

                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Pelanggan berhasil dihapus"),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      }
                    },
                    child: const Text(
                      "Hapus Pelanggan",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> _fetchPelangganDetail(String id) async {
    final pelanggan = await supabase
        .from('pelanggan')
        .select()
        .eq('id', id)
        .single();

    final transaksiResp = await supabase
        .from('transaksi')
        .select('*, transaksi_detail(nama_produk, jumlah, subtotal)')
        .eq('pelanggan_id', id)
        .order('tanggal_waktu', ascending: false);

    final totalTransaksi = transaksiResp.length;

    final totalBelanja = transaksiResp.fold<double>(
      0,
      (sum, t) => sum + ((t['total_pembayaran'] as num?) ?? 0),
    );

    final rataRata = totalTransaksi > 0 ? totalBelanja / totalTransaksi : 0.0;

    final formattedRiwayat = transaksiResp.map((trx) {
      final List details = (trx['transaksi_detail'] as List?) ?? [];

      return {
        'id':
            trx['no_transaksi'] ??
            "TRX-${(trx['id'] as String).replaceAll('-', '').substring(0, 8)}",
        'tanggal': DateTime.parse(trx['tanggal_waktu']),
        'metode': trx['metode_pembayaran'] == 'cash' ? 'Cash' : 'Non-Cash',
        'items': details
            .map(
              (d) => {
                'nama': d['nama_produk'] ?? 'Produk Tidak Diketahui',
                'qty': d['jumlah'] ?? 0,
              },
            )
            .toList(),
        'total': trx['total_pembayaran'] ?? 0,
        'status': 'Selesai',
      };
    }).toList();

    final stats = {
      'total_transaksi': totalTransaksi.toString(),
      'total_belanja':
          NumberFormat.currency(
            locale: 'id_ID',
            symbol: '',
            decimalDigits: 0,
          ).format(totalBelanja.round()) +
          'k',
      'rata_rata':
          NumberFormat.currency(
            locale: 'id_ID',
            symbol: '',
            decimalDigits: 0,
          ).format(rataRata.round()) +
          'k',
    };

    return {
      'pelanggan': pelanggan,
      'stats': stats,
      'riwayat': formattedRiwayat,
    };
  }

  Widget _buildErrorState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            "Gagal memuat data pelanggan",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tutup"),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(217, 160, 91, 1),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              "Detail Pelanggan",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          InkWell(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.close, color: Colors.white, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerCard(Map<String, dynamic> data) {
    final pelanggan = data['pelanggan'] as Map<String, dynamic>;

    final initials = pelanggan['nama']
        .toString()
        .split(' ')
        .where((s) => s.isNotEmpty)
        .take(2)
        .map((s) => s[0].toUpperCase())
        .join();

    final joinedDate = pelanggan['created_at'] != null
        ? DateFormat(
            'dd MMMM yyyy',
          ).format(DateTime.parse(pelanggan['created_at']))
        : "Belum diketahui";

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(246, 231, 212, 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: getMembershipColor(pelanggan['membership']),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pelanggan['nama'] ?? "Tanpa Nama",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color.fromRGBO(107, 79, 63, 1),
                  ),
                ),
                const SizedBox(height: 6),
                _buildTierBadge(pelanggan['membership'] ?? "non_member"),
                const SizedBox(height: 14),
                _infoRow(Icons.email, pelanggan['email'] ?? "-"),
                _infoRow(Icons.phone, pelanggan['nomor_tlpn'] ?? "-"),
                _infoRow(Icons.location_on, pelanggan['alamat'] ?? "-"),
                _infoRow(Icons.calendar_today, "Bergabung: $joinedDate"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTierBadge(String tier) {
    final t = tier.toLowerCase();

    if (t == "platinum") {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(219, 234, 254, 1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Color.fromRGBO(59, 130, 246, 1), width: 1),
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
      );
    }

    if (t == "gold") {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(254, 243, 199, 1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color.fromRGBO(245, 158, 11, 1),
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
      );
    }

    if (t == "silver") {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(241, 245, 249, 1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Color.fromRGBO(100, 116, 139, 1), width: 1),
        ),
        child: const Text(
          'Silver',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Color.fromRGBO(100, 116, 139, 1),
            fontWeight: FontWeight.w900,
            fontSize: 12,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(229, 231, 235, 1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color.fromRGBO(156, 163, 175, 1),
          width: 1,
        ),
      ),
      child: const Text(
        'Non Member',
        style: TextStyle(
          fontFamily: 'Poppins',
          color: Color.fromRGBO(75, 85, 99, 1),
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Color.fromRGBO(107, 79, 63, 1)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: Color.fromRGBO(217, 160, 91, 1),
                fontWeight: FontWeight.w700,
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(Map<String, dynamic> stats) {
    return Row(
      children: [
        _statCard(
          stats['total_transaksi'],
          "Transaksi",
          Icons.inventory_2,
          iconColor: const Color.fromRGBO(62, 132, 246, 1),
        ),
        const SizedBox(width: 10),
        _statCard(
          stats['total_belanja'],
          "Total",
          Icons.payments,
          iconColor: const Color.fromRGBO(16, 185, 129, 1),
        ),
        const SizedBox(width: 10),
        _statCard(
          stats['rata_rata'],
          "Rata-rata",
          Icons.show_chart,
          iconColor: const Color.fromRGBO(245, 158, 11, 1),
        ),
      ],
    );
  }

  Widget _statCard(
    String value,
    String label,
    IconData icon, {
    Color iconColor = Colors.brown,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Color.fromRGBO(249, 216, 208, 1), width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, size: 22, color: iconColor),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: Color.fromRGBO(133, 131, 145, 1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildHistoryList(List<Map<String, dynamic>> riwayat) {
    return riwayat.map((trx) {
      final items = trx['items'] as List<Map<String, dynamic>>;

      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(246, 231, 212, 1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...items.map(
              (p) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "${p['nama']} (${p['qty']}x)",
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(107, 79, 63, 1),
                        ),
                      ),
                    ),
                    Text(
                      NumberFormat.currency(
                        locale: 'id_ID',
                        symbol: 'Rp ',
                        decimalDigits: 0,
                      ).format(trx['total']),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        color: Color.fromRGBO(107, 79, 63, 1),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              DateFormat('dd MMM yyyy, HH:mm').format(trx['tanggal']),
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: Color.fromRGBO(133, 131, 145, 1),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
