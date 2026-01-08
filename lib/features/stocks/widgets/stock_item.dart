import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'edit_stock.dart'; // UpdateStokPopup ada di file ini

class StockItem extends StatelessWidget {
  final String name;
  final int stock;
  final int minStock;
  final String category;
  final String productId; // ID produk dari Supabase (uuid sebagai String)

  const StockItem({
    super.key,
    required this.name,
    required this.stock,
    required this.minStock,
    required this.category,
    required this.productId, // ← diperbaiki, hanya satu kali
  });

  Color get statusColor {
    if (stock <= 0) return const Color.fromRGBO(212, 24, 61, 1);
    if (stock <= minStock) return const Color.fromRGBO(245, 158, 11, 1);
    return const Color.fromRGBO(35, 65, 159, 1);
  }

  IconData get statusIcon {
    if (stock <= 0) return CupertinoIcons.minus;
    if (stock <= minStock) return CupertinoIcons.arrow_down_right;
    return CupertinoIcons.arrow_up_right;
  }

  String get statusText {
    if (stock <= 0) return "Habis";
    if (stock <= minStock) return "Stok Rendah";
    return "Normal";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color.fromRGBO(238, 215, 190, 1),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w900,
                    fontSize: 17,
                    color: Color.fromRGBO(107, 79, 63, 1),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: statusColor, width: 1.3),
                    color: statusColor.withOpacity(0.12),
                  ),
                  child: Row(
                    children: [
                      Icon(statusIcon, size: 14, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        statusText,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(217, 160, 91, 1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                category,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfo("Stok Tersedia", "$stock Box"),
                _buildInfo("Stok Minimum", "$minStock Box"),
              ],
            ),

            const SizedBox(height: 14),

            Container(
              height: 30,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(217, 160, 91, 1),
                borderRadius: BorderRadius.circular(30),
              ),
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () async {
                  final result = await showDialog<bool>(
                    context: context,
                    builder: (_) => UpdateStokPopup(
                      namaProduk: name,
                      stokSaatIni: stock,
                      stokMinimum: minStock,
                      productId: productId, // ← sekarang benar, pakai field yang ada
                    ),
                  );

                  if (result == true) {
                    // Tempat untuk refresh data di parent widget
                    // Contoh: panggil setState() di parent, atau trigger refresh dengan Provider/Bloc/Riverpod
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9A05B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        CupertinoIcons.pencil,
                        size: 18,
                        color: Colors.white,
                      ),
                      SizedBox(width: 6),
                      Text(
                        "Edit Stok",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo(String title, String value) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: Color.fromRGBO(124, 124, 126, 1),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color.fromRGBO(139, 111, 71, 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}