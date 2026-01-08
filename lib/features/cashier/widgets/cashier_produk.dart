import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class CashierProduk extends StatefulWidget {
  final ValueChanged<Map<String, String>> onAddToCart;

  const CashierProduk({
    super.key,
    required this.onAddToCart,
  });

  @override
  State<CashierProduk> createState() => _CashierProdukState();
}

class _CashierProdukState extends State<CashierProduk> {
  String selectedCategory = "Semua Kategori";
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromRGBO(217, 160, 91, 1),
            Color.fromRGBO(249, 216, 208, 1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.95],
        ),
        borderRadius: const BorderRadius.all(Radius.circular(22)),
        border: Border.all(
          color: Color.fromRGBO(198, 165, 128, 1),
          width: 1.25,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.22),
            blurRadius: 5,
            offset: const Offset(6, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProdukSearchField(controller: _searchController),
          const SizedBox(height: 14),
          KategoriDropdown(
            value: selectedCategory,
            onChanged: (v) {
              setState(() {
                selectedCategory = v!;
              });
            },
          ),
          const SizedBox(height: 20),
          ProdukGrid(
            selectedCategory: selectedCategory,
            searchQuery: searchQuery,
            onAddToCart: widget.onAddToCart,
          ),
        ],
      ),
    );
  }
}

class ProdukSearchField extends StatelessWidget {
  final TextEditingController controller;

  const ProdukSearchField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color.fromRGBO(198, 165, 128, 1),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.search,
            color: Color.fromRGBO(198, 165, 128, 1),
          ),
          hintText: "Cari Produk Cookies...",
          hintStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color.fromRGBO(107, 79, 63, 1),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}

class KategoriDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;

  const KategoriDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

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
          value: value,
          isExpanded: true,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color.fromRGBO(107, 79, 63, 1),
          ),
          selectedItemBuilder: (context) {
            return ["Semua Kategori", "Premium", "Klasik", "SoftCookies"]
                .map((text) {
              return Row(
                children: [
                  const Icon(
                    Icons.category,
                    size: 20,
                    color: Color.fromRGBO(198, 165, 128, 1),
                  ),
                  const SizedBox(width: 20),
                  Text(text),
                ],
              );
            }).toList();
          },
          items: const [
            DropdownMenuItem(
              value: "Semua Kategori",
              child: ItemKategori("Semua Kategori"),
            ),
            DropdownMenuItem(
              value: "Premium",
              child: ItemKategori("Premium"),
            ),
            DropdownMenuItem(
              value: "Klasik",
              child: ItemKategori("Klasik"),
            ),
            DropdownMenuItem(
              value: "SoftCookies",
              child: ItemKategori("SoftCookies"),
            ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class ItemKategori extends StatelessWidget {
  final String label;
  const ItemKategori(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.category,
          size: 20,
          color: Color.fromRGBO(198, 165, 128, 1),
        ),
        const SizedBox(width: 20),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color.fromRGBO(139, 111, 71, 1),
          ),
        ),
      ],
    );
  }
}

class ProdukGrid extends StatefulWidget {
  final String selectedCategory;
  final String searchQuery;
  final ValueChanged<Map<String, String>> onAddToCart;

  const ProdukGrid({
    super.key,
    required this.selectedCategory,
    required this.searchQuery,
    required this.onAddToCart,
  });

  @override
  State<ProdukGrid> createState() => _ProdukGridState();
}

class _ProdukGridState extends State<ProdukGrid> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> produkList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProduk();
    // Realtime subscription
    supabase
        .channel('public:produk')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'produk',
          callback: (payload) {
            if (mounted) {
              loadProduk();
            }
          },
        )
        .subscribe();
  }

  @override
  void dispose() {
    supabase.removeAllChannels();
    super.dispose();
  }

  Future<void> loadProduk() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    try {
      final response = await supabase
          .from('produk')
          .select('id, nama_produk, harga, stok, kategori, foto_produk');

      if (mounted) {
        setState(() {
          produkList = List<Map<String, dynamic>>.from(response);
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error load produk: $e');
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final filtered = produkList.where((p) {
      final matchesCategory = widget.selectedCategory == "Semua Kategori" ||
          p["kategori"] == widget.selectedCategory;
      final namaLower = (p["nama_produk"] ?? '').toString().toLowerCase();
      final queryLower = widget.searchQuery.toLowerCase();
      return matchesCategory && namaLower.contains(queryLower);
    }).toList();

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filtered.length,
      itemBuilder: (context, i) {
        final p = filtered[i];
        final imgUrl = p['foto_produk'] as String?;

        return GestureDetector(
          onTap: () {
            // Hanya tambah ke cart jika stok > 0
            if ((p['stok'] ?? 0) > 0) {
              widget.onAddToCart({
                "name": p['nama_produk'] ?? '',
                "price": formatter.format(p['harga']),
                "stok": (p['stok'] ?? 0).toString(),
                "kategori": p['kategori'] ?? '',
                "img": imgUrl ?? '',
              });
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: 1,
                          child: imgUrl == null || imgUrl.isEmpty
                              ? Image.asset(
                                  'assets/images/placeholder.jpg',
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  imgUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Image.asset(
                                    'assets/images/placeholder.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        if (p['kategori'] != null)
                          Positioned(
                            top: 0,
                            left: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(217, 160, 91, 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                p['kategori'],
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    p['nama_produk'] ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      color: Color.fromRGBO(107, 79, 63, 1),
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    formatter.format(p['harga']),
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(198, 165, 128, 1),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "Stock : ${p['stok']} 🍪",
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Color.fromRGBO(217, 160, 91, 1),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }
}