import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:project_5_aplikasi_kasir_cookiesboo/features/auth/screens/login_page.dart';
import 'package:project_5_aplikasi_kasir_cookiesboo/features/profile/profile_page.dart';

class SidebarWidget extends StatefulWidget {
  final VoidCallback onClose;
  final Function(int) onMenuSelected;
  final int currentIndex;

  const SidebarWidget({
    super.key,
    required this.onClose,
    required this.onMenuSelected,
    required this.currentIndex,
  });

  @override
  State<SidebarWidget> createState() => _SidebarWidgetState();
}

class _SidebarWidgetState extends State<SidebarWidget> {
  Map<String, dynamic>? userProfile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      final profile = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();
      setState(() {
        userProfile = profile;
        isLoading = false;
      });
    }
  }

  Future<void> logout() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Konfirmasi Logout",
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        ),
        content: const Text(
          "Apakah Anda yakin ingin logout?",
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Logout",
              style: TextStyle(
                color: Color.fromRGBO(217, 160, 91, 1),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (result == true) {
      await Supabase.instance.client.auth.signOut();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromRGBO(255, 227, 191, 1), Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProfilePage(onMenuTap: () {}),
                      ),
                    );
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 22,
                        backgroundImage: AssetImage(
                          "assets/images/profile.png",
                        ),
                      ),
                      const SizedBox(width: 10),
                      isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    userProfile?['name'] ?? 'Unknown',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromRGBO(107, 79, 63, 1),
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 1,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                        254,
                                        243,
                                        199,
                                        1,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Color.fromRGBO(245, 158, 11, 1),
                                      ),
                                    ),
                                    child: Text(
                                      userProfile?['role'] ?? 'Kasir',
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Color.fromRGBO(162, 79, 37, 1),
                                        fontWeight: FontWeight.w900,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: widget.onClose,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 16),
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          Center(
            child: Column(
              children: [
                Image.asset('assets/images/logo_cookiesboo.png', width: 180),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: const Color.fromRGBO(217, 160, 91, 1),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          SidebarItem(
            icon: Icons.space_dashboard,
            label: "Dashboard",
            isActive: widget.currentIndex == 0,
            onTap: () => widget.onMenuSelected(0),
          ),
          SidebarItem(
            icon: Icons.cookie_outlined,
            label: "Produk",
            isActive: widget.currentIndex == 1,
            onTap: () => widget.onMenuSelected(1),
          ),
          SidebarItem(
            icon: Icons.people_outline,
            label: "Pelanggan",
            isActive: widget.currentIndex == 2,
            onTap: () => widget.onMenuSelected(2),
          ),
          SidebarItem(
            icon: Icons.point_of_sale,
            label: "Kasir",
            isActive: widget.currentIndex == 3,
            onTap: () => widget.onMenuSelected(3),
          ),
          SidebarItem(
            icon: Icons.inventory_2_outlined,
            label: "Stok",
            isActive: widget.currentIndex == 4,
            onTap: () => widget.onMenuSelected(4),
          ),
          SidebarItem(
            icon: Icons.assignment,
            label: "Laporan",
            isActive: widget.currentIndex == 5,
            onTap: () => widget.onMenuSelected(5),
          ),
          SidebarItem(
            icon: Icons.app_registration_outlined,
            label: "Registrasi Pengguna\nBaru",
            isActive: widget.currentIndex == 6,
            onTap: () => widget.onMenuSelected(6),
          ),

          const Spacer(),

          GestureDetector(
            onTap: logout,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(217, 160, 91, 1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, color: Colors.white, size: 20),
                  SizedBox(width: 6),
                  Text(
                    "Logout",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const SidebarItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color.fromRGBO(107, 79, 63, 1), size: 22),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color.fromRGBO(107, 79, 63, 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
