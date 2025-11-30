import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
          color: const Color.fromRGBO(198, 165, 128, 1),
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
          const ProdukSearchField(),
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
            onAddToCart: widget.onAddToCart,
          ),
        ],
      ),
    );
  }
}

class ProdukSearchField extends StatelessWidget {
  const ProdukSearchField({super.key});

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
      child: const TextField(
        decoration: InputDecoration(
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

class ProdukGrid extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<Map<String, String>> onAddToCart;

  const ProdukGrid({
    super.key,
    required this.selectedCategory,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> dummy = [
      {
        "name": "Monster Cookies",
        "price": "Rp 45.000",
        "stok": "50",
        "kategori": "Premium",
        "img": "monster_cookies.jpg",
      },
      {
        "name": "Choco Chip Cookies",
        "price": "Rp 19.000",
        "stok": "20",
        "kategori": "Klasik",
        "img": "choco_chips.jpg",
      },
      {
        "name": "Matcha Lotus",
        "price": "Rp 23.000",
        "stok": "12",
        "kategori": "Premium",
        "img": "matcha_lotus.jpg",
      },
      {
        "name": "Red Velvet Oreo",
        "price": "Rp 20.000",
        "stok": "5",
        "kategori": "Premium",
        "img": "red_velvet.jpg",
      },
    ];

    final List<Map<String, String>> filtered =
        selectedCategory == "Semua Kategori"
            ? dummy
            : dummy
                .where((e) => e["kategori"] == selectedCategory)
                .toList();

    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filtered.length,
      itemBuilder: (context, i) {
        final p = filtered[i];

        return GestureDetector(
          onTap: () => onAddToCart(p),
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
                          child: Image.asset(
                            'assets/images/${p["img"]}',
                            fit: BoxFit.cover,
                          ),
                        ),
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
                              p["kategori"]!,
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
                    p["name"]!,
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
                    p["price"]!,
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
                    "Stock : ${p["stok"]} 🍪",
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
