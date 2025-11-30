import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PesananHariIniCard extends StatefulWidget {
  const PesananHariIniCard({super.key});

  @override
  State<PesananHariIniCard> createState() => _PesananHariIniCardState();
}

class _PesananHariIniCardState extends State<PesananHariIniCard> {
  final supabase = Supabase.instance.client;

  int totalPelanggan = 0;
  int totalItem = 0;
  double totalRevenue = 0;

  @override
  void initState() {
    super.initState();
    fetchPesananHariIni();
  }

  Future<void> fetchPesananHariIni() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    try {
      final response = await supabase
          .from('transaksi')
          .select('''
          total_pembayaran,
          pelanggan_id,
          transaksi_detail(jumlah)
        ''')
          .gte(
            'tanggal_waktu',
            '${today.toIso8601String().substring(0, 10)} 00:00:00',
          )
          .lt(
            'tanggal_waktu',
            '${today.add(Duration(days: 1)).toIso8601String().substring(0, 10)} 00:00:00',
          )
          .order('tanggal_waktu', ascending: false);

      print(
        "DEBUG: Jumlah transaksi hari ini: ${response.length}",
      );

      int pelangganCount = 0;
      int itemCount = 0;
      double revenue = 0.0;
      final Set<String> uniquePelanggan = {};

      for (var t in response) {
        final pelangganId = t['pelanggan_id'] as String?;
        if (pelangganId != null) uniquePelanggan.add(pelangganId);

        final totalBayar = t['total_pembayaran'] as num?;
        if (totalBayar != null) revenue += totalBayar.toDouble();

        final details = t['transaksi_detail'] as List? ?? [];
        for (var d in details) {
          final jml = d['jumlah'] as num?;
          if (jml != null) itemCount += jml.toInt();
        }
      }

      pelangganCount = uniquePelanggan.length;

      print(
        "DEBUG → Pelanggan: $pelangganCount, Item: $itemCount, Revenue: $revenue",
      );

      setState(() {
        totalPelanggan = pelangganCount;
        totalItem = itemCount;
        totalRevenue = revenue;
      });
    } catch (e, s) {
      print('ERROR FETCH: $e');
      print(s);
      setState(() {
        totalPelanggan = 999;
        totalItem = 999;
        totalRevenue = 999;
      });
    }
  }

  String _formatRevenue(double amount) {
    if (amount >= 1e6) {
      final juta = amount / 1e6;
      if (juta % 1 == 0) {
        return "${juta.toInt()} jt";
      } else {
        return "${juta.toStringAsFixed(1)} jt";
      }
    } else if (amount >= 1e3) {
      return "${(amount / 1e3).toStringAsFixed(0)} rb";
    }
    return amount.toInt().toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.white, Color.fromRGBO(238, 215, 190, 1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.80],
        ),
        borderRadius: BorderRadius.all(Radius.circular(22)),
        border: Border.all(color: Color.fromRGBO(238, 215, 190, 1), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.22),
            blurRadius: 5,
            offset: const Offset(6, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(198, 165, 128, 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.calendar_month,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pesanan Hari Ini",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: const Color.fromRGBO(107, 79, 63, 1),
                    ),
                  ),
                  Text(
                    "${DateTime.now().day} ${_monthName(DateTime.now().month)} ${DateTime.now().year}",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Color.fromRGBO(198, 165, 128, 1),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.people_outline,
                  value: totalPelanggan.toString().padLeft(2, '0'),
                  label: "Pelanggan",
                  color: const Color.fromRGBO(107, 79, 63, 1),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.shopping_bag_outlined,
                  value: totalItem.toString(),
                  label: "Item",
                  color: const Color.fromRGBO(107, 79, 63, 1),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.account_balance_wallet_rounded,
                  value: _formatRevenue(totalRevenue),
                  label: "Revenue",
                  color: const Color.fromRGBO(107, 79, 63, 1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const names = [
      "",
      "Januari",
      "Februari",
      "Maret",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember",
    ];
    return names[month];
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Color.fromRGBO(198, 165, 128, 0.71),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 30, color: color),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(217, 160, 91, 1),
              height: 1,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15,
              color: Color.fromRGBO(198, 165, 128, 1),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
