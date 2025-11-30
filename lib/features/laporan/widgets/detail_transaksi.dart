import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final List<Map<String, dynamic>> dummyTransactions = [
  {
    "id": "TRX-2025-001",
    "date": "18 Okt 2025",
    "time": "08:00",
    "customer": "Hanif Frey",
    "membership": "Non-Membership",
    "payment": "Cash",
    "total": 140000,
    "items": [
      {
        "name": "Matcha Lotus",
        "price": 50000,
        "qty": 1,
        "image": "assets/images/matcha_lotus.jpg",
      },
    ],
  },
  {
    "id": "TRX-2025-002",
    "date": "18 Okt 2025",
    "time": "09:30",
    "customer": "Ajeng Chistie Aprilian",
    "membership": "Platinum",
    "payment": "QRIS",
    "total": 120000,
    "items": [
      {
        "name": "Monster Cookies",
        "price": 45000,
        "qty": 1,
        "image": "assets/images/monster_cookies.jpg",
      },
      {
        "name": "Red Velvet Oreo",
        "price": 20000,
        "qty": 3,
        "image": "assets/images/red_velvet.jpg",
      },
    ],
  },
  {
    "id": "TRX-2025-003",
    "date": "17 Okt 2025",
    "time": "10:00",
    "customer": "Abil Fauziah Agung",
    "membership": "Gold",
    "payment": "Debit Card",
    "total": 420000,
    "items": [
      {
        "name": "Matcha Lotus",
        "price": 50000,
        "qty": 8,
        "image": "assets/images/matcha_lotus.jpg",
      },
      {
        "name": "Monster Cookies",
        "price": 45000,
        "qty": 2,
        "image": "assets/images/monster_cookies.jpg",
      },
    ],
  },
  {
    "id": "TRX-2025-004",
    "date": "16 Okt 2025",
    "time": "10:30",
    "customer": "Dewangga Putra Pratama",
    "membership": "Silver",
    "payment": "Credit Card",
    "total": 120000,
    "items": [
      {
        "name": "Choco Chip Cookies",
        "price": 19000,
        "qty": 4,
        "image": "assets/images/choco_chips.jpg",
      },
      {
        "name": "Red Velvet Oreo",
        "price": 20000,
        "qty": 2,
        "image": "assets/images/red_velvet.jpg",
      },
    ],
  },
];

class TransactionHistoryList extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;
  const TransactionHistoryList({super.key, this.transactions = const []});

  String _formatRupiah(int amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final list = transactions.isEmpty ? dummyTransactions : transactions;
    return Column(
      children: list
          .map(
            (trx) => TransactionCard(
              id: trx["id"],
              date: trx["date"],
              time: trx["time"],
              customer: trx["customer"],
              membership: trx["membership"],
              payment: trx["payment"],
              total: trx["total"],
              items: trx["items"] as List<Map<String, dynamic>>,
              formatRupiah: _formatRupiah,
            ),
          )
          .toList(),
    );
  }
}

class TransactionCard extends StatefulWidget {
  final String id;
  final String date;
  final String time;
  final String customer;
  final String membership;
  final String payment;
  final int total;
  final List<Map<String, dynamic>> items;
  final String Function(int) formatRupiah;

  const TransactionCard({
    super.key,
    required this.id,
    required this.date,
    required this.time,
    required this.customer,
    required this.membership,
    required this.payment,
    required this.total,
    required this.items,
    required this.formatRupiah,
  });

  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
  );

  late final Animation<double> _arrowAnimation = Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _badgeBg(String membership) => switch (membership.toLowerCase()) {
    "platinum" => const Color(0xFFE8F6F8),
    "gold" => const Color(0xFFFFF2E6),
    "silver" => const Color(0xFFF2F4F7),
    "non-membership" => const Color(0xFFF2F4F7),
    _ => const Color(0xFFF2F4F7),
  };

  Color _badgeText(String membership) => switch (membership.toLowerCase()) {
    "platinum" => const Color(0xFF2E7DAF),
    "gold" => const Color(0xFFD49E57),
    "silver" => const Color(0xFF6B7280),
    "non-membership" => const Color(0xFF6B7280),
    _ => const Color(0xFF6B7280),
  };

  Widget _buildBadge(String membership) {
    final lower = membership.toLowerCase();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _badgeBg(membership),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (lower == "gold")
            const Icon(Icons.emoji_events, size: 14, color: Color(0xFFD49E57)),
          if (lower == "platinum")
            const Icon(
              Icons.workspace_premium,
              size: 14,
              color: Color(0xFF2E7DAF),
            ),
          if (lower == "silver")
            const Icon(Icons.star_border, size: 14, color: Color(0xFF6B7280)),
          if (lower == "non-membership")
            const Icon(
              Icons.person_outline,
              size: 14,
              color: Color(0xFF6B7280),
            ),
          const SizedBox(width: 6),
          Text(
            membership,
            style: TextStyle(
              color: _badgeText(membership),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        children: widget.items.map((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE9DCCB)),
              color: const Color(0xFFFAF7F4),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    item["image"] as String,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.image),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item["name"] as String,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${widget.formatRupiah(item['price'] as int)} x ${item['qty']}",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF8A8A8A),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  widget.formatRupiah(
                    (item["price"] as int) * (item["qty"] as int),
                  ),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFD49E57),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalItems = widget.items.fold<int>(
      0,
      (s, e) => s + (e["qty"] as int),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0E6D9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  widget.id,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
              _buildBadge(widget.membership),
            ],
          ),

          const SizedBox(height: 6),
          Text(
            "${widget.date} • ${widget.time}",
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),

          const SizedBox(height: 4),
          Text(
            widget.customer,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                "Total Item",
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(width: 100),
              Text(
                "Pembayaran",
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ],
          ),

          const SizedBox(height: 4),

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "$totalItems item",
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),

              const SizedBox(width: 100),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7F0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.payment,
                  style: const TextStyle(
                    color: Color(0xFFD49E57),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF3E8DA),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                widget.formatRupiah(widget.total),
                style: const TextStyle(
                  color: Color(0xFFD49E57),
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          InkWell(
            onTap: () {
              setState(() => _expanded = !_expanded);
              _expanded ? _controller.forward() : _controller.reverse();
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE7D6C3)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.remove_red_eye_outlined,
                    size: 18,
                    color: Color(0xFF6B4F2F),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _expanded ? "Sembunyikan Produk" : "Lihat Produk",
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  RotationTransition(
                    turns: _arrowAnimation,
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFF6B4F2F),
                    ),
                  ),
                ],
              ),
            ),
          ),

          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _buildProductList(),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 220),
          ),
        ],
      ),
    );
  }
}
