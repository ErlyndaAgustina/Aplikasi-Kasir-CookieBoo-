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
      return const Color.fromRGBO(219, 234, 254, 1);
    }
    return const Color.fromRGBO(254, 243, 199, 1);
  }

  Color getTextRoleColor() {
    if (role.toLowerCase() == "admin") {
      return const Color.fromRGBO(35, 65, 159, 1);
    }
    return const Color.fromRGBO(162, 79, 37, 1);
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
            color: Colors.black.withOpacity(0.2),
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
              fontWeight: FontWeight.w900,
              color: Color.fromRGBO(107, 79, 63, 1),
            ),
          ),

          const SizedBox(height: 6),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
            decoration: BoxDecoration(
              color: getRoleColor(),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: getTextRoleColor(),
                width: 1,
              ),
            ),
            child: Text(
              role,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: getTextRoleColor(),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            "CookieBoo! Team Member",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15,
              color: Color.fromRGBO(139, 111, 71, 1),
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
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
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
                  fontSize: 13,
                  color: Color.fromRGBO(107, 79, 63, 1),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),
          Divider(color: const Color.fromRGBO(255, 227, 191, 1)),
          const SizedBox(height: 20),

          ProfileFieldCard(
            icon: Icons.person_outline,
            title: "Nama Lengkap",
            value: name,
          ),
          const SizedBox(height: 12),

          ProfileFieldCard(
            icon: Icons.work_outline,
            title: "Posisi",
            value: role,
          ),
          const SizedBox(height: 12),

          ProfileFieldCard(
            icon: Icons.email_outlined,
            title: "Alamat Email",
            value: email,
          ),
          const SizedBox(height: 12),

          ProfileFieldCard(
            icon: Icons.phone_outlined,
            title: "Nomor Telepon",
            value: phone,
          ),
          const SizedBox(height: 12),

          ProfileFieldCard(
            icon: Icons.home_outlined,
            title: "Alamat",
            value: address,
          ),
        ],
      ),
    );
  }
}

class ProfileFieldCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ProfileFieldCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(246, 231, 212, 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Color.fromRGBO(139, 111, 71, 1), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(139, 111, 71, 1),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Color.fromRGBO(107, 79, 63, 1),
                    height: 1.3,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
