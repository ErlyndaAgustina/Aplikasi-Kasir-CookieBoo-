import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UpdateStokPopup extends StatefulWidget {
  final String namaProduk;
  final int stokSaatIni;
  final int stokMinimum;
  final String productId; // ← BARU: ID produk dari Supabase

  const UpdateStokPopup({
    super.key,
    required this.namaProduk,
    required this.stokSaatIni,
    required this.stokMinimum,
    required this.productId,
  });

  @override
  State<UpdateStokPopup> createState() => _UpdateStokPopupState();
}

class _UpdateStokPopupState extends State<UpdateStokPopup> {
  final TextEditingController jumlahCtrl = TextEditingController();
  final TextEditingController deskripsiCtrl = TextEditingController();

  bool isTambah = true;
  bool hasError = false;
  bool isLoading = false; // untuk indikator loading saat simpan

  final SupabaseClient supabase = Supabase.instance.client;

  @override
  void dispose() {
    jumlahCtrl.dispose();
    deskripsiCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final maxHeight = media.size.height * 0.9;

    int perubahan = 0;
    if (jumlahCtrl.text.isNotEmpty) {
      perubahan = int.tryParse(jumlahCtrl.text) ?? 0;
      perubahan = isTambah ? perubahan : -perubahan;
    }
    int stokSetelah = widget.stokSaatIni + perubahan;

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 380, maxHeight: maxHeight),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header tetap sama
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: const BoxDecoration(
                color: Color(0xFFD9A05B),
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
                      Icons.inventory_2_outlined,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Update Stok',
                    style: TextStyle(
                      fontFamily: 'Poppins',
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

            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Semua bagian UI tetap 100% sama seperti sebelumnya
                    // ... (tidak diubah, hanya disalin)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6E7D4),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Produk', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF8B6F47), fontWeight: FontWeight.w500)),
                          const SizedBox(height: 4),
                          Text(widget.namaProduk, style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF5D4037))),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _infoColumn('Stok Saat Ini', '${widget.stokSaatIni} box'),
                              _infoColumn('Stok Minimum', '${widget.stokMinimum} box'),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                    const Text('Jenis Perubahan', style: TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF8B6F47))),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _toggleButton(label: '+ Tambah Stok', isSelected: isTambah, onTap: () => setState(() => isTambah = true))),
                        const SizedBox(width: 12),
                        Expanded(child: _toggleButton(label: '- Kurangi Stok', isSelected: !isTambah, onTap: () => setState(() => isTambah = false))),
                      ],
                    ),

                    const SizedBox(height: 20),
                    const Text('Jumlah (box)', style: TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF8B6F47))),
                    const SizedBox(height: 10),
                    TextField(
                      controller: jumlahCtrl,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(() => hasError = false),
                      decoration: InputDecoration(
                        hintText: hasError ? 'Masukkan jumlah box...' : '20',
                        hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: hasError ? Colors.red.shade700 : const Color(0xFF857F91)),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFFE5D4C1), width: 2)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFFE5D4C1), width: 2)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFFD9A05B), width: 2)),
                      ),
                    ),

                    const SizedBox(height: 20),
                    const Text('Deskripsi', style: TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF8B6F47))),
                    const SizedBox(height: 10),
                    TextField(
                      controller: deskripsiCtrl,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Contoh: Restock dari dapur, Produk rusak/ kadaluarsa, dll',
                        hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Color(0xFF857F91)),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFFE5D4C1), width: 2)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFFE5D4C1), width: 2)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFFD9A05B), width: 2)),
                      ),
                    ),

                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: const Color(0xFFF6E7D4), borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Stok Setelah Perubahan', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Color(0xFF8B6F47), fontWeight: FontWeight.w500)),
                          Text('$stokSetelah box', style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF5D4037))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Tombol Batal & Simpan
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF6B4F3F),
                        side: const BorderSide(color: Color(0xFFD9A05B), width: 1.6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Batal', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _simpanPerubahan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD9A05B),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: isLoading
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('Simpan', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
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

  Future<void> _simpanPerubahan() async {
    if (jumlahCtrl.text.isEmpty) {
      setState(() => hasError = true);
      return;
    }

    final jumlah = int.parse(jumlahCtrl.text);
    if (jumlah <= 0) {
      setState(() => hasError = true);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Jumlah harus lebih dari 0')));
      return;
    }

    setState(() => isLoading = true);

    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) throw 'User tidak terotentikasi';

      final tipe = isTambah ? 'penambahan' : 'pengurangan';
      final stokBaru = widget.stokSaatIni + (isTambah ? jumlah : -jumlah);

      // 1. Update stok di tabel produk
      await supabase
          .from('produk')
          .update({'stok': stokBaru, 'updated_at': DateTime.now().toIso8601String()})
          .eq('id', widget.productId);

      // 2. Insert riwayat stok
      await supabase.from('riwayat_stok').insert({
        'produk_id': widget.productId,
        'kasir_id': userId,
        'tipe_perubahan': tipe,
        'jumlah_perubahan': jumlah,
        'stok_sebelum': widget.stokSaatIni,
        'stok_sesudah': stokBaru,
        'keterangan': deskripsiCtrl.text.trim().isEmpty ? null : deskripsiCtrl.text.trim(),
      });

      if (mounted) {
        Navigator.pop(context, true); // kembalikan true agar parent tahu perlu refresh
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Stok berhasil diperbarui')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menyimpan: $e')));
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Widget _infoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF8B6F47))),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF5D4037))),
      ],
    );
  }

  Widget _toggleButton({required String label, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFD9A05B) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFD9A05B), width: 1.5),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFFD9A05B),
          ),
        ),
      ),
    );
  }
}