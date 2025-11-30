import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NonMemberOrders extends StatefulWidget {
  const NonMemberOrders({super.key});

  @override
  State<NonMemberOrders> createState() => _NonMemberOrdersState();
}

class _NonMemberOrdersState extends State<NonMemberOrders> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> nonMemberOrders = [];
  bool isLoading = true;
  late RealtimeChannel channel;

  @override
  void initState() {
    super.initState();
    fetchNonMemberOrders();
    setupRealtime();
  }

  @override
  void dispose() {
    supabase.removeChannel(channel);
    super.dispose();
  }

  void setupRealtime() {
    channel = supabase
        .channel('transaksi_changes')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'transaksi',
          callback: (_) => fetchNonMemberOrders(),
        )
        .subscribe();
  }

  Future<void> fetchNonMemberOrders() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    try {
      final response = await supabase
          .from('transaksi')
          .select('''
            no_antrian,
            tanggal_waktu,
            total_pembayaran,
            pelanggan_id,
            pelanggan:pelanggan_id (nama, membership),
            transaksi_detail(nama_produk, jumlah)
          ''')
          .gte('tanggal_waktu', startOfDay.toIso8601String())
          .lt('tanggal_waktu', endOfDay.toIso8601String())
          .order('tanggal_waktu', ascending: false);

      final List<Map<String, dynamic>> orders = [];

      for (var trx in response) {
        final pelanggan = trx['pelanggan'] as Map<String, dynamic>?;
        final bool isNonMember =
            pelanggan == null ||
            pelanggan['membership'] == null ||
            pelanggan['membership'] == 'non_member';

        if (!isNonMember) continue;

        final details = (trx['transaksi_detail'] as List?) ?? [];
        final items = details
            .map((d) => "${d['nama_produk']} (${d['jumlah']} box)")
            .toList();

        final waktu = DateFormat(
          'HH:mm',
        ).format(DateTime.parse(trx['tanggal_waktu'] as String));

        final totalBayar = (trx['total_pembayaran'] as num?) ?? 0;
        final totalFormatted = NumberFormat.currency(
          locale: 'id_ID',
          symbol: 'Rp ',
          decimalDigits: 0,
        ).format(totalBayar.toInt());

        orders.add({
          'name': pelanggan?['nama'] ?? 'Pelanggan Umum',
          'queueNumber': '# ${trx['no_antrian'] ?? '???'}',
          'time': waktu,
          'items': items.isEmpty ? ['Tidak ada item'] : items,
          'total': totalFormatted,
        });
      }

      if (mounted) {
        setState(() {
          nonMemberOrders = orders;
          isLoading = false;
        });
      }
    } catch (e, s) {
      debugPrint('ERROR NON-MEMBER: $e\n$s');
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              "Memuat pesanan non-member...",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Icon(
              Icons.person_outline,
              size: 25,
              color: Color.fromRGBO(107, 79, 63, 1),
            ),
            const SizedBox(width: 6),
            Text(
              "Pesanan Non-Member (${nonMemberOrders.length})",
              style: const TextStyle(
                fontFamily: 'Poppins',
                color: Color.fromRGBO(107, 79, 63, 1),
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (nonMemberOrders.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Text(
              "Belum ada pesanan non-member hari ini",
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          )
        else
          ...nonMemberOrders.map(
            (order) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: OrderCard(
                name: order['name'],
                queueNumber: order['queueNumber'],
                time: order['time'],
                items: order['items'],
                total: order['total'],
              ),
            ),
          ),
      ],
    );
  }
}

class OrderCard extends StatelessWidget {
  final String name;
  final String queueNumber;
  final String time;
  final List<String> items;
  final String total;

  const OrderCard({
    super.key,
    required this.name,
    required this.queueNumber,
    required this.time,
    required this.items,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color.fromRGBO(171, 199, 239, 0.81),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontFamily: 'Poppins',
              color: Color.fromRGBO(107, 79, 63, 1),
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          Row(
            children: [
              Text(
                queueNumber,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Color.fromRGBO(198, 165, 128, 1),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 7),
              const Text(
                "•",
                style: TextStyle(
                  color: Color.fromRGBO(198, 165, 128, 1),
                  fontSize: 20,
                ),
              ),
              const SizedBox(width: 7),
              Text(
                time,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Color.fromRGBO(198, 165, 128, 1),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.receipt_long,
                color: Color.fromRGBO(217, 160, 91, 1),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Pesanan:",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        color: Color.fromRGBO(217, 160, 91, 1),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ...items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Text(
                          "• $item",
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            color: Color.fromRGBO(198, 165, 128, 1),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(246, 231, 212, 1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Pesanan",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    color: Color.fromRGBO(107, 79, 63, 1),
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  total,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    color: Color.fromRGBO(217, 160, 91, 1),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
