import 'package:flutter/material.dart';
import '../widgets/produk_header.dart';
import '../widgets/bestseller_section.dart';
import '../widgets/search_field.dart';
import '../widgets/kategori_dropdown.dart';
import '../widgets/produk_grid.dart';
import '../CRUD/tambah_produk.dart';

class ProdukPage extends StatefulWidget {
  final VoidCallback onMenuTap;

  const ProdukPage({super.key, required this.onMenuTap});

  @override
  State<ProdukPage> createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  String selectedCategory = 'Semua Kategori';
  String searchQuery = '';
  final GlobalKey<ProdukGridState> _gridKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(246, 231, 212, 1),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const TambahProdukPopup(),
          );

          if (result == true) _gridKey.currentState?.loadProduk();
        },
        backgroundColor: const Color.fromRGBO(217, 160, 91, 1),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 28, color: Colors.white),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProdukHeader(
                onMenuTap: widget.onMenuTap,
                onReloadTap: () => _gridKey.currentState?.loadProduk(),
              ),
              const SizedBox(height: 12),
              const BestsellerSection(),
              const SizedBox(height: 18),
              ProdukSearchField(
                onSearchChanged: (query) {
                  setState(() {
                    searchQuery = query;
                  });
                },
              ),

              const SizedBox(height: 12),
              KategoriDropdown(
                value: selectedCategory,
                onChanged: (v) {
                  setState(() => selectedCategory = v!);
                  _gridKey.currentState?.loadProduk();
                },
              ),
              const SizedBox(height: 16),
              ProdukGrid(
                key: _gridKey,
                selectedCategory: selectedCategory,
                searchQuery: searchQuery,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
