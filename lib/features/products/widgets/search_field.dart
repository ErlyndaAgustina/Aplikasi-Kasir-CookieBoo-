import 'package:flutter/material.dart';

class ProdukSearchField extends StatefulWidget {
  final Function(String) onSearchChanged;

  const ProdukSearchField({super.key, required this.onSearchChanged});

  @override
  State<ProdukSearchField> createState() => _ProdukSearchFieldState();
}

class _ProdukSearchFieldState extends State<ProdukSearchField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      widget.onSearchChanged(_controller.text.trim());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color.fromRGBO(198, 165, 128, 1),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.search,
            color: Color.fromRGBO(198, 165, 128, 1),
          ),
          hintText: "Cari Produk Cookies...",
          hintStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color.fromRGBO(107, 79, 63, 1),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
      ),
    );
  }
}
