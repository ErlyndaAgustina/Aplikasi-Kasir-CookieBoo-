import 'package:flutter/material.dart';
import '../sidebar/sidebar_widget.dart';
import '../products/pages/produk_page.dart';
import '../customers/customers_page.dart';
import '../cashier/cashier_page.dart';
import '../stocks/stocks_page.dart';
import '../laporan/laporan_page.dart';
import '../auth/registrasi/registrasi_page.dart';
import '../dashboard/dashboard_page.dart';

class SidebarPage extends StatefulWidget {
  const SidebarPage({super.key});

  @override
  State<SidebarPage> createState() => _SidebarPageState();
}

class _SidebarPageState extends State<SidebarPage> {
  bool isOpen = false;
  int currentIndex = 0;

  void openMenu() => setState(() => isOpen = true);
  void closeMenu() => setState(() => isOpen = false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: currentIndex,
            children: [
              DashboardPage(onMenuTap: openMenu),
              ProdukPage(onMenuTap: openMenu),
              CustomersPage(onMenuTap: openMenu),
              CashierPage(onMenuTap: openMenu),
              StocksPage(onMenuTap: openMenu),
              LaporanPage(onMenuTap: openMenu),
              RegistrasiPage(onMenuTap: openMenu),
            ],
          ),

          AnimatedPositioned(
            duration: const Duration(milliseconds: 260),
            left: isOpen ? 0 : -260,
            top: 0,
            bottom: 0,
            child: SidebarWidget(
              currentIndex: currentIndex,
              onClose: closeMenu,
              onMenuSelected: (int index) {
                setState(() {
                  currentIndex = index;
                  isOpen = false;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
