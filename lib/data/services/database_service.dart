import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getData(String table) async {
    final res = await supabase.from(table).select();
    return res;
  }

  Future<void> insertData(String table, Map<String, dynamic> data) async {
    await supabase.from(table).insert(data);
  }

  Future<void> updateData(String table, Map<String, dynamic> data, String id) async {
    await supabase.from(table).update(data).match({'id': id});
  }

  Future<void> deleteData(String table, String id) async {
    await supabase.from(table).delete().match({'id': id});
  }
}
