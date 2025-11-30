import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BestsellerSection extends StatefulWidget {
  const BestsellerSection({super.key});

  @override
  State<BestsellerSection> createState() => _BestsellerSectionState();
}

class _BestsellerSectionState extends State<BestsellerSection> {
  List<Map<String, dynamic>> bestseller = [];
  late final SupabaseClient supabase;

  @override
  void initState() {
    super.initState();
    supabase = Supabase.instance.client;
    _loadBestseller();
    _setupRealtime();
  }

  Future<void> _loadBestseller() async {
    try {
      final response = await supabase
          .from('produk')
          .select('nama_produk, foto_produk, terjual')
          .order('terjual', ascending: false)
          .limit(3);

      if (!mounted) return;

      setState(() {
        bestseller = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print('Error load bestseller: $e');
    }
  }

  void _setupRealtime() {
    supabase.from('produk').stream(primaryKey: ['id']).listen((event) {
      _loadBestseller();
    });
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
          const Text(
            "Produk Terlaris 🔥",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 14),

          if (bestseller.isEmpty)
            const Center(child: CircularProgressIndicator(color: Colors.white))
          else
            for (int i = 0; i < bestseller.length; i++)
              _item(
                bestseller[i]['nama_produk'] ?? 'Unknown',
                "${bestseller[i]['terjual'] ?? 0} Sold",
                "#${i + 1}",
                bestseller[i]['foto_produk'],
              ),
        ],
      ),
    );
  }

  Widget _item(String name, String sold, String rank, String? imgUrl) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color.fromRGBO(229, 167, 154, 0.68),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: imgUrl == null || imgUrl.isEmpty
                ? Image.asset(
                    'assets/images/placeholder.jpg',
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    imgUrl,
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 52,
                        height: 52,
                        color: Colors.brown[100],
                        child: const Icon(Icons.cookie, color: Colors.brown),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: 52,
                        height: 52,
                        color: Colors.brown[50],
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    },
                  ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color.fromRGBO(107, 79, 63, 1),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 2),
                Text(
                  sold,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color.fromRGBO(198, 165, 128, 1),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          SizedBox(
            width: 44,
            child: Text(
              rank,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color.fromRGBO(217, 160, 91, 1),
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
