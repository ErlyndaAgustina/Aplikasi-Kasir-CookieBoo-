import 'package:flutter/material.dart';
import '../laporan/widgets/laporan_header.dart';
import '../laporan/widgets/filter_laporan.dart';
import '../laporan/widgets/ringkasan_penjualan.dart';
import '../laporan/widgets/detail_transaksi.dart';
import '../laporan/widgets/export_section.dart';

DateTime _parseTanggal(String tgl) {
  const months = {
    "Jan": 1,
    "Feb": 2,
    "Mar": 3,
    "Apr": 4,
    "Mei": 5,
    "Jun": 6,
    "Jul": 7,
    "Agu": 8,
    "Sep": 9,
    "Okt": 10,
    "Nov": 11,
    "Des": 12,
  };

  final parts = tgl.split(" ");
  final day = int.parse(parts[0]);
  final month = months[parts[1]]!;
  final year = int.parse(parts[2]);

  return DateTime(year, month, day);
}

class LaporanPage extends StatefulWidget {
  final VoidCallback onMenuTap;
  const LaporanPage({super.key, required this.onMenuTap});

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  late List<Map<String, dynamic>> _displayedTransactions = List.from(
    dummyTransactions,
  );

  void _applyFilter(FilterData filter) {
    setState(() {
      _displayedTransactions = dummyTransactions.where((trx) {
        final trxDate = _parseTanggal(trx["date"]);
        if (filter.dariTanggal != null && filter.sampaiTanggal != null) {
          if (trxDate.isBefore(filter.dariTanggal!) ||
              trxDate.isAfter(filter.sampaiTanggal!)) {
            return false;
          }
        }
        if (filter.tipeFilter == "Produk" && filter.produk != "Semua Produk") {
          final items = trx["items"] as List;
          if (!items.any((item) => item["name"] == filter.produk)) {
            return false;
          }
        }

        if (filter.tipeFilter == "Membership" &&
            filter.pelangganMembership != "Semua Pelanggan") {
          if (trx["customer"] != filter.pelangganMembership) return false;
        }

        return true;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(246, 231, 212, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LaporanHeader(onMenuTap: widget.onMenuTap),
              const SizedBox(height: 18),
              ExportSection(),
              const SizedBox(height: 18),
              FilterLaporanCard(onFilterApplied: _applyFilter),
              const SizedBox(height: 24),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Ringkasan Penjualan",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF4A2C0D),
                    ),
                  ),
                  const SizedBox(height: 16),

                  ...dummyRingkasan.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: RingkasanPenjualanCard(
                        title: item['title'] as String,
                        subtitle: item['subtitle'] as String,
                        icon: item['icon'] as IconData,
                        iconColor: item['iconColor'] as Color,
                        sales: item['sales'] as String,
                        transaksi: item['transaksi'] as String,
                        itemTerjual: item['itemTerjual'] as String,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Detail Penjualan",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF4A2C0D),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TransactionHistoryList(
                        transactions: _displayedTransactions,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
