import 'package:flutter/material.dart';
import 'widgets/customer_header.dart';
import 'widgets/pelanggan_tab.dart';
import 'widgets/search_customer.dart';
import 'widgets/pelanggan_hari_ini/card_pesanan_hari_ini.dart';
import 'widgets/pelanggan_hari_ini/member_order_list.dart';
import 'widgets/pelanggan_hari_ini/non_member_order.dart';
import 'widgets/member_tier/tier_card.dart';
import 'widgets/member_tier/platinum_card.dart';
import 'widgets/member_tier/gold_card.dart';
import 'widgets/member_tier/silver_card.dart';

class CustomersPage extends StatefulWidget {
  final VoidCallback onMenuTap;

  const CustomersPage({super.key, required this.onMenuTap});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(246, 231, 212, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PelangganHeader(
                onTambahMember: () {},
                onMenuTap: widget.onMenuTap,
              ),

              const SizedBox(height: 18),

              PelangganTab(
                onChanged: (index) {
                  setState(() => selectedTab = index);
                },
              ),

              const SizedBox(height: 18),

              if (selectedTab == 0)
                _buildPelangganHariIni()
              else
                _buildMemberTier(),
            ],
          ),
        ),
      ),
    );
  }

  // ==================================================
  //                UI TAB 1 – PELANGGAN HARI INI
  // ==================================================
  Widget _buildPelangganHariIni() {
    return Column(
      children: [
        const PelangganSearchField(),

        const SizedBox(height: 12),

        PesananHariIniCard(),

        const SizedBox(height: 12),

        const MemberOrderList(),

        const SizedBox(height: 12),

        NonMemberOrders(),
      ],
    );
  }

  // ==================================================
  //                UI TAB 2 – MEMBER TIER
  // ==================================================
  Widget _buildMemberTier() {
    return Column(
      children: [
        const PelangganSearchField(),

        const SizedBox(height: 12),

        TierCard(),

        const SizedBox(height: 20),

        PlatinumMemberCard(),

        const SizedBox(height: 20),

        GoldMemberCard(),

        const SizedBox(height: 20),

        SilverMemberCard(),
      ],
    );
  }
}
