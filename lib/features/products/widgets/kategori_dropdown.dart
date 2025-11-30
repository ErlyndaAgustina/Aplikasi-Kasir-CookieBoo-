import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class KategoriDropdown extends StatefulWidget {
  final String? value;
  final ValueChanged<String?> onChanged;

  const KategoriDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<KategoriDropdown> createState() => _KategoriDropdownState();
}

class _KategoriDropdownState extends State<KategoriDropdown> {
  final supabase = Supabase.instance.client;
  List<String> kategoriList = [];
  String? selected;

  @override
  void initState() {
    super.initState();
    selected = widget.value;
    loadKategori();
  }

  Future<void> loadKategori() async {
    try {
      final response = await supabase.from('produk').select('kategori');

      final kategoriSet = <String>{};
      for (var e in response) {
        if (e['kategori'] != null) kategoriSet.add(e['kategori']);
      }

      setState(() {
        kategoriList = ['Semua Kategori', ...kategoriSet.toList()];
      });
    } catch (e) {
      print('Error load kategori: $e');
      setState(() {
        kategoriList = ['Semua Kategori'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color.fromRGBO(198, 165, 128, 1),
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selected,
          isExpanded: true,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color.fromRGBO(107, 79, 63, 1),
          ),
          hint: const Text("Pilih Kategori"),
          items: kategoriList.map((text) {
            return DropdownMenuItem(
              value: text,
              child: Row(
                children: [
                  const Icon(
                    Icons.category,
                    size: 20,
                    color: Color.fromRGBO(198, 165, 128, 1),
                  ),
                  const SizedBox(width: 10),
                  Text(text),
                ],
              ),
            );
          }).toList(),
          onChanged: (v) {
            setState(() => selected = v);
            widget.onChanged(v);
          },
        ),
      ),
    );
  }
}
