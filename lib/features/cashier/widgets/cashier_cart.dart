import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'struk.dart';

class CartItem {
  final String name;
  final int quantity;
  final String priceDisplay;
  final int priceValue;
  final int availableStock;

  CartItem({
    required this.name,
    required this.quantity,
    required this.priceDisplay,
    required this.priceValue,
    int? availableStock,
  }) : availableStock = availableStock ?? 0;

  int get total => priceValue * quantity;
}


// Helper untuk parse harga dari string "Rp xx.xxx" ke int
int parsePriceString(String priceStr) {
  return int.tryParse(priceStr.replaceAll('Rp', '').replaceAll('.', '').trim()) ?? 0;
}

class CashierCart extends StatefulWidget {
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
  State<CashierCart> createState() => _CashierCartState();
}

class _CashierCartState extends State<CashierCart> {
  final TextEditingController _cashController = TextEditingController();
  int _cashAmount = 0;

  @override
  void dispose() {
    _cashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final subtotal = widget.items.fold<int>(0, (sum, item) => sum + item.total);

    final discountValue = (subtotal * widget.discountRate).round();

    final afterDiscount = subtotal - discountValue;

    final tax = (afterDiscount * 0.10).round();

    final total = afterDiscount + tax;

    final change = widget.paymentMethod == "cash" ? (_cashAmount - total) : 0;

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

          if (widget.items.isEmpty)
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
            children: List.generate(widget.items.length, (index) {
              final item = widget.items[index];
              final canIncrease = item.quantity < item.availableStock;
              
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
                        Expanded(
                          child: Text(
                            item.name,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              color: Color.fromRGBO(107, 79, 63, 1),
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          item.priceDisplay,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(217, 160, 91, 1),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Indikator stok tersedia
                    Text(
                      "Stok tersedia: ${item.availableStock} Box",
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(124, 124, 126, 1),
                      ),
                    ),
                    const SizedBox(height: 13),

                    Row(
                      children: [
                        _qtyButton(Icons.remove, () => widget.onDecrease(index), enabled: true),
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
                        _qtyButton(
                          Icons.add, 
                          canIncrease ? () => widget.onIncrease(index) : () {},
                          enabled: canIncrease,
                        ),
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
                    
                    // Warning jika stok maksimal
                    if (!canIncrease) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(245, 158, 11, 0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color.fromRGBO(245, 158, 11, 1),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.info_outline,
                              size: 14,
                              color: Color.fromRGBO(245, 158, 11, 1),
                            ),
                            SizedBox(width: 5),
                            Text(
                              "Stok maksimal tercapai",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(245, 158, 11, 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    
                    const SizedBox(height: 10),

                    GestureDetector(
                      onTap: () => widget.onDelete(index),
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
            "Diskon (${(widget.discountRate * 100).toStringAsFixed(0)}%)",
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
                active: widget.paymentMethod == "cash",
                onTap: () {
                  widget.onSelectPayment("cash");
                  _cashController.clear();
                  setState(() => _cashAmount = 0);
                },
              ),
              const SizedBox(width: 10),
              _paymentButton(
                label: "Non-Cash",
                icon: Icons.credit_card_outlined,
                active: widget.paymentMethod == "non-cash",
                onTap: () {
                  widget.onSelectPayment("non-cash");
                  _cashController.clear();
                  setState(() => _cashAmount = 0);
                },
              ),
            ],
          ),

          // Input jumlah uang bayar jika metode cash
          if (widget.paymentMethod == "cash") ...[
            const SizedBox(height: 16),
            const Text(
              "Jumlah Uang Dibayar",
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Color.fromRGBO(107, 79, 63, 1),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _cashController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) {
                setState(() {
                  _cashAmount = int.tryParse(value) ?? 0;
                });
              },
              decoration: InputDecoration(
                hintText: "Masukkan jumlah uang",
                hintStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  color: Color.fromRGBO(124, 124, 126, 1),
                ),
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 16, top: 12),
                  child: Text(
                    "Rp",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(107, 79, 63, 1),
                    ),
                  ),
                ),
                filled: true,
                fillColor: const Color.fromRGBO(246, 231, 212, 1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(229, 167, 154, 0.68),
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(229, 167, 154, 0.68),
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(217, 160, 91, 1),
                    width: 2,
                  ),
                ),
              ),
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(107, 79, 63, 1),
              ),
            ),
            const SizedBox(height: 12),
            _priceRow("Kembalian", change, bold: true),
          ],

          const SizedBox(height: 22),

          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              onPressed: widget.items.isEmpty
                  ? null
                  : (widget.paymentMethod == "cash" && _cashAmount < total)
                      ? null
                      : widget.onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(217, 160, 91, 1),
                disabledBackgroundColor: const Color.fromRGBO(198, 165, 128, 0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                widget.paymentMethod == "cash" && _cashAmount < total
                    ? "Uang Tidak Cukup"
                    : "Konfirmasi Transaksi",
                style: const TextStyle(
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

  Widget _qtyButton(IconData icon, VoidCallback onTap, {required bool enabled}) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: enabled 
                ? Color.fromRGBO(229, 167, 154, 0.68)
                : Color.fromRGBO(229, 167, 154, 0.3),
            width: 1.5,
          ),
          color: enabled ? Colors.transparent : Colors.grey.withOpacity(0.1),
        ),
        child: Icon(
          icon, 
          size: 15,
          color: enabled 
              ? Color.fromRGBO(107, 79, 63, 1)
              : Color.fromRGBO(107, 79, 63, 0.3),
        ),
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