import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TierCard extends StatelessWidget {
  const TierCard({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(22)),
        border: Border.all(
          color: const Color.fromRGBO(254, 243, 199, 1),
          width: 2,
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(198, 165, 128, 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.star_border,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Member Aktif",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Color.fromRGBO(139, 111, 71, 1),
                      ),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Total pelanggan dengan status membership",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(198, 165, 128, 1),
                      ),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          FutureBuilder<Map<String, int>>(
            future: _fetchMemberCounts(supabase),
            builder: (context, snapshot) {
              final platinum = snapshot.data?['platinum']?.toString() ?? "00";
              final gold = snapshot.data?['gold']?.toString() ?? "00";
              final silver = snapshot.data?['silver']?.toString() ?? "00";

              return Row(
                children: [
                  Expanded(
                    child: _TierBox(
                      color: const Color.fromRGBO(219, 234, 254, 1),
                      icon: Icons.workspace_premium_rounded,
                      count: platinum,
                      label: "Platinum",
                      iconColor: const Color.fromRGBO(62, 132, 246, 1),
                      textColor: const Color.fromRGBO(30, 64, 175, 1),
                      borderColor: const Color.fromRGBO(189, 214, 252, 1),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TierBox(
                      color: const Color.fromRGBO(254, 243, 199, 1),
                      icon: Icons.military_tech_rounded,
                      count: gold,
                      label: "Gold",
                      iconColor: const Color.fromRGBO(245, 158, 11, 1),
                      textColor: const Color.fromRGBO(146, 64, 14, 1),
                      borderColor: const Color.fromRGBO(252, 227, 164, 1),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TierBox(
                      color: const Color.fromRGBO(241, 245, 249, 1),
                      icon: Icons.emoji_events_rounded,
                      count: silver,
                      label: "Silver",
                      iconColor: const Color.fromRGBO(100, 116, 139, 1),
                      textColor: const Color.fromRGBO(71, 85, 105, 1),
                      borderColor: const Color.fromRGBO(215, 221, 228, 1),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Future<Map<String, int>> _fetchMemberCounts(SupabaseClient client) async {
    try {
      final response = await client
          .from('pelanggan')
          .select('membership')
          .inFilter('membership', ['platinum', 'gold', 'silver']);

      final counts = <String, int>{'platinum': 0, 'gold': 0, 'silver': 0};

      for (final row in response as List) {
        final membership =
            (row as Map<String, dynamic>)['membership'] as String?;
        if (membership == 'platinum')
          counts['platinum'] = counts['platinum']! + 1;
        if (membership == 'gold') counts['gold'] = counts['gold']! + 1;
        if (membership == 'silver') counts['silver'] = counts['silver']! + 1;
      }

      return counts;
    } catch (e) {
      return {'platinum': 0, 'gold': 0, 'silver': 0};
    }
  }
}

class _TierBox extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String count;
  final String label;
  final Color iconColor;
  final Color textColor;
  final Color borderColor;

  const _TierBox({
    required this.color,
    required this.icon,
    required this.count,
    required this.label,
    required this.iconColor,
    required this.textColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: borderColor, width: 1.3),
      ),
      child: Column(
        children: [
          Icon(icon, size: 28, color: iconColor),
          const SizedBox(height: 2),
          Text(
            count,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: textColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
