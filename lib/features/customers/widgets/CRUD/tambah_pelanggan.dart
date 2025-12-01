import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TambahPelangganPopup extends StatefulWidget {
  const TambahPelangganPopup({super.key});

  @override
  State<TambahPelangganPopup> createState() => _TambahPelangganPopupState();
}

class _TambahPelangganPopupState extends State<TambahPelangganPopup> {
  final _formKey = GlobalKey<FormState>();
  final supabase = Supabase.instance.client;

  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telpController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();

  String? membership;

  final List<String> membershipList = ['Platinum', 'Gold', 'Silver'];

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (membership == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Status membership wajib dipilih')),
      );
      return;
    }

    final nama = namaController.text.trim();
    final email = emailController.text.trim();
    final telp = telpController.text.replaceAll(RegExp(r'\D'), '');
    final alamat = alamatController.text.trim().isEmpty
        ? null
        : alamatController.text.trim();

    final String dbMembership = membership!.toLowerCase();

    try {
      await supabase.from('pelanggan').insert({
        'nama': nama,
        'email': email,
        'nomor_tlpn': telp,
        'alamat': alamat,
        'membership': dbMembership,
      });

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pelanggan berhasil disimpan')),
      );
    } on PostgrestException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan pelanggan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final maxHeight = media.size.height * 0.9;

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 350, maxHeight: maxHeight),
        child: Column(
          children: [
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: const BoxDecoration(
                color: Color.fromRGBO(217, 160, 91, 1),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.person_add,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 7),
                  const Text(
                    'Tambah Pelanggan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _textLabel("Nama Lengkap *"),
                      _textField(
                        controller: namaController,
                        hint: "Contoh: Baskara El Patron.",
                        validator: (v) => v?.trim().isEmpty ?? true
                            ? 'Nama wajib diisi'
                            : null,
                      ),

                      const SizedBox(height: 16),

                      _textLabel("Email *"),
                      _textField(
                        controller: emailController,
                        hint: "baskara@gmail.com",
                        keyboard: TextInputType.emailAddress,
                        validator: (v) {
                          final value = v?.trim() ?? '';
                          if (value.isEmpty) return 'Email wajib diisi';
                          if (!value.endsWith('@gmail.com')) {
                            return 'Email harus menggunakan @gmail.com';
                          }
                          if (!RegExp(
                            r'^[\w\.-]+@gmail\.com$',
                          ).hasMatch(value)) {
                            return 'Format email tidak valid';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      _textLabel("Status Membership *"),
                      _dropdown(),

                      const SizedBox(height: 16),

                      _textLabel("No Telepon *"),
                      _textField(
                        controller: telpController,
                        hint: "098263828192",
                        keyboard: TextInputType.number,
                        validator: (v) {
                          final value = v?.replaceAll(RegExp(r'\D'), '') ?? '';
                          if (value.isEmpty) return 'No telepon wajib diisi';
                          if (!RegExp(r'^\d+$').hasMatch(value)) {
                            return 'No telepon hanya boleh berisi angka';
                          }
                          if (value.length < 12)
                            return 'No telepon minimal 12 angka';
                          if (value.length > 15)
                            return 'No telepon maksimal 15 angka';
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      _textLabel("Alamat (opsional)"),
                      _textField(
                        controller: alamatController,
                        hint: "Alamat lengkap pelanggan...",
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style:
                            OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ).copyWith(
                              side: MaterialStateProperty.all(
                                const BorderSide(
                                  color: Color.fromRGBO(217, 160, 91, 1),
                                  width: 1.6,
                                ),
                              ),
                            ),
                        child: const Text(
                          "Batal",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(107, 79, 63, 1),
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(
                            217,
                            160,
                            91,
                            1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Simpan",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Poppings',
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Color.fromRGBO(139, 111, 71, 1),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboard,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        hintStyle: const TextStyle(
          fontFamily: 'Poppings',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color.fromRGBO(133, 131, 145, 1),
        ),
        hintText: hint,
        fillColor: Colors.white,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 13,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color.fromRGBO(228, 212, 196, 1),
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color.fromRGBO(228, 212, 196, 1),
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color.fromRGBO(217, 160, 91, 1),
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _dropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color.fromRGBO(228, 212, 196, 1),
          width: 2,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: membership,
          hint: const Text(
            "Pilih status membership",
            style: TextStyle(
              fontFamily: 'Poppings',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color.fromRGBO(133, 131, 145, 1),
            ),
          ),
          items: membershipList.map((m) {
            return DropdownMenuItem(
              value: m,
              child: Text(
                m,
                style: const TextStyle(
                  fontFamily: 'Poppings',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color.fromRGBO(139, 111, 71, 1),
                ),
              ),
            );
          }).toList(),
          onChanged: (v) => setState(() => membership = v),
        ),
      ),
    );
  }
}
