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

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F2ED),
      body: Center(
        child: Container(
          width: 380,
          margin: const EdgeInsets.symmetric(vertical: 20),
          padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),

                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      const AssetImage("assets/images/profile.png"),
                ),

                const SizedBox(height: 14),

                Text(
                  nameController.text,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF3D2A13),
                  ),
                ),

                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFCCE0FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    role == "admin" ? "Admin" : "Kasir",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF265FA3),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: const Color(0xFFD9A05B),
                      width: 1.4,
                    ),
                    color: const Color(0xFFFFF2E5),
                  ),
                  child: const Text(
                    "✏️  Edit Profil",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xFF6B4F3F),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                fieldLabel(Icons.person_outline, "Nama Lengkap"),
                textField(nameController),
                const SizedBox(height: 16),

                fieldLabel(Icons.badge_outlined, "Posisi"),
                dropdownRole(),
                const SizedBox(height: 16),

                fieldLabel(Icons.email_outlined, "Email"),
                textField(emailController),
                const SizedBox(height: 16),

                fieldLabel(Icons.phone_outlined, "Nomor Telepon"),
                textField(nomorController),
                const SizedBox(height: 16),

                fieldLabel(Icons.home_outlined, "Alamat"),
                textField(alamatController, maxLines: 2),

                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 140,
                      height: 46,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor:
                              const Color(0xFF7A6A58),
                          side: const BorderSide(
                            color: Color(0xFFC7B9A8),
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          "Batal",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      width: 140,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: () async {
                          final success = await saveProfile();

                          if (!mounted) return;

                          if (success) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "Profil berhasil diperbarui"),
                              ),
                            );
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "Gagal memperbarui profil"),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFFD6A96D),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          "Simpan",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    )
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

  Widget fieldLabel(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF7A6A58)),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF7A6A58),
          ),
        ),
      ],
    );
  }

  Widget textField(TextEditingController c, {int maxLines = 1}) {
    return TextField(
      controller: c,
      maxLines: maxLines,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF7F2ED),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(fontSize: 14),
    );
  }

  Widget dropdownRole() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F2ED),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: role,
          onChanged: (v) => setState(() => role = v!),
          items: const [
            DropdownMenuItem(value: "admin", child: Text("Admin")),
            DropdownMenuItem(value: "kasir", child: Text("Kasir")),
          ],
        ),
      ),
    );
  }
}
