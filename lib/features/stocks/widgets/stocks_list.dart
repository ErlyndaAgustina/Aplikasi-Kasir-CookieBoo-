import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/stock_item.dart'; // pastikan path sesuai

class StockList extends StatefulWidget {
  final String? query;
  final String? category;

  const StockList({
    super.key,
    this.query,
    this.category,
  });

  @override
  State<StockList> createState() => _StockListState();
}

class _StockListState extends State<StockList> {
  final _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _products = [];
  bool _loading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _subscribeToRealtimeChanges();
  }

  void _subscribeToRealtimeChanges() {
    _supabase
        .channel('produk_stock_changes')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'produk',
          callback: (payload) {
            // Setiap ada perubahan, fetch ulang data
            _fetchProducts();
          },
        )
        .subscribe();
  }

  Future<void> _fetchProducts() async {
    try {
      final response = await _supabase
          .from('produk')
          .select('id, nama_produk, stok, stok_minimum, kategori')
          .order('nama_produk');

      if (mounted) {
        setState(() {
          _products = List<Map<String, dynamic>>.from(response);
          _loading = false;
          _errorMessage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _loading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _supabase.removeChannel(
      _supabase.channel('produk_stock_changes'),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Gagal memuat data: $_errorMessage"),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchProducts,
              child: const Text("Coba lagi"),
            ),
          ],
        ),
      );
    }

    final q = (widget.query ?? "").toLowerCase();
    final c = widget.category ?? "Semua Kategori";

    final sourceData = _products.map((p) {
      return {
        "id": p['id'].toString(),
        "name": p['nama_produk'] ?? "",
        "stock": p['stok'] ?? 0,
        "min": p['stok_minimum'] ?? 10,
        "cat": p['kategori'] ?? "Tanpa Kategori",
      };
    }).toList();

    final filtered = sourceData.where((item) {
      final matchQuery = item["name"].toString().toLowerCase().contains(q);
      final matchCategory = c == "Semua Kategori" || item["cat"] == c;
      return matchQuery && matchCategory;
    }).toList();

    if (filtered.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(
            "Tidak ada produk ditemukan",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return Column(
      children: filtered.map((e) {
        return StockItem(
          productId: e["id"],
          name: e["name"],
          stock: e["stock"],
          minStock: e["min"],
          category: e["cat"],
        );
      }).toList(),
    );
  }
}