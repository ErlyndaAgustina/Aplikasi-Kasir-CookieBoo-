import 'package:flutter/material.dart';

class StockFilters extends StatelessWidget {
  final String categoryValue;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<String> onSearch;
  final int lowStockCount;

  const StockFilters({
    super.key,
    required this.categoryValue,
    required this.onCategoryChanged,
    required this.onSearch,
    this.lowStockCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (lowStockCount > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(255, 0, 0, 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color.fromRGBO(255, 50, 50, 1),
                width: 1.4,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  size: 22,
                  color: Color.fromRGBO(107, 79, 63, 1),
                ),
                const SizedBox(width: 10),
                Text(
                  "$lowStockCount Produk Stok Rendah",
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color.fromRGBO(107, 79, 63, 1),
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: 14),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: const Color.fromRGBO(198, 165, 128, 1),
              width: 1,
            ),
          ),
          child: TextField(
            onChanged: onSearch,
            decoration: const InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.search,
                color: Color.fromRGBO(198, 165, 128, 1),
              ),
              hintText: "Cari Stok Produk...",
              hintStyle: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color.fromRGBO(107, 79, 63, 1),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color.fromRGBO(198, 165, 128, 1),
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: categoryValue,
              isExpanded: true,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color.fromRGBO(107, 79, 63, 1),
              ),
              selectedItemBuilder: (context) {
                return [
                  "Semua Kategori",
                  "Premium",
                  "Klasik",
                  "SoftCookies",
                ].map((text) {
                  return Row(
                    children: [
                      const Icon(
                        Icons.category,
                        size: 20,
                        color: Color.fromRGBO(198, 165, 128, 1),
                      ),
                      const SizedBox(width: 20),
                      Text(text),
                    ],
                  );
                }).toList();
              },
              items: const [
                DropdownMenuItem(
                  value: "Semua Kategori",
                  child: Row(
                    children: [
                      Icon(
                        Icons.category,
                        size: 20,
                        color: Color.fromRGBO(198, 165, 128, 1),
                      ),
                      SizedBox(width: 20),
                      Text(
                        "Semua Kategori",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(139, 111, 71, 1),
                        ),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: "Premium",
                  child: Row(
                    children: [
                      Icon(
                        Icons.category,
                        size: 20,
                        color: Color.fromRGBO(198, 165, 128, 1),
                      ),
                      SizedBox(width: 20),
                      Text(
                        "Premium",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(139, 111, 71, 1),
                        ),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: "Klasik",
                  child: Row(
                    children: [
                      Icon(
                        Icons.category,
                        size: 20,
                        color: Color.fromRGBO(198, 165, 128, 1),
                      ),
                      SizedBox(width: 20),
                      Text(
                        "Klasik",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(139, 111, 71, 1),
                        ),
                      ),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: "SoftCookies",
                  child: Row(
                    children: [
                      Icon(
                        Icons.category,
                        size: 20,
                        color: Color.fromRGBO(198, 165, 128, 1),
                      ),
                      SizedBox(width: 20),
                      Text(
                        "SoftCookies",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(139, 111, 71, 1),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              onChanged: onCategoryChanged,
            ),
          ),
        ),
      ],
    );
  }
}
