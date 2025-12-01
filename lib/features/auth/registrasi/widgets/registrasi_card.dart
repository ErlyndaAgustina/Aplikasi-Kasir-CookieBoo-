import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RegistrationCard extends StatefulWidget {
  const RegistrationCard({super.key});

  @override
  State<RegistrationCard> createState() => _RegistrationCardState();
}

class _RegistrationCardState extends State<RegistrationCard> {
  File? foto;
  final picker = ImagePicker();
  final TextEditingController namaC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passC = TextEditingController();
  final TextEditingController confirmPassC = TextEditingController();
  final TextEditingController phoneC = TextEditingController();
  final TextEditingController alamatC = TextEditingController();

  String? posisi;

  Future<void> pilihFoto() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        foto = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFF1F1F1),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: foto == null
                          ? Image.asset(
                              "assets/images/profile.png",
                              fit: BoxFit.cover,
                            )
                          : Image.file(foto!, fit: BoxFit.cover),
                    ),

                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: pilihFoto,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDEB887),
                            borderRadius: BorderRadius.circular(40),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              const Text(
                "Klik kamera untuk mengubah foto (opsional)",
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),

              const SizedBox(height: 25),

              buildInput(
                controller: namaC,
                label: "Nama Lengkap",
                icon: Icons.person_outline,
                hint: "Masukkan nama lengkap",
              ),
              const SizedBox(height: 15),
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: const [
                    Icon(Icons.work_outline, size: 16, color: Colors.black54),
                    SizedBox(width: 6),
                    Text(
                      "Posisi *",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),

              DropdownButtonFormField<String>(
                value: posisi,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF7F7F7),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      color: Color(0xFFDEB887),
                      width: 1.3,
                    ),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: "kasir", child: Text("Kasir")),
                  DropdownMenuItem(value: "admin", child: Text("Admin")),
                ],
                hint: const Text("Pilih posisi"),
                onChanged: (val) {
                  setState(() {
                    posisi = val;
                  });
                },
              ),

              const SizedBox(height: 15),
              buildInput(
                controller: emailC,
                label: "Alamat Email",
                icon: Icons.email_outlined,
                hint: "Masukkan alamat email",
              ),
              const SizedBox(height: 15),
              buildInput(
                controller: passC,
                label: "Kata Sandi",
                icon: Icons.lock_outline,
                hint: "Minimal 6 karakter",
                obscure: true,
              ),
              const SizedBox(height: 15),
              buildInput(
                controller: confirmPassC,
                label: "Konfirmasi Kata Sandi",
                icon: Icons.lock_outline,
                hint: "Masukkan ulang kata sandi",
                obscure: true,
              ),
              const SizedBox(height: 15),
              buildInput(
                controller: phoneC,
                label: "Nomor Telepon",
                icon: Icons.phone_android,
                hint: "Minimal 12 karakter",
              ),
              const SizedBox(height: 15),
              buildInput(
                controller: alamatC,
                label: "Alamat",
                icon: Icons.location_on_outlined,
                hint: "Masukkan alamat lengkap",
              ),

              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDEB887),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    if (passC.text != confirmPassC.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Kata sandi tidak cocok")),
                      );
                      return;
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_add, size: 20),
                      SizedBox(width: 6),
                      Text(
                        "Buat Akun",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    bool obscure = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.black54),
            const SizedBox(width: 6),
            Text(
              "$label *",
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 6),

        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF7F7F7),
            hintText: hint,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: Color(0xFFDEB887),
                width: 1.3,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
