import 'package:flutter/material.dart';

import 'constans/colors.dart';
import 'theme/app_theme.dart';
import 'widgets/buttons.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Design System Demo',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.normal,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFFF5A623), // Warna oranye pada AppBar
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Universitas Esa Unggul',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5B4FE9), // Warna ungu/biru sesuai gambar
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Tekan tombol di bawah untuk melihat lokasi kampus.',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF00A896), // Warna hijau sesuai gambar
              ),
            ),

            const SizedBox(height: 24),

            AppButton(
              label: 'Buka Github', // Teks diubah sesuai gambar
              icon: Icons.location_on,
              url: 'https://github.com/Raihanilham12/muhammad-raihan-ilham_kelompok-1_kh001',
              onPressed: () {}, // Diperlukan agar tombol bisa diklik
            ),

            const SizedBox(height: 12),

            AppButton(
              label: 'Tes Tombol', // Teks diubah sesuai gambar
              icon: Icons.touch_app,
              url: 'https://github.com/Raihanilham12/muhammad-raihan-ilham_kelompok-1_kh001',
              onPressed: () {
                debugPrint('Tombol berhasil ditekan!');
              },
            ),
          ],
        ),
      ),
    );
  }
}