import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../stocks/widgets/stocks_header.dart';
import '../stocks/widgets/stoks_filter.dart';
import '../stocks/widgets/stocks_list.dart';
import '../stocks/widgets/stocks_history.dart';

class StocksPage extends StatefulWidget {
  final VoidCallback onMenuTap;
  const StocksPage({super.key, required this.onMenuTap});

  @override
  State<StocksPage> createState() => _StocksPageState();
}

class _StocksPageState extends State<StocksPage> {
  String selectedCategory = 'Semua Kategori';
  String query = "";
  int _lowStockCount = 0;
  
  @override
  void initState() {
    super.initState();
    _fetchLowStockCount();
    _subscribeToRealtimeChanges();
  }

  Future<void> _fetchLowStockCount() async {
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase
          .from('produk')
          .select()
          .eq('status_stok', 'Habis')
          .count(CountOption.exact);
      
      if (mounted) {
        setState(() {
          _lowStockCount = response.count;
        });
      }
    } catch (e) {
      print('Error fetching low stock count: $e');
    }
  }

  void _subscribeToRealtimeChanges() {
    final supabase = Supabase.instance.client;
    
    supabase
        .channel('produk_changes')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'produk',
          callback: (payload) {
            // Setiap ada perubahan data produk, update low stock count
            _fetchLowStockCount();
          },
        )
        .subscribe();
  }

  @override
  void dispose() {
    Supabase.instance.client.removeChannel(
      Supabase.instance.client.channel('produk_changes'),
    );
    super.dispose();
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
              StocksHeader(onMenuTap: widget.onMenuTap),
              const SizedBox(height: 18),
              StockFilters(
                lowStockCount: _lowStockCount,
                categoryValue: selectedCategory,
                onCategoryChanged: (v) {
                  if (v != null) {
                    setState(() => selectedCategory = v);
                  }
                },
                onSearch: (text) {
                  setState(() => query = text);
                },
              ),
              const SizedBox(height: 18),
              StockList(query: query, category: selectedCategory),
              const SizedBox(height: 18),
              StockHistoryCard(),
            ],
          ),
        ),
      ),
    );
  }
}