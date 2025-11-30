import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(50),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFFF1E6D6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 18,
                  color: Color(0xFF6B4F3F),
                ),
              ),
            ),

            Expanded(
              child: Center(
                child: Image.asset(
                  'assets/images/logo_cookiesboo.png',
                  width: 200,
                ),
              ),
            ),
            const SizedBox(width: 40),
          ],
        ),
      ],
    );
  }
}
