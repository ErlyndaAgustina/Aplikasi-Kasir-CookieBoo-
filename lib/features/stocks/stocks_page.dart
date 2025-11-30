import 'package:flutter/material.dart';
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
                lowStockCount: 4,
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
