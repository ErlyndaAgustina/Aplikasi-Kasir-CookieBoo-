import 'package:flutter/material.dart';

class LaporanHeader extends StatelessWidget {
  final VoidCallback onMenuTap;

  const LaporanHeader({super.key, required this.onMenuTap});

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
          "Laporan Penjualan",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: Color.fromRGBO(107, 79, 63, 1),
          ),
        ),
        const SizedBox(height: 3),
        const Text(
          "Analisi dan ekspor data penjualan",
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
