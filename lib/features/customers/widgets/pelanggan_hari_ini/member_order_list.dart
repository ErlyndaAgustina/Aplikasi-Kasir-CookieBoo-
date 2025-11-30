import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../pelanggan_hari_ini/member_order_card.dart';

class MemberOrderList extends StatefulWidget {
  const MemberOrderList({super.key});

  @override
  State<MemberOrderList> createState() => _MemberOrderListState();
}

class _MemberOrderListState extends State<MemberOrderList> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> memberOrders = [];
  bool isLoading = true;
  late RealtimeChannel channel;

  @override
  void initState() {
    super.initState();
    fetchInitialData();
    setupRealtime();
  }

  @override
  void dispose() {
    channel.unsubscribe();
    super.dispose();
  }

  Future<void> fetchInitialData() async {
    await _fetchMemberOrders();
    if (mounted) setState(() => isLoading = false);
  }

  void setupRealtime() {
    channel = supabase
        .channel('public:transaksi')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'transaksi',
          callback: (payload) {
            debugPrint('Transaksi baru masuk! ID: ${payload.newRecord['id']}');
            _fetchMemberOrders();
          },
        )
        .subscribe();
  }

  Future<void> _fetchMemberOrders() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    try {
      final response = await supabase
          .from('transaksi')
          .select('''
            id, no_antrian, tanggal_waktu, total_pembayaran, pelanggan_id,
            transaksi_detail(nama_produk, jumlah)
          ''')
          .gte('tanggal_waktu', startOfDay.toIso8601String())
          .lt('tanggal_waktu', endOfDay.toIso8601String())
          .order('tanggal_waktu', ascending: false);

      final pelangganResponse = await supabase
          .from('pelanggan')
          .select('id, nama, membership, diskon_persen')
          .inFilter('membership', ['platinum', 'gold', 'silver']);

      final Map<String, Map> memberMap = {
        for (var p in pelangganResponse) p['id']: p,
      };

      final List<Map<String, dynamic>> orders = [];

      for (var trx in response) {
        final pelangganId = trx['pelanggan_id'] as String?;
        if (pelangganId == null) continue;

        final memberData = memberMap[pelangganId];
        if (memberData == null) continue;

        final details = trx['transaksi_detail'] as List? ?? [];
        final items = details
            .map((d) => "${d['nama_produk']} (${d['jumlah']} box)")
            .toList();

        final waktu = DateFormat(
          'HH:mm',
        ).format(DateTime.parse(trx['tanggal_waktu'] as String));

        final membership = (memberData['membership'] as String).toLowerCase();
        final tier = membership == 'platinum'
            ? 'Platinum'
            : membership == 'gold'
            ? 'Gold'
            : 'Silver';

        final diskonPersen = (memberData['diskon_persen'] as num? ?? 0).toInt();
        final totalBayar = (trx['total_pembayaran'] as num? ?? 0).toDouble();
        final subtotal = diskonPersen > 0
            ? (totalBayar / (1 - diskonPersen / 100)).round()
            : totalBayar.round();

        orders.add({
          'nama': memberData['nama'],
          'initials': _initials(memberData['nama']),
          'tier': tier,
          'queueNumber': trx['no_antrian'] ?? 'M??',
          'time': waktu,
          'items': items,
          'subtotal': subtotal,
          'discountPercent': diskonPersen,
          'avatarColor': _color(tier),
        });
      }

      if (mounted) {
        setState(() {
          memberOrders = orders;
        });
      }

      print("Real-time update → ${orders.length} pesanan member hari ini");
    } catch (e) {
      debugPrint('Error real-time fetch: $e');
    }
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  Color _color(String tier) {
    switch (tier.toLowerCase()) {
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
    if (isLoading) {
      return const Center(
        child: Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              "Memuat pesanan member...",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    if (memberOrders.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(Icons.card_membership, size: 60, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              "Belum ada pesanan member hari ini 👑",
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            const SizedBox(height: 12),
            Text(
              "👑 Pesanan Member (${memberOrders.length})",
              style: const TextStyle(
                fontFamily: 'Poppins',
                color: Color.fromRGBO(107, 79, 63, 1),
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
            ),
          ],
        ),
        Text(
          "Total: ${memberOrders.length} pesanan • Update otomatis",
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
        const SizedBox(height: 5),
        ...memberOrders
            .map(
              (order) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: MemberOrderCard(
                  initials: order['initials'],
                  avatarColor: order['avatarColor'],
                  name: order['nama'],
                  tier: order['tier'],
                  queueNumber: order['queueNumber'],
                  time: order['time'],
                  items: order['items'],
                  subtotal: order['subtotal'],
                  discountPercent: order['discountPercent'],
                ),
              ),
            )
            .toList(),
      ],
    );
  }
}
