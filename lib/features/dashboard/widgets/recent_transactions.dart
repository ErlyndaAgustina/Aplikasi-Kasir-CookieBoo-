import 'package:flutter/material.dart';

import '../../laporan/laporan_page.dart';

class RecentTransactionsCard extends StatelessWidget {
  const RecentTransactionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDF8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.folder_open_rounded,
                color: Color.fromRGBO(217, 160, 91, 1),
                size: 24,
              ),

              const SizedBox(width: 12),
              const Text(
                'Transaksi Terbaru',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Color.fromRGBO(107, 79, 63, 1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildTransactionItem(
            product: 'Choco Chip Cookies (2 box)',
            code: '10:45  •  TRX-001',
            price: 'Rp 80.000',
          ),
          const SizedBox(height: 12),
          _buildTransactionItem(
            product: 'Red Velvet Cookies (1 box)',
            code: '11:25  •  TRX-002',
            price: 'Rp 50.000',
          ),
          const SizedBox(height: 12),
          _buildTransactionItem(
            product: 'Oatmeal Cookies (4 box)',
            code: '11:40  •  TRX-003',
            price: 'Rp 110.000',
          ),
          const SizedBox(height: 12),
          _buildTransactionItem(
            product: 'Double Chocolate Cookies (1 box)',
            code: '12:10  •  TRX-004',
            price: 'Rp 65.000',
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LaporanPage(onMenuTap: () {},)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(217, 160, 91, 1),
                foregroundColor: const Color.fromARGB(255, 248, 113, 2),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Lihat Semua Transaksi',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
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
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color.fromRGBO(246, 231, 212, 1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color.fromRGBO(198, 165, 128, 0.17),
          width: 1,
        ),
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
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color.fromRGBO(107, 79, 63, 1),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 247, 245, 245),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    code,
                    style: TextStyle(
                      fontSize: 10,
                      color: Color.fromRGBO(198, 165, 128, 1),
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
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(217, 160, 91, 1),
            ),
          ),
        ],
      ),
    );
  }
}
