import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/cart_item.dart';

void showPaymentReceipt(
  BuildContext context, {
  required List<CartItem> items,
  required double discountRate,
  required String paymentMethod,
  required String customerName,
  String? customerMembership,
  required int paidAmount,
  required int changeAmount,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (context) {
      return PaymentReceiptPopup(
        items: items,
        discountRate: discountRate,
        paymentMethod: paymentMethod,
        customerName: customerName,
        customerMembership: customerMembership,
        paidAmount: paidAmount,
        changeAmount: changeAmount,
      );
    },
  );
}

class PaymentReceiptPopup extends StatelessWidget {
  final List<CartItem> items;
  final double discountRate;
  final String paymentMethod;
  final String customerName;
  final String? customerMembership;
  final int paidAmount;
  final int changeAmount;

  const PaymentReceiptPopup({
  super.key,
  required this.items,
  required this.discountRate,
  required this.paymentMethod,
  required this.customerName,
  this.customerMembership,
  required this.paidAmount,
  required this.changeAmount,
});


  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final maxHeight = media.size.height * 0.9;

    final currency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    // Hitung nilai transaksi
    final subtotal = items.fold<int>(0, (sum, item) => sum + item.total);
    final discountValue = (subtotal * discountRate).round();
    final afterDiscount = subtotal - discountValue;
    final tax = (afterDiscount * 0.10).round();
    final total = afterDiscount + tax;
    final now = DateTime.now();
    final dateFormat = DateFormat('dd MMM yyyy, HH.mm', 'id_ID');
    final transactionId =
        "INV-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-${(items.length + 1).toString().padLeft(3, '0')}";
    const queueNumber = "001";

    Widget? membershipBadge;
    if (customerMembership != null && customerMembership != 'non_member') {
      final String membership = customerMembership!;

      final String tierDisplay =
          membership[0].toUpperCase() + membership.substring(1);
      final bool isBlueBadge = membership == 'platinum' || membership == 'gold';

      membershipBadge = Row(
        children: [
          _badge("Membership"),
          const SizedBox(width: 6),
          _badge(tierDisplay, isBlue: isBlueBadge),
        ],
      );
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 12),

                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, size: 22),
                  ),
                ),

                const SizedBox(height: 6),

                Column(
                  children: [
                    Image.asset(
                      "assets/images/logo_cookiesboo.png",
                      width: 300,
                    ),
                    const Text(
                      "Sweet Moments, Delivered Fresh\nDsn. Panggang Lele, Arjowinangun\nPhone: 08115784984",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 15,
                        color: Color.fromRGBO(107, 79, 63, 1),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                _rowTwoColumn(
                  leftTitle: "Nomor Transaksi",
                  leftValue: transactionId,
                  rightTitle: "Tanggal & Waktu",
                  rightValue: dateFormat.format(now),
                ),

                const SizedBox(height: 12),

                _rowTwoColumn(
                  leftTitle: "Nomor Antrian",
                  leftValue: queueNumber,
                  isBadgeLeft: true,
                  rightTitle: "Pelanggan",
                  rightValue: customerName,
                  extraRightBadge: membershipBadge,
                ),

                const SizedBox(height: 22),

                _titleSection("Pesanan"),

                const SizedBox(height: 6),

                // Daftar pesanan dinamis
                ...items.map(
                  (item) => _itemRow(
                    name: item.name,
                    desc: "${item.quantity} × ${item.priceDisplay}",
                    price: currency.format(item.total),
                  ),
                ),

                if (items.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "Tidak ada pesanan",
                      style: TextStyle(fontFamily: "Poppins", fontSize: 14),
                    ),
                  ),

                const SizedBox(height: 14),

                _priceBreak("Subtotal", currency.format(subtotal)),
                if (discountRate > 0)
                  _priceBreak(
                    "Diskon (${(discountRate * 100).toStringAsFixed(0)}%)",
                    "-${currency.format(discountValue)}",
                  ),
                _priceBreak("Tax (10%)", currency.format(tax)),

                const Divider(height: 26),

                _priceBreak(
                  "Total Pembayaran",
                  currency.format(total),
                  isTotal: true,
                ),

                const SizedBox(height: 12),

                _titleSection("Metode Pembayaran"),
                Align(
                  alignment: Alignment.centerLeft,
                  child: _badge(
                    paymentMethod == "cash" ? "Cash" : "Non-Cash",
                    isBlue: paymentMethod == "non-cash",
                  ),
                ),

                const SizedBox(height: 22),

                const Text(
                  "Thank you for shopping at CookiesBoo!\nHave a sweet day! 💛",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: "Poppins", fontSize: 12),
                ),

                const SizedBox(height: 18),

                _button("Print Struk Pembelian", Icons.print),
                const SizedBox(height: 8),
                _button("Kirim Ke Email", Icons.email),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _rowTwoColumn({
  required String leftTitle,
  required String leftValue,
  required String rightTitle,
  required String rightValue,
  bool isBadgeLeft = false,
  Widget? extraRightBadge,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              leftTitle,
              style: const TextStyle(fontFamily: "Poppins", fontSize: 12),
            ),
            const SizedBox(height: 2),
            isBadgeLeft
                ? _badge(leftValue)
                : Text(
                    leftValue,
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ],
        ),
      ),
      const SizedBox(width: 14),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              rightTitle,
              style: const TextStyle(fontFamily: "Poppins", fontSize: 12),
            ),
            const SizedBox(height: 2),
            Text(
              rightValue,
              style: const TextStyle(
                fontFamily: "Poppins",
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (extraRightBadge != null) ...[
              const SizedBox(height: 4),
              extraRightBadge,
            ],
          ],
        ),
      ),
    ],
  );
}

Widget _badge(String text, {bool isBlue = false}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: isBlue ? Colors.blue.shade100 : Colors.orange.shade100,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      text,
      style: TextStyle(
        fontFamily: "Poppins",
        fontSize: 10,
        color: isBlue ? Colors.blue.shade900 : Colors.orange.shade900,
      ),
    ),
  );
}

Widget _itemRow({
  required String name,
  required String desc,
  required String price,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(fontFamily: "Poppins", fontSize: 14),
              ),
              Text(
                desc,
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 11,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
        Text(
          price,
          style: const TextStyle(fontFamily: "Poppins", fontSize: 14),
        ),
      ],
    ),
  );
}

Widget _priceBreak(String label, String value, {bool isTotal = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: isTotal ? 15 : 13,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: isTotal ? 15 : 13,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

Widget _titleSection(String title) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Text(
      title,
      style: const TextStyle(
        fontFamily: "Poppins",
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

Widget _button(String text, IconData icon) {
  return Container(
    width: double.infinity,
    height: 48,
    decoration: BoxDecoration(
      color: Colors.brown.shade300,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontFamily: "Poppins",
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
