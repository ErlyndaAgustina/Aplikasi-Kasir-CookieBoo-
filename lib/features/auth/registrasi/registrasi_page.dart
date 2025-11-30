import 'package:flutter/material.dart';
import '../registrasi/widgets/registrasi_header.dart';
import '../registrasi/widgets/registrasi_card.dart';

class RegistrasiPage extends StatefulWidget {
  final VoidCallback onMenuTap;

  const RegistrasiPage({super.key, required this.onMenuTap});

  @override
  State<RegistrasiPage> createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(246, 231, 212, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RegistrasiHeader(onMenuTap: widget.onMenuTap),
              const SizedBox(height: 12),
              RegistrationCard()
            ],
          ),
        ),
      ),
    );
  }
}
