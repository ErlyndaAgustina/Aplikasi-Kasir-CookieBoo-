import 'package:flutter/material.dart';

import '../../profile/profile_page.dart';

class CashierHeader extends StatelessWidget {
  final VoidCallback onMenuTap;

  const CashierHeader({super.key, required this.onMenuTap});

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
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(onMenuTap: () {}),
                  ),
                );
              },
              child: const Icon(
                Icons.person,
                size: 30,
                color: Color.fromRGBO(198, 165, 128, 1),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        const Text(
          "Kasir",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: Color.fromRGBO(107, 79, 63, 1),
          ),
        ),
        const SizedBox(height: 3),
        const Text(
          "Catat transaksi pelanggan dengan mudah dan cepat",
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
