import 'package:flutter/material.dart';

class RecentTransactionsCard extends StatelessWidget {
  const RecentTransactionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDF8),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.folder_open_rounded,
                  color: Color(0xFFEF6C00),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Transaksi Terbaru',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5D4037),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildTransactionItem(
            product: 'Choco Chip Cookies (2 box)',
            code: '10:45  •  TRX-001',
            price: 'Rp 80.000',
            tagColor: const Color(0xFFFFEBEE),
            tagTextColor: const Color(0xFFC62828),
          ),
          const SizedBox(height: 12),
          _buildTransactionItem(
            product: 'Red Velvet Cookies (1 box)',
            code: '11:25  •  TRX-002',
            price: 'Rp 50.000',
            tagColor: const Color(0xFFFFF0F0),
            tagTextColor: const Color(0xFFD32F2F),
          ),
          const SizedBox(height: 12),
          _buildTransactionItem(
            product: 'Oatmeal Cookies (4 box)',
            code: '11:40  •  TRX-003',
            price: 'Rp 110.000',
            tagColor: const Color(0xFFFFF8E1),
            tagTextColor: const Color(0xFFEF6C00),
          ),
          const SizedBox(height: 12),
          _buildTransactionItem(
            product: 'Double Chocolate Cookies (1 box)',
            code: '12:10  •  TRX-004',
            price: 'Rp 65.000',
            tagColor: const Color(0xFFFFF3E0),
            tagTextColor: const Color(0xFFEF6C00),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFE0B2),
                foregroundColor: const Color(0xFFEF6C00),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Lihat Semua Transaksi',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem({
    required String product,
    required String code,
    required String price,
    required Color tagColor,
    required Color tagTextColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0E6E0), width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5D4037),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: tagColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    code,
                    style: TextStyle(
                      fontSize: 11,
                      color: tagTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFFEF6C00),
            ),
          ),
        ],
      ),
    );
  }
}

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: const Text('Dashboard')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [RecentTransactionsCard(), SizedBox(height: 20)],
        ),
      ),
    ),
  ),
);
