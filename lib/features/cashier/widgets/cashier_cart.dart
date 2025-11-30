import 'package:flutter/material.dart';

import 'struk.dart';

class CartItem {
  final String name;
  final int quantity;
  final int price;

  CartItem({required this.name, required this.quantity, required this.price});

  int get total => price * quantity;
}

class CashierCart extends StatelessWidget {
  final List<CartItem> items;
  final Function(int index) onIncrease;
  final Function(int index) onDecrease;
  final Function(int index) onDelete;
  final String paymentMethod;
  final Function(String method) onSelectPayment;
  final VoidCallback onConfirm;
  final double discountRate;

  const CashierCart({
    super.key,
    required this.items,
    required this.onIncrease,
    required this.onDecrease,
    required this.onDelete,
    required this.paymentMethod,
    required this.onSelectPayment,
    required this.onConfirm,
    required this.discountRate,
  });

  @override
  Widget build(BuildContext context) {
    final subtotal = items.fold<int>(0, (sum, item) => sum + item.total);

    final discountValue = (subtotal * discountRate).round();

    final afterDiscount = subtotal - discountValue;

    final tax = (afterDiscount * 0.10).round();

    final total = afterDiscount + tax;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Color.fromRGBO(254, 243, 199, 1), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.shopping_cart_outlined,
                size: 20,
                color: Color.fromRGBO(139, 111, 71, 1),
              ),
              SizedBox(width: 6),
              Text(
                "Keranjang Belanja",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Color.fromRGBO(139, 111, 71, 1),
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (items.isEmpty)
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    "Keranjang Kosong",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(107, 79, 63, 1),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),

          Column(
            children: List.generate(items.length, (index) {
              final item = items[index];
              return Container(
                margin: EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(246, 231, 212, 1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            color: Color.fromRGBO(107, 79, 63, 1),
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "Rp ${item.price}",
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(217, 160, 91, 1),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 13),

                    Row(
                      children: [
                        _qtyButton(Icons.remove, () => onDecrease(index)),
                        const SizedBox(width: 10),
                        Text(
                          "${item.quantity}",
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Color.fromRGBO(107, 79, 63, 1),
                          ),
                        ),
                        const SizedBox(width: 10),
                        _qtyButton(Icons.add, () => onIncrease(index)),
                        const Spacer(),
                        Text(
                          "Rp ${item.total}",
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            color: Color.fromRGBO(198, 165, 128, 1),
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    GestureDetector(
                      onTap: () => onDelete(index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Color.fromRGBO(212, 24, 61, 1),
                            width: 1,
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.delete_outline,
                              color: Color.fromRGBO(212, 24, 61, 1),
                              size: 18,
                            ),
                            SizedBox(width: 5),
                            Text(
                              "Hapus",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color.fromRGBO(212, 24, 61, 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),

          const SizedBox(height: 8),
          Divider(color: Color.fromRGBO(255, 227, 191, 1), thickness: 1.5),
          const SizedBox(height: 8),

          _priceRow("Subtotal", subtotal),
          _priceRow(
            "Diskon (${(discountRate * 100).toStringAsFixed(0)}%)",
            -discountValue,
          ),
          _priceRow("Tax (10%)", tax),
          Divider(color: Color.fromRGBO(255, 227, 191, 1), thickness: 1.5),
          _priceRow("Total", total, bold: true),

          const SizedBox(height: 20),
          const Text(
            "Metode Pembayaran",
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Color.fromRGBO(107, 79, 63, 1),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              _paymentButton(
                label: "Cash",
                icon: Icons.payments_outlined,
                active: paymentMethod == "cash",
                onTap: () => onSelectPayment("cash"),
              ),
              const SizedBox(width: 10),
              _paymentButton(
                label: "Non-Cash",
                icon: Icons.credit_card_outlined,
                active: paymentMethod == "non-cash",
                onTap: () => onSelectPayment("non-cash"),
              ),
            ],
          ),

          const SizedBox(height: 22),

          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                showPaymentReceipt(context); 
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(217, 160, 91, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                "Konfirmasi Transaksi",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Color.fromRGBO(229, 167, 154, 0.68),
            width: 1.5,
          ),
        ),
        child: Icon(icon, size: 15),
      ),
    );
  }

  Widget _paymentButton({
    required String label,
    required IconData icon,
    required bool active,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: active
                ? const Color.fromRGBO(253, 243, 241, 1)
                : Colors.white,
            border: Border.all(
              color: const Color.fromRGBO(229, 167, 154, 0.68),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Icon(icon, size: 20, color: const Color.fromRGBO(107, 79, 63, 1)),
              const SizedBox(height: 3),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color.fromRGBO(107, 79, 63, 1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _priceRow(String label, int value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: bold ? FontWeight.w900 : FontWeight.w700,
              color: value < 0
                  ? const Color.fromRGBO(203, 68, 50, 1)
                  : const Color.fromRGBO(107, 79, 63, 1),
            ),
          ),
          Text(
            (value < 0) ? "- Rp ${value.abs()}" : "Rp $value",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: bold ? FontWeight.w900 : FontWeight.w700,
              color: value < 0
                  ? const Color.fromRGBO(203, 68, 50, 1)
                  : const Color.fromRGBO(107, 79, 63, 1),
            ),
          ),
        ],
      ),
    );
  }
}
