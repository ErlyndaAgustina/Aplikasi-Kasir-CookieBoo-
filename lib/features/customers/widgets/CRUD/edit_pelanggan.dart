import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/services.dart';

class EditPelangganPopup extends StatefulWidget {
  final Map<String, dynamic> data;

  const EditPelangganPopup({super.key, required this.data});

  @override
  State<EditPelangganPopup> createState() => _EditPelangganPopupState();
}

class _EditPelangganPopupState extends State<EditPelangganPopup> {
  late TextEditingController namaController;
  late TextEditingController emailController;
  late TextEditingController telpController;
  late TextEditingController alamatController;

  String? membership;
  final supabase = Supabase.instance.client;

  final List<String> membershipList = ['Platinum', 'Gold', 'Silver'];

  @override
  void initState() {
    super.initState();

    namaController = TextEditingController(
      text: widget.data['nama']?.toString() ?? '',
    );
    emailController = TextEditingController(
      text: widget.data['email']?.toString() ?? '',
    );
    telpController = TextEditingController(
      text: widget.data['nomor_tlpn']?.toString() ?? '',
    );
    alamatController = TextEditingController(
      text: widget.data['alamat']?.toString() ?? '',
    );

    final dbMembership = widget.data['membership']?.toString().toLowerCase();
    membership = membershipList.firstWhere(
      (e) => e.toLowerCase() == dbMembership,
      orElse: () => 'Silver',
    );
  }

  @override
  void dispose() {
    namaController.dispose();
    emailController.dispose();
    telpController.dispose();
    alamatController.dispose();
    super.dispose();
  }

  Future<void> _simpanPerubahan() async {
    final nama = namaController.text.trim();
    final email = emailController.text.trim().toLowerCase();
    final telp = telpController.text.trim();
    final cleanedTelp = telp.replaceAll(RegExp(r'\D'), '');
    if (nama.isEmpty) {
      _showError("Nama tidak boleh kosong");
      return;
    }

    if (email.isEmpty) {
      _showError("Email tidak boleh kosong");
      return;
    }

    if (!email.endsWith("@gmail.com")) {
      _showError("Email harus menggunakan domain @gmail.com");
      return;
    }

    if (membership == null || membership!.isEmpty) {
      _showError("Status membership tidak boleh kosong");
      return;
    }

    if (telp.isEmpty) {
      _showError("Nomor telepon tidak boleh kosong");
      return;
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(telp)) {
      _showError("Nomor telepon harus berupa angka");
      return;
    }

    if (cleanedTelp.length < 12) {
      _showError("Nomor telepon minimal 12 angka");
      return;
    }

    final String dbMembership = membership!.toLowerCase();

    try {
      await supabase
          .from('pelanggan')
          .update({
            'nama': nama,
            'email': email,
            'nomor_tlpn': cleanedTelp,
            'alamat': alamatController.text.trim().isEmpty
                ? null
                : alamatController.text.trim(),
            'membership': dbMembership,
          })
          .eq('id', widget.data['id']);

      if (!mounted) return;
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data pelanggan berhasil diperbarui!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      _showError("Gagal menyimpan: $e");
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
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
                      Icons.edit,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 7),
                  const Text(
                    'Edit Pelanggan',
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label("Nama Lengkap *"),
                    _field(
                      controller: namaController,
                      hint: "Contoh: Baskara El Patron.",
                    ),

                    const SizedBox(height: 16),
                    _label("Email *"),
                    _field(
                      controller: emailController,
                      hint: "baskara@gmail.com",
                    ),

                    const SizedBox(height: 16),
                    _label("Status Membership *"),
                    _dropdown(),

                    const SizedBox(height: 16),
                    _label("No Telepon *"),
                    _field(
                      controller: telpController,
                      hint: "098263828192",
                      keyboard: TextInputType.number,
                    ),

                    const SizedBox(height: 16),
                    _label("Alamat"),
                    _field(
                      controller: alamatController,
                      hint: "Alamat lengkap pelanggan (opsional)",
                      maxLines: 3,
                    ),
                  ],
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
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          side: const BorderSide(
                            color: Color.fromRGBO(217, 160, 91, 1),
                            width: 1.6,
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
                        onPressed: _simpanPerubahan,
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
                        ),
                        child: const Text(
                          "Simpan",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
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

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Color.fromRGBO(139, 111, 71, 1),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboard,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      maxLines: maxLines,
      inputFormatters: keyboard == TextInputType.number
          ? [FilteringTextInputFormatter.digitsOnly]
          : null,
      decoration: InputDecoration(
        hintStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color.fromRGBO(133, 131, 145, 1),
        ),
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
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
            "Pilih Membership",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color.fromRGBO(133, 131, 145, 1),
            ),
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFFB7ADA4),
          ),
          items: membershipList
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(
                    e,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(139, 111, 71, 1),
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: (v) => setState(() => membership = v),
        ),
      ),
    );
  }
}
