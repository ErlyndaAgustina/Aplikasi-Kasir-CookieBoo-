import 'package:supabase_flutter/supabase_flutter.dart';

class ProdukService {
  final supabase = Supabase.instance.client;
  final String table = 'produk';

  // CREATE
  Future<Map<String, dynamic>?> tambahProduk({
    required String namaProduk,
    String? fotoProduk,
    required double harga,
    required int stok,
    int stokMinimum = 10,
    String? kategori,
  }) async {
    final response = await supabase.from(table).insert({
      'nama_produk': namaProduk,
      'foto_produk': fotoProduk,
      'harga': harga,
      'stok': stok,
      'stok_minimum': stokMinimum,
      'kategori': kategori,
    }).select().single();

    return response;
  }

  // READ
  Future<List<Map<String, dynamic>>> ambilSemuaProduk() async {
    final data = await supabase.from(table).select().order('created_at');
    return List<Map<String, dynamic>>.from(data);
  }

  // READ
  Future<Map<String, dynamic>?> ambilProdukById(String id) async {
    final data = await supabase.from(table).select().eq('id', id).single();
    return data;
  }

  // UPDATE
  Future<Map<String, dynamic>?> updateProduk({
    required String id,
    String? namaProduk,
    String? fotoProduk,
    double? harga,
    int? stok,
    int? stokMinimum,
    String? kategori,
  }) async {
    final response = await supabase
        .from(table)
        .update({
          if (namaProduk != null) 'nama_produk': namaProduk,
          if (fotoProduk != null) 'foto_produk': fotoProduk,
          if (harga != null) 'harga': harga,
          if (stok != null) 'stok': stok,
          if (stokMinimum != null) 'stok_minimum': stokMinimum,
          if (kategori != null) 'kategori': kategori,
        })
        .eq('id', id)
        .select()
        .single();

    return response;
  }

  // DELETE
  Future<bool> hapusProduk(String id) async {
    await supabase.from(table).delete().eq('id', id);
    return true;
  }
}
