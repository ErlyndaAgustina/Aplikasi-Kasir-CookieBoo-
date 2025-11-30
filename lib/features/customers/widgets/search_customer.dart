import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/CRUD/detail_pelanggan.dart';

class PelangganSearchField extends StatefulWidget {
  const PelangganSearchField({super.key});

  @override
  State<PelangganSearchField> createState() => _PelangganSearchFieldState();
}

class _PelangganSearchFieldState extends State<PelangganSearchField> {
  final TextEditingController _controller = TextEditingController();
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged() async {
    final query = _controller.text.trim();
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await supabase
          .from('pelanggan')
          .select('id, nama, email, nomor_tlpn, membership')
          .or(
            'nama.ilike.%$query%,email.ilike.%$query%,nomor_tlpn.ilike.%$query%',
          )
          .limit(10)
          .order('nama');

      setState(() {
        _searchResults = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      debugPrint('Error search pelanggan: $e');
      setState(() => _searchResults = []);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Color _getMembershipColor(String? membership) {
    switch (membership?.toLowerCase()) {
      case 'platinum':
        return const Color.fromRGBO(62, 129, 237, 1);
      case 'gold':
        return const Color.fromRGBO(245, 158, 11, 1);
      case 'silver':
        return const Color.fromRGBO(100, 116, 139, 1);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: const Color.fromRGBO(198, 165, 128, 1),
              width: 1,
            ),
          ),
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.search,
                color: Color.fromRGBO(198, 165, 128, 1),
              ),
              hintText: "Cari nama, email, atau telepon...",
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
        ),

        if (_isLoading)
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          )
        else if (_searchResults.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 8),
            constraints: const BoxConstraints(maxHeight: 300),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              shrinkWrap: true,
              itemCount: _searchResults.length,
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                color: Color.fromRGBO(249, 216, 208, 1),
              ),
              itemBuilder: (context, index) {
                final pelanggan = _searchResults[index];
                final initials = pelanggan['nama']
                    .toString()
                    .split(' ')
                    .where((s) => s.isNotEmpty)
                    .take(2)
                    .map((s) => s[0].toUpperCase())
                    .join();

                return ListTile(
                  onTap: () {
                    _controller.clear();
                    setState(() => _searchResults = []);
                    showDialog(
                      context: context,
                      builder: (_) => DetailPelangganPopup(
                        pelangganId: pelanggan['id'].toString(),
                      ),
                    );
                  },
                  leading: CircleAvatar(
                    radius: 18,
                    backgroundColor: _getMembershipColor(
                      pelanggan['membership'],
                    ),
                    child: Text(
                      initials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  title: Text(
                    pelanggan['nama'] ?? 'Tanpa Nama',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text(
                    pelanggan['email'] ?? pelanggan['nomor_tlpn'] ?? '-',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getMembershipColor(
                        pelanggan['membership'],
                      ).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _getMembershipColor(pelanggan['membership']),
                      ),
                    ),
                    child: Text(
                      pelanggan['membership']?.toString().toTitleCase() ??
                          'Non Member',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: _getMembershipColor(pelanggan['membership']),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

extension StringExtension on String {
  String toTitleCase() {
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
}
