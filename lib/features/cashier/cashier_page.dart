import 'package:flutter/material.dart';
import '../cashier/widgets/cashier_header.dart';
import '../cashier/widgets/customer_info_card.dart';
import '../cashier/widgets/cashier_produk.dart';
import '../cashier/widgets/cashier_cart.dart';

class CashierPage extends StatefulWidget {
  final VoidCallback onMenuTap;

  const CashierPage({super.key, required this.onMenuTap});

  @override
  State<CashierPage> createState() => _CashierPageState();
}

class _CashierPageState extends State<CashierPage> {
  List<CartItem> items = [];

  String paymentMethod = "cash";

  double discountRate = 0.0;

  void _updateDiscountRate(double value) {
    setState(() {
      discountRate = value.clamp(0.0, 1.0);
    });
  }

  void _handleAddToCart(Map<String, String> product) {
    final name = product["name"] ?? "";
    final priceText = product["price"] ?? "0";

    final clean = priceText
        .replaceAll("Rp", "")
        .replaceAll(".", "")
        .replaceAll(" ", "");

    final price = int.tryParse(clean) ?? 0;

    if (name.isEmpty || price <= 0) return;

    setState(() {
      final index = items.indexWhere((item) => item.name == name);
      if (index == -1) {
        items.add(CartItem(name: name, quantity: 1, price: price));
      } else {
        final item = items[index];
        items[index] = CartItem(
          name: item.name,
          quantity: item.quantity + 1,
          price: item.price,
        );
      }
    });
  }

  void _onIncrease(int index) {
    setState(() {
      final item = items[index];
      items[index] = CartItem(
        name: item.name,
        quantity: item.quantity + 1,
        price: item.price,
      );
    });
  }

  void _onDecrease(int index) {
    setState(() {
      final item = items[index];
      if (item.quantity > 1) {
        items[index] = CartItem(
          name: item.name,
          quantity: item.quantity - 1,
          price: item.price,
        );
      } else {
        items.removeAt(index);
      }
    });
  }

  void _onDelete(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  void _onSelectPayment(String method) {
    setState(() {
      paymentMethod = method;
    });
  }

  void _onConfirm() {
    debugPrint("Konfirmasi transaksi:");
    debugPrint("Total item: ${items.length}");
    debugPrint("Diskon: ${(discountRate * 100).toStringAsFixed(0)}%");
    debugPrint("Metode bayar: $paymentMethod");
  }

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
              CashierHeader(onMenuTap: widget.onMenuTap),

              const SizedBox(height: 18),

              CustomerInfoCard(
                onDiscountChanged: _updateDiscountRate,
              ),

              const SizedBox(height: 18),

              CashierProduk(
                onAddToCart: _handleAddToCart,
              ),

              const SizedBox(height: 18),

              CashierCart(
                items: items,
                onIncrease: _onIncrease,
                onDecrease: _onDecrease,
                onDelete: _onDelete,
                paymentMethod: paymentMethod,
                onSelectPayment: _onSelectPayment,
                onConfirm: _onConfirm,
                discountRate: discountRate,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
