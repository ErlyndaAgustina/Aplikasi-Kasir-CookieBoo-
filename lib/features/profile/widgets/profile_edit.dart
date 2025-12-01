import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final supabase = Supabase.instance.client;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final nomorController = TextEditingController();
  final alamatController = TextEditingController();

  String role = "kasir";
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    emailController.text = user.email ?? "";

    final data = await supabase
        .from("profiles")
        .select()
        .eq("id", user.id)
        .maybeSingle();

    if (data != null) {
      nameController.text = data["name"] ?? "";
      role = data["role"] ?? "kasir";
      nomorController.text = data["nomor_telepon"] ?? "";
      alamatController.text = data["alamat"] ?? "";
    }

    setState(() => loading = false);
  }

  Future<bool> saveProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) return false;

    setState(() => loading = true);

    try {
      final newEmail = emailController.text.trim();
      if (newEmail != user.email) {
        await supabase.auth.updateUser(
          UserAttributes(email: newEmail),
        );
      }

      final existing = await supabase
          .from("profiles")
          .select()
          .eq("id", user.id)
          .maybeSingle();

      if (existing == null) {
        await supabase.from("profiles").insert({
          "id": user.id,
          "name": nameController.text.trim(),
          "role": role,
          "nomor_telepon": nomorController.text.trim(),
          "alamat": alamatController.text.trim(),
        });
      } else {
        await supabase.from("profiles").update({
          "name": nameController.text.trim(),
          "role": role,
          "nomor_telepon": nomorController.text.trim(),
          "alamat": alamatController.text.trim(),
          "updated_at": DateTime.now().toIso8601String(),
        }).eq("id", user.id);
      }

      return true;
    } catch (e) {
      print("SUPABASE ERROR: $e");
      return false;
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

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
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 242, 237, 1),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(18),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            width: 380,
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
                  nameController.text,
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

                const SizedBox(height: 10),
                Divider(color: const Color.fromRGBO(255, 227, 191, 1)),
                const SizedBox(height: 18),

                editableCard(
                  icon: Icons.person_outline,
                  title: "Nama Lengkap",
                  child: TextField(
                    controller: nameController,
                    decoration: fieldInputDecoration(),
                  ),
                ),
                const SizedBox(height: 12),

                editableCard(
                  icon: Icons.work_outline,
                  title: "Posisi",
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: role,
                      items: const [
                        DropdownMenuItem(value: "admin", child: Text("Admin")),
                        DropdownMenuItem(value: "kasir", child: Text("Kasir")),
                      ],
                      onChanged: (v) => setState(() => role = v!),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                editableCard(
                  icon: Icons.email_outlined,
                  title: "Alamat Email",
                  child: TextField(
                    controller: emailController,
                    decoration: fieldInputDecoration(),
                  ),
                ),
                const SizedBox(height: 12),

                editableCard(
                  icon: Icons.phone_outlined,
                  title: "Nomor Telepon",
                  child: TextField(
                    controller: nomorController,
                    decoration: fieldInputDecoration(),
                  ),
                ),
                const SizedBox(height: 12),

                editableCard(
                  icon: Icons.home_outlined,
                  title: "Alamat",
                  child: TextField(
                    controller: alamatController,
                    maxLines: 2,
                    decoration: fieldInputDecoration(),
                  ),
                ),

                const SizedBox(height: 28),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 145,
                      height: 46,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color.fromRGBO(107, 79, 63, 1),
                          side: const BorderSide(
                            color: Color.fromRGBO(217, 160, 91, 1),
                            width: 1.2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          "Batal",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      width: 145,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: () async {
                          final success = await saveProfile();

                          if (!mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                success
                                    ? "Profil berhasil diperbarui"
                                    : "Gagal memperbarui profil",
                              ),
                            ),
                          );

                          if (success) Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(214, 169, 109, 1),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          "Simpan",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration fieldInputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: const Color.fromRGBO(255, 242, 229, 1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    );
  }

  Widget editableCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(246, 231, 212, 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color.fromRGBO(139, 111, 71, 1), size: 20),
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
                child,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
