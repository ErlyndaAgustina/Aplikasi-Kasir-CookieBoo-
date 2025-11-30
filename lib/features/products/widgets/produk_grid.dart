import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../CRUD/edit_produk.dart';
import 'package:intl/intl.dart';

class ProdukGrid extends StatefulWidget {
  final String selectedCategory;
  final String searchQuery;

  const ProdukGrid({
    super.key,
    required this.selectedCategory,
    this.searchQuery = '',
  });

  @override
  State<ProdukGrid> createState() => ProdukGridState();
}

class ProdukGridState extends State<ProdukGrid> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> produkList = [];
  bool isLoading = true;

  // internal searchQuery supaya aman
  String searchQueryInternal = '';

  @override
  void initState() {
    super.initState();
    searchQueryInternal = widget.searchQuery;
    loadProduk();
  }

  @override
  void didUpdateWidget(covariant ProdukGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    searchQueryInternal = widget.searchQuery;
  }

  Future<void> loadProduk() async {
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
      print('Error load produk: $e');
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final spacing = size.width * 0.03;
    final formatter = NumberFormat("#,###", "id_ID");

    final filtered = produkList.where((p) {
      final matchesCategory = widget.selectedCategory == "Semua Kategori" ||
          p["kategori"] == widget.selectedCategory;

      final namaProduk = (p["nama_produk"] ?? '').toString().toLowerCase();
      final query = searchQueryInternal.toLowerCase();

      return matchesCategory && namaProduk.contains(query);
    }).toList();

    if (isLoading) return const Center(child: CircularProgressIndicator());

    return MasonryGridView.count(
      crossAxisCount: size.width > 600 ? 3 : 2,
      mainAxisSpacing: spacing,
      crossAxisSpacing: spacing,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filtered.length,
      itemBuilder: (context, i) {
        final p = filtered[i];
        final imgUrl = p['foto_produk'] as String?;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(size.width * 0.05),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(size.width * 0.025),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(size.width * 0.03),
                  child: Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 1,
                        child: imgUrl == null || imgUrl.isEmpty
                            ? Image.asset('assets/images/placeholder.jpg', fit: BoxFit.cover)
                            : Image.network(imgUrl, fit: BoxFit.cover),
                      ),
                      if (p['kategori'] != null)
                        Positioned(
                          top: 0,
                          left: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.03,
                              vertical: size.width * 0.008,
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(217, 160, 91, 1),
                              borderRadius: BorderRadius.circular(size.width * 0.02),
                            ),
                            child: Text(
                              p['kategori'],
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: size.width * 0.03,
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
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                child: Text(
                  p['nama_produk'] ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w900,
                    fontSize: size.width * 0.038,
                    color: const Color.fromRGBO(107, 79, 63, 1),
                  ),
                ),
              ),
              SizedBox(height: size.width * 0.01),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                child: Text(
                  "Rp ${formatter.format(p['harga'])}",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: size.width * 0.035,
                    fontWeight: FontWeight.w700,
                    color: const Color.fromRGBO(198, 165, 128, 1),
                  ),
                ),
              ),
              SizedBox(height: size.width * 0.008),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                child: Text(
                  "Stock : ${p['stok']} 🍪",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: size.width * 0.03,
                    color: const Color.fromRGBO(217, 160, 91, 1),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: size.width * 0.025),

              Padding(
                padding: EdgeInsets.fromLTRB(
                  size.width * 0.03,
                  0,
                  size.width * 0.03,
                  size.width * 0.03,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => EditProdukPopup(data: p),
                          ).then((_) => loadProduk());
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: size.width * 0.02),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(246, 231, 212, 1),
                            borderRadius: BorderRadius.circular(size.width * 0.035),
                            border: Border.all(color: const Color.fromRGBO(228, 212, 196, 1), width: 2),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.edit, size: size.width * 0.035, color: const Color.fromRGBO(133, 131, 145, 1)),
                              SizedBox(width: size.width * 0.008),
                              Text("Edit",
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: size.width * 0.033,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(133, 131, 145, 1))),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: size.width * 0.02),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Hapus Produk"),
                              content: Text("Yakin ingin menghapus '${p["nama_produk"]}'?"),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    await supabase.from('produk').delete().eq('id', p['id']);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("${p["nama_produk"]} terhapus")),
                                    );
                                    loadProduk();
                                  },
                                  child: const Text("Hapus"),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: size.width * 0.02),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(246, 231, 212, 1),
                            borderRadius: BorderRadius.circular(size.width * 0.035),
                            border: Border.all(color: const Color.fromRGBO(228, 212, 196, 1), width: 2),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.delete_outline, size: size.width * 0.035, color: const Color.fromRGBO(133, 131, 145, 1)),
                              SizedBox(width: size.width * 0.008),
                              Text("Hapus",
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: size.width * 0.033,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(133, 131, 145, 1))),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
