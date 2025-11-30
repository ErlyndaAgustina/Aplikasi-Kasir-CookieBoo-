import 'package:flutter/material.dart';
import 'package:project_5_aplikasi_kasir_cookiesboo/features/profile/profile_page.dart';
import '../widgets/CRUD/tambah_pelanggan.dart';

class PelangganHeader extends StatelessWidget {
  final VoidCallback onTambahMember;
  final VoidCallback onMenuTap;

  const PelangganHeader({
    super.key,
    required this.onTambahMember,
    required this.onMenuTap,
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
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Manajemen Pelanggan",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color.fromRGBO(107, 79, 63, 1),
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    "Kelola data pelanggan & membership",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(139, 111, 71, 1),
                    ),
                  ),
                ],
              ),
            ),

            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const TambahPelangganPopup(),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(217, 160, 91, 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.person_add_alt_1,
                        size: 18,
                        color: Colors.white,
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Tambah Member",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
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
      ],
    );
  }
}
