import 'package:flutter/material.dart';

class ExportSection extends StatelessWidget {
  const ExportSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color.fromRGBO(254, 243, 199, 1), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 12,
            offset: const Offset(6, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.download,
                size: 22,
                color: Color.fromRGBO(139, 111, 71, 1),
              ),
              const SizedBox(width: 8),
              const Text(
                "Ekspor & Cetak Data",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color.fromRGBO(139, 111, 71, 1),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          _buildButton(
            label: "Cetak Laporan",
            subtitle: "PDF",
            icon: Icons.description_outlined,
            color: const Color.fromRGBO(217, 160, 91, 1),
            textColor: Colors.white,
            iconColor: Colors.white,
            onTap: () {
            },
          ),

          const SizedBox(height: 10),

          _buildButton(
            label: "Export Excel",
            subtitle: "XLSX",
            icon: Icons.table_chart_outlined,
            color: Colors.white,
            iconColor: const Color.fromRGBO(30, 113, 89, 1),
            onTap: () {
            },
          ),

          const SizedBox(height: 10),

          _buildButton(
            label: "Export CSV",
            subtitle: "CSV",
            icon: Icons.file_download_outlined,
            color: Colors.white,
            iconColor: const Color.fromRGBO(35, 65, 159, 1),
            onTap: () {
            },
          ),

          const SizedBox(height: 15),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(249, 216, 208, 1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 20,
                  color: Color(0xFFE74C3C),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        color: Color.fromRGBO(107, 79, 63, 1),
                        fontSize: 13,
                      ),
                      children: [
                        TextSpan(
                          text:
                              "Data akan diekspor sesuai dengan filter yang dipilih. ",
                        ),
                        TextSpan(
                          text:
                              "Pastikan filter sudah sesuai sebelum mengekspor.",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color iconColor,
    Color? textColor,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Color.fromRGBO(228, 212, 196, 1), width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: textColor ?? const Color.fromRGBO(107, 79, 63, 1),
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    color:
                        (textColor ?? const Color.fromRGBO(133, 131, 145, 1)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
