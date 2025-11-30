import 'package:flutter/material.dart';
import '../widgets/stock_item.dart';

class StockList extends StatelessWidget {
  final String? query;
  final String? category;

  const StockList({
    super.key,
    required this.query,
    required this.category,
  });

  List<Map<String, dynamic>> get data => [
        {
          "name": "Choco Chip Cookies",
          "stock": 20,
          "max": 80,
          "min": 20,
          "cat": "Klasik",
          "img": "cookies"
        },
        {
          "name": "Monster Cookies",
          "stock": 50,
          "max": 80,
          "min": 20,
          "cat": "Premium",
          "img": "cookies"
        },
        {
          "name": "Choco Marsmellow",
          "stock": 12,
          "max": 80,
          "min": 20,
          "cat": "SoftCookies",
          "img": "cookies"
        },
        {
          "name": "Red Velvet Oreo",
          "stock": 0,
          "max": 50,
          "min": 20,
          "cat": "Premium",
          "img": "cookies"
        },
      ];

  @override
  Widget build(BuildContext context) {
    final q = (query ?? "").toLowerCase();
    final c = category ?? "Semua Kategori";

    final filtered = data.where((item) {
      final matchQuery = item["name"].toString().toLowerCase().contains(q);
      final matchCategory = c == "Semua Kategori" || item["cat"] == c;
      return matchQuery && matchCategory;
    }).toList();

    return Column(
      children: filtered.map((e) {
        return StockItem(
          name: e["name"] ?? "",
          stock: e["stock"] ?? 0,
          minStock: e["min"] ?? 0,
          category: e["cat"] ?? "Default",
        );
      }).toList(),
    );
  }
}
