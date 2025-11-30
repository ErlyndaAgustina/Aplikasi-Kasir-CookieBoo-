import 'package:flutter/material.dart';

class MemberOrderCard extends StatelessWidget {
  final String initials;
  final Color avatarColor;
  final String name;
  final String tier;
  final String queueNumber;
  final String time;
  final List<String> items;
  final int subtotal;
  final int discountPercent;

  Color getBorderColor() {
    switch (tier.toLowerCase()) {
      case 'platinum':
        return Color.fromRGBO(185, 202, 254, 1);
      case 'gold':
        return Color.fromRGBO(254, 243, 199, 1);
      case 'silver':
        return Color.fromRGBO(171, 199, 239, 0.81);
      default:
        return Colors.black12;
    }
  }

  const MemberOrderCard({
    super.key,
    required this.initials,
    required this.avatarColor,
    required this.name,
    required this.tier,
    required this.queueNumber,
    required this.time,
    required this.items,
    required this.subtotal,
    required this.discountPercent,
  });

  Color getTierColor() {
    switch (tier.toLowerCase()) {
      case 'platinum':
        return Color.fromRGBO(62, 129, 237, 1);
      case 'gold':
        return Color.fromRGBO(217, 160, 91, 1);
      case 'silver':
        return Color.fromRGBO(100, 116, 139, 1);
      default:
        return Colors.black;
    }
  }

  Color getColorTier() {
    switch (tier.toLowerCase()) {
      case 'platinum':
        return Color.fromRGBO(35, 65, 159, 1);
      case 'gold':
        return Color.fromRGBO(162, 79, 37, 1);
      case 'silver':
        return Color.fromRGBO(100, 116, 139, 1);
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    final discount = subtotal * discountPercent ~/ 100;
    final total = subtotal - discount;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: getBorderColor(), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: avatarColor,
                child: Text(
                  initials,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: Color.fromRGBO(107, 79, 63, 1),
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: getTierColor().withOpacity(0.10),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: getTierColor(), width: 1),
                          ),
                          child: Text(
                            tier,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: getColorTier(),
                              fontWeight: FontWeight.w900,
                              fontSize: 12,
                            ),
                          ),
                        ),

                        const SizedBox(width: 7),

                        Text(
                          '# $queueNumber',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            color: Color.fromRGBO(198, 165, 128, 1),
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                          ),
                        ),

                        const SizedBox(width: 7),

                        Text(
                          '•  $time',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            color: Color.fromRGBO(198, 165, 128, 1),
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Icon(Icons.receipt_long, color: getTierColor(), size: 20),
              SizedBox(width: 6),
              Text(
                "Pesanan:",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: Color.fromRGBO(217, 160, 91, 1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "•",
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.2,
                              color: Color.fromRGBO(198, 165, 128, 1),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              e,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: Color.fromRGBO(198, 165, 128, 1),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),

          const SizedBox(height: 13),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: getTierColor().withOpacity(0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _priceRow("Subtotal", subtotal),
                _priceRow("Diskon Member ($discountPercent%)", -discount),
                const Divider(),
                _priceRow("Total Bayar", total),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, int value) {
    final labelColor = getColorTier();
    const subtotalValueColor = Color.fromRGBO(107, 79, 63, 1);
    const discountValueColor = Color.fromRGBO(217, 160, 91, 1);
    final totalValueColor = getTierColor();

    Color pickTextColor() {
      if (label == "Total Bayar") return totalValueColor;
      if (value < 0) return discountValueColor;
      if (label == "Subtotal") return subtotalValueColor;
      return Colors.black;
    }

    Color pickLabelColor() {
      return label == "Total Bayar" ? labelColor : labelColor;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: label == "Total Bayar"
                  ? FontWeight.bold
                  : FontWeight.w600,
              color: pickLabelColor(),
            ),
          ),
          Text(
            "${value < 0 ? '-' : ''}Rp ${value.abs().toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')}",
            style: TextStyle(
              fontWeight: label == "Total Bayar"
                  ? FontWeight.bold
                  : FontWeight.w600,
              color: pickTextColor(),
            ),
          ),
        ],
      ),
    );
  }
}
