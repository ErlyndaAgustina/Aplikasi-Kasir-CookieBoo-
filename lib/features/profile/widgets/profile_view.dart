import 'package:flutter/material.dart';
import '../widgets/profile_edit.dart';

class ProfileView extends StatelessWidget {
  final String name;
  final String role;
  final String email;
  final String phone;
  final String address;

  const ProfileView({
    super.key,
    required this.name,
    required this.role,
    required this.email,
    required this.phone,
    required this.address,
  });

  Color getRoleColor() {
    if (role.toLowerCase() == "admin") {
      return const Color(0xFF92C5FF);
    }
    return const Color(0xFFFFD56E);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(18),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.asset(
              'assets/images/profile.png',
              width: 95,
              height: 95,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            name,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(69, 55, 42, 1),
            ),
          ),

          const SizedBox(height: 6),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
            decoration: BoxDecoration(
              color: getRoleColor(),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              role,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            "CookieBoo! Team Member",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: Color.fromRGBO(143, 109, 77, 1),
            ),
          ),

          const SizedBox(height: 13),

          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfilePage()),
              );
            },
            borderRadius: BorderRadius.circular(25),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: const Color.fromRGBO(217, 160, 91, 1),
                  width: 1.4,
                ),
                color: const Color.fromRGBO(255, 242, 229, 1),
              ),
              child: const Text(
                "✏️  Edit Profil",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13.5,
                  color: Color.fromRGBO(107, 79, 63, 1),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 25),

          buildInfo("Nama Lengkap", name),
          const SizedBox(height: 12),
          buildInfo("Posisi", role),
          const SizedBox(height: 12),
          buildInfo("Alamat Email", email),
          const SizedBox(height: 12),
          buildInfo("Nomor Telepon", phone),
          const SizedBox(height: 12),
          buildInfo("Alamat", address),
        ],
      ),
    );
  }

  Widget buildInfo(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color.fromRGBO(69, 55, 42, 1),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 236, 217, 1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              color: Color.fromRGBO(69, 55, 42, 1),
            ),
          ),
        ),
      ],
    );
  }
}
