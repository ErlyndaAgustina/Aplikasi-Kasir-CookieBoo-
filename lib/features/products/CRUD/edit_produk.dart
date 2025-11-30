import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProdukPopup extends StatefulWidget {
  final Map<String, dynamic> data;

  const EditProdukPopup({super.key, required this.data});

  @override
  State<EditProdukPopup> createState() => _EditProdukPopupState();
}

class _EditProdukPopupState extends State<EditProdukPopup> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController namaCtrl;
  late TextEditingController hargaCtrl;
  late TextEditingController stokCtrl;
  late TextEditingController stokMinCtrl;

  XFile? pickedImage;
  String? selectedKategori;
  String? initialImage;

  final supabase = Supabase.instance.client;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    namaCtrl = TextEditingController(text: widget.data["nama_produk"]);
    hargaCtrl = TextEditingController(text: widget.data["harga"].toString());
    stokCtrl = TextEditingController(text: widget.data["stok"].toString());
    stokMinCtrl = TextEditingController(
      text: widget.data["stok_minimum"]?.toString() ?? "10",
    );

    selectedKategori = widget.data["kategori"];
    initialImage = widget.data["foto_produk"];
  }

  @override
  void dispose() {
    namaCtrl.dispose();
    hargaCtrl.dispose();
    stokCtrl.dispose();
    stokMinCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.9;

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
              decoration: BoxDecoration(
                color: const Color.fromRGBO(217, 160, 91, 1),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
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
                    'Edit Produk',
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
                      _label("Foto Produk"),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(246, 231, 212, 1),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: const Color.fromRGBO(229, 212, 193, 1),
                              width: 2,
                            ),
                          ),
                          child: _buildImagePreview(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _textField(
                        controller: namaCtrl,
                        label: "Nama Produk *",
                        hint: "Masukkan nama produk...",
                      ),
                      const SizedBox(height: 18),
                      _label("Kategori *"),
                      const SizedBox(height: 10),
                      _buildKategoriDropdown(),
                      const SizedBox(height: 18),
                      _textField(
                        controller: hargaCtrl,
                        label: "Harga (Rp) *",
                        hint: "Masukkan harga produk...",
                        keyboard: TextInputType.number,
                      ),
                      const SizedBox(height: 18),
                      _textField(
                        controller: stokCtrl,
                        label: "Stok (box) *",
                        hint: "Masukkan jumlah stok...",
                        keyboard: TextInputType.number,
                      ),
                      const SizedBox(height: 18),
                      _textField(
                        controller: stokMinCtrl,
                        label: "Stok Minimum *",
                        hint: "Masukkan stok minimum (minimal 10pcs)...",
                        keyboard: TextInputType.number,
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
                        onPressed: isSubmitting ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          backgroundColor: const Color.fromRGBO(
                            217,
                            160,
                            91,
                            1,
                          ),
                          elevation: 0,
                        ),
                        child: isSubmitting
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
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

  Widget _label(String text) => Text(
    text,
    style: const TextStyle(
      fontFamily: 'Poppins',
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: Color.fromRGBO(139, 111, 71, 1),
    ),
  );

  Widget _textField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboard = TextInputType.text,
    int maxLines = 1,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _label(label),
      const SizedBox(height: 10),
      TextFormField(
        controller: controller,
        keyboardType: keyboard,
        maxLines: maxLines,
        validator: (value) =>
            (value == null || value.isEmpty) ? "Field wajib diisi" : null,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color.fromRGBO(133, 131, 145, 1),
          ),
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
      ),
    ],
  );

  Widget _buildKategoriDropdown() {
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
          value: selectedKategori,
          hint: const Text(
            "Pilih Kategori",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color.fromRGBO(133, 131, 145, 1),
            ),
          ),
          items: const [
            DropdownMenuItem(value: "Klasik", child: Text("Klasik")),
            DropdownMenuItem(value: "Premium", child: Text("Premium")),
            DropdownMenuItem(value: "SoftCookies", child: Text("SoftCookies")),
          ],
          onChanged: (v) => setState(() => selectedKategori = v),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    if (pickedImage != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.file(File(pickedImage!.path), fit: BoxFit.cover),
      );
    }
    if (initialImage != null && initialImage!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.network(initialImage!, fit: BoxFit.cover),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.upload_rounded,
          size: 45,
          color: Color.fromRGBO(139, 111, 71, 1),
        ),
        SizedBox(height: 5),
        Text(
          'Drag & drop foto di sini',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color.fromRGBO(107, 79, 63, 1),
          ),
        ),
        SizedBox(height: 3),
        Text(
          'atau klik untuk pilih foto file',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            color: Color.fromRGBO(139, 111, 71, 1),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final img = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (img != null) setState(() => pickedImage = img);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedKategori == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Kategori harus dipilih')));
      return;
    }

    setState(() => isSubmitting = true);

    try {
      String? fotoUrl = initialImage;

      if (pickedImage != null) {
        final bytes = await pickedImage!.readAsBytes();
        final ext = pickedImage!.path.split('.').last;
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.$ext';
        await supabase.storage
            .from('produk')
            .uploadBinary('images/$fileName', bytes);
        fotoUrl = supabase.storage
            .from('produk')
            .getPublicUrl('images/$fileName');
      }

      final harga =
          double.tryParse(hargaCtrl.text.replaceAll(RegExp(r'[^0-9.]'), '')) ??
          0;
      final stok = int.tryParse(stokCtrl.text) ?? 0;
      final stokMin = int.tryParse(stokMinCtrl.text) ?? 10;

      await supabase
          .from('produk')
          .update({
            'nama_produk': namaCtrl.text,
            'harga': harga,
            'stok': stok,
            'stok_minimum': stokMin,
            'kategori': selectedKategori,
            'foto_produk': fotoUrl,
          })
          .eq('id', widget.data['id']);

      setState(() => isSubmitting = false);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk berhasil diperbarui')),
      );
    } catch (e) {
      setState(() => isSubmitting = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memperbarui produk: $e')));
    }
  }
}
