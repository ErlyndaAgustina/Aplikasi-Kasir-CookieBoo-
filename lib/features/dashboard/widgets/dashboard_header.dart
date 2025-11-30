import 'package:flutter/material.dart';

import '../../profile/profile_page.dart';

class DashboardHeader extends StatelessWidget {
  final VoidCallback onMenuTap;

  const DashboardHeader({super.key, required this.onMenuTap});

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
          "Dashboard",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: Color.fromRGBO(107, 79, 63, 1),
          ),
        ),
        const SizedBox(height: 3),
        const Text(
          "Lihat ringkasan penjualan dan aktivitas toko",
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
