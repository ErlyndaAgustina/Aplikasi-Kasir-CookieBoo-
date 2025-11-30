import 'package:flutter/material.dart';

class CustomerInfoCard extends StatefulWidget {
  final ValueChanged<double> onDiscountChanged;

  const CustomerInfoCard({
    super.key,
    required this.onDiscountChanged,
  });

  @override
  State<CustomerInfoCard> createState() => _CustomerInfoCardState();
}

class _CustomerInfoCardState extends State<CustomerInfoCard> {
  bool isMembership = true;
  String? selectedMember;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final horizontalPadding = width < 400 ? 12.0 : 16.0;
    final contentPadding = width < 400 ? 10.0 : 12.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(horizontalPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color.fromRGBO(254, 243, 199, 1),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(6, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Informasi Pelanggan",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Color.fromRGBO(139, 111, 71, 1),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            "Rabu, 16 Okt 2025  •  09:30  •  Antrian: 001",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              color: const Color.fromRGBO(107, 79, 63, 1),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(contentPadding),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(246, 231, 212, 1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: [
                    _buildTabButton(
                      label: "Membership",
                      active: isMembership,
                      onTap: () {
                        setState(() {
                          isMembership = true;
                        });

                        if (selectedMember == null) {
                          widget.onDiscountChanged(0.0);
                        } else {
                          _applyDiscountForMember(selectedMember!);
                        }
                      },
                    ),
                    _buildTabButton(
                      label: "Non-Membership",
                      active: !isMembership,
                      onTap: () {
                        setState(() {
                          isMembership = false;
                          selectedMember = null;
                        });
                        widget.onDiscountChanged(0.0);
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                if (isMembership)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: const Color.fromRGBO(198, 165, 128, 1),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedMember,
                        hint: const Text(
                          "Pilih pelanggan membership...",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Color.fromRGBO(107, 79, 63, 1),
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: const [
                          DropdownMenuItem(
                            value: "Ajeng",
                            child: Text(
                              "Ajeng Chalista - Platinum (20% diskon)",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          DropdownMenuItem(
                            value: "Abir",
                            child: Text(
                              "Abir Fauziah Agung - Gold (15% diskon)",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          DropdownMenuItem(
                            value: "Dewangga",
                            child: Text(
                              "Dewangga Putra - Silver (10% diskon)",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                        onChanged: (val) {
                          setState(() => selectedMember = val);
                          if (val != null) {
                            _applyDiscountForMember(val);
                          } else {
                            widget.onDiscountChanged(0.0);
                          }
                        },
                      ),
                    ),
                  ),

                if (!isMembership)
                  TextField(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(198, 165, 128, 1),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(199, 164, 124, 1),
                          width: 1.5,
                        ),
                      ),
                      hintText: "Tambahkan nama pelanggan...",
                      hintStyle: const TextStyle(
                        fontFamily: 'Poppins',
                        color: Color.fromRGBO(107, 79, 63, 1),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: width < 400 ? 6 : 8,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _applyDiscountForMember(String memberKey) {
    double rate = 0.0;
    if (memberKey == "Ajeng") {
      rate = 0.20;
    } else if (memberKey == "Abir") {
      rate = 0.15;
    } else if (memberKey == "Dewangga") {
      rate = 0.10;
    }
    widget.onDiscountChanged(rate);
  }

  Widget _buildTabButton({
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
        decoration: BoxDecoration(
          color: active
              ? const Color.fromRGBO(217, 160, 91, 1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: active
                ? Colors.white
                : const Color.fromRGBO(107, 79, 63, 1),
          ),
        ),
      ),
    );
  }
}
