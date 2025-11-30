import 'package:flutter/material.dart';
import 'package:project_5_aplikasi_kasir_cookiesboo/features/profile/profile_page.dart';

class ProdukHeader extends StatelessWidget {
  final VoidCallback onMenuTap;
  final VoidCallback onReloadTap;

  const ProdukHeader({
    super.key,
    required this.onMenuTap,
    required this.onReloadTap,
  });

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
              onTap: onReloadTap,
              child: const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(
                  Icons.refresh_rounded,
                  size: 28,
                  color: Color.fromRGBO(198, 165, 128, 1),
                ),
              ),
            ),

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
          "Manajemen Produk",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: Color.fromRGBO(107, 79, 63, 1),
          ),
        ),
        const SizedBox(height: 3),
        const Text(
          "Atur data produk dengan mudah",
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
