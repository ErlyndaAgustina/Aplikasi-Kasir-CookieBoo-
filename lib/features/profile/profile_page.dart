import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../profile/widgets/profile_view.dart';
import '../profile/widgets/profile_header.dart';

class ProfilePage extends StatefulWidget {
  final VoidCallback onMenuTap;

  const ProfilePage({super.key, required this.onMenuTap});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<Map<String, dynamic>> fetchProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) throw Exception("User belum login");

    final data = await Supabase.instance.client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .single();

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(246, 231, 212, 1),
      body: SafeArea(
        child: FutureBuilder(
          future: fetchProfile(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final profile = snapshot.data as Map<String, dynamic>;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 25),
              child: Column(
                children: [
                  const ProfileHeader(),
                  const SizedBox(height: 16),

                  ProfileView(
                    name: profile['name'],
                    role: profile['role'],
                    email: Supabase.instance.client.auth.currentUser!.email!,
                    phone: profile['nomor_telepon'] ?? '-',
                    address: profile['alamat'] ?? '-',
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
