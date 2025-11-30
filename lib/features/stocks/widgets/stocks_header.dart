import 'package:flutter/material.dart';

class StocksHeader extends StatelessWidget {
  final VoidCallback onMenuTap;

  const StocksHeader({super.key, required this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            InkWell(
              onTap: onMenuTap,
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/images/logo_cookiesboo.png',
                width: 220,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.person,
              size: 30,
              color: Color.fromRGBO(198, 165, 128, 1),
            ),
          ],
        ),

        const SizedBox(height: 10),

        const Text(
          "Manajemen Stok",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: Color.fromRGBO(107, 79, 63, 1),
          ),
        ),
        const SizedBox(height: 3),
        const Text(
          "Pantau dan perbarui stok produk secara real-time",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color.fromRGBO(139, 111, 71, 1),
          ),
        ),
      ],
    );
  }
}
