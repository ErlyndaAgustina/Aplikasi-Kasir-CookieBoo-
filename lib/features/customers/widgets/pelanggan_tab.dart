import 'package:flutter/material.dart';

class PelangganTab extends StatefulWidget {
  final ValueChanged<int> onChanged;

  const PelangganTab({super.key, required this.onChanged});

  @override
  State<PelangganTab> createState() => _PelangganTapState();
}

class _PelangganTapState extends State<PelangganTab> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 37,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = constraints.maxWidth / 2;

          return Stack(
            children: [
              AnimatedAlign(
                alignment: _selectedIndex == 0
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeInOut,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Container(
                    width: tabWidth - 6,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(217, 160, 91, 1),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(
                            255,
                            228,
                            165,
                            88,
                          ).withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _selectedIndex = 0);
                        widget.onChanged(0);
                      },
                      child: Center(
                        child: Text(
                          "Pelanggan Hari Ini",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: _selectedIndex == 0
                                ? Colors.white
                                : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _selectedIndex = 1);
                        widget.onChanged(1);
                      },
                      child: Center(
                        child: Text(
                          "Member Tier",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: _selectedIndex == 1
                                ? Colors.white
                                : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
