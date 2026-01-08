import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class CustomerInfoCard extends StatefulWidget {
  final ValueChanged<double> onDiscountChanged;
  final ValueChanged<String> onCustomerNameChanged;
  final ValueChanged<String?> onMembershipChanged;

  const CustomerInfoCard({
    super.key,
    required this.onDiscountChanged,
    required this.onCustomerNameChanged,
    required this.onMembershipChanged,
  });

  @override
  State<CustomerInfoCard> createState() => _CustomerInfoCardState();
}

class _CustomerInfoCardState extends State<CustomerInfoCard> {
  bool isMembership = true;
  String? selectedMemberId;
  List<Map<String, dynamic>> memberList = [];
  bool isLoadingMembers = true;
  String _currentQueueNumber = "001";
  bool _isLoadingQueue = true;

  final TextEditingController _nonMemberNameController =
      TextEditingController();

  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID');
    _loadMembers();
    _loadTodayQueueNumber();

    supabase
        .channel('public:pelanggan')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'pelanggan',
          callback: (payload) {
            if (mounted) {
              _loadMembers();
            }
          },
        )
        .subscribe();
  }

  @override
  void dispose() {
    _nonMemberNameController.dispose();
    supabase.removeAllChannels();
    super.dispose();
  }

  Future<void> _loadMembers() async {
    if (!mounted) return;
    setState(() => isLoadingMembers = true);

    try {
      final response = await supabase
          .from('pelanggan')
          .select('id, nama, membership')
          .inFilter('membership', ['silver', 'gold', 'platinum'])
          .order('nama', ascending: true);

      if (mounted) {
        setState(() {
          memberList = List<Map<String, dynamic>>.from(response);
          isLoadingMembers = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading pelanggan: $e');
      if (mounted) setState(() => isLoadingMembers = false);
    }
  }

  String _getMembershipLabel(String? membership) {
    switch (membership) {
      case 'platinum':
        return "Platinum (20% diskon)";
      case 'gold':
        return "Gold (15% diskon)";
      case 'silver':
        return "Silver (10% diskon)";
      default:
        return "";
    }
  }

  double _getDiscountRate(String? membership) {
    switch (membership) {
      case 'platinum':
        return 0.20;
      case 'gold':
        return 0.15;
      case 'silver':
        return 0.10;
      default:
        return 0.0;
    }
  }

  void _applyDiscount(String? memberId) {
    if (memberId == null) {
      widget.onDiscountChanged(0.0);
      return;
    }

    final selected = memberList.firstWhere(
      (m) => m['id'] == memberId,
      orElse: () => <String, dynamic>{},
    );

    final membership = selected['membership'] as String?;
    final rate = _getDiscountRate(membership);
    widget.onDiscountChanged(rate);
  }

  Future<void> _loadTodayQueueNumber() async {
    try {
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

      final response = await supabase
          .from('transaksi')
          .select('no_antrian, tanggal_waktu')
          .gte('tanggal_waktu', '$today 00:00:00')
          .lte('tanggal_waktu', '$today 23:59:59')
          .order('tanggal_waktu', ascending: false)
          .limit(1)
          .maybeSingle();

      if (!mounted) return;

      setState(() {
        final noAntrian = response?['no_antrian'];

        if (noAntrian == null || noAntrian.toString().isEmpty) {
          _currentQueueNumber = "001";
        } else {
          _currentQueueNumber = noAntrian.toString();
        }

        _isLoadingQueue = false;
      });
    } catch (e) {
      debugPrint('Error loading queue number: $e');
      if (mounted) {
        setState(() {
          _currentQueueNumber = "001";
          _isLoadingQueue = false;
        });
      }
    }
  }

  Future<String?> saveNonMemberToSupabase() async {
    final name = _nonMemberNameController.text.trim();
    if (name.isEmpty) return null;

    try {
      final response = await supabase
          .from('pelanggan')
          .insert({'nama': name, 'membership': 'non_member'})
          .select('id');

      return response[0]['id'] as String?;
    } catch (e) {
      debugPrint('Error saving non-member: $e');
      return null;
    }
  }

  String _getCurrentDateTimeInfo() {
    final now = DateTime.now();
    final dayFormat = DateFormat('EEEE', 'id_ID');
    final dateFormat = DateFormat('dd MMM yyyy', 'id_ID');
    final timeFormat = DateFormat('HH:mm');

    final day = dayFormat.format(now);
    final date = dateFormat.format(now);
    final time = timeFormat.format(now);

    final queueText = _isLoadingQueue ? "…" : _currentQueueNumber;

    return "$day, $date • $time • Antrian: $queueText";
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final horizontalPadding = width < 400 ? 12.0 : 16.0;
    final contentPadding = width < 400 ? 10.0 : 12.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(horizontalPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color.fromRGBO(254, 243, 199, 1),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(6, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Informasi Pelanggan",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Color.fromRGBO(139, 111, 71, 1),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            _getCurrentDateTimeInfo(),
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              color: Color.fromRGBO(107, 79, 63, 1),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(contentPadding),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(246, 231, 212, 1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: [
                    _buildTabButton(
                      label: "Membership",
                      active: isMembership,
                      onTap: () {
                        setState(() {
                          isMembership = true;
                        });
                        _applyDiscount(selectedMemberId);
                      },
                    ),
                    _buildTabButton(
                      label: "Non-Membership",
                      active: !isMembership,
                      onTap: () {
                        setState(() {
                          isMembership = false;
                          selectedMemberId = null;
                          _nonMemberNameController.clear();
                        });
                        widget.onDiscountChanged(0.0);
                        widget.onCustomerNameChanged("-");
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                if (isMembership)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: const Color.fromRGBO(198, 165, 128, 1),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedMemberId,
                        hint: const Text(
                          "Pilih pelanggan membership...",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Color.fromRGBO(107, 79, 63, 1),
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: isLoadingMembers
                            ? [
                                const DropdownMenuItem(
                                  value: null,
                                  child: Text("Memuat pelanggan..."),
                                ),
                              ]
                            : memberList.map((member) {
                                final nama = member['nama'] as String;
                                final membership =
                                    member['membership'] as String;
                                final label = _getMembershipLabel(membership);
                                return DropdownMenuItem(
                                  value: member['id'] as String,
                                  child: Text(
                                    "$nama - $label",
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                        onChanged: (val) {
                          setState(() => selectedMemberId = val);
                          _applyDiscount(val);

                          final selected = memberList.firstWhere(
                            (m) => m['id'] == val,
                            orElse: () => {},
                          );

                          widget.onMembershipChanged(selected['id'] as String?);
                          widget.onCustomerNameChanged(
                            selected['nama'] as String? ?? "-",
                          );
                        },
                      ),
                    ),
                  ),

                if (!isMembership)
                  TextField(
                    controller: _nonMemberNameController,
                    onChanged: (value) {
                      widget.onCustomerNameChanged(
                        value.trim().isEmpty ? "-" : value.trim(),
                      );
                    },
                    decoration: InputDecoration(
                      hintText: "Tambahkan nama pelanggan...",
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(198, 165, 128, 1),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(199, 164, 124, 1),
                          width: 1.5,
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
  }

  Widget _buildTabButton({
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
        decoration: BoxDecoration(
          color: active
              ? const Color.fromRGBO(217, 160, 91, 1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: active ? Colors.white : const Color.fromRGBO(107, 79, 63, 1),
          ),
        ),
      ),
    );
  }
}
