import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final String url;

  const AppButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    required this.url,
  });

  Future<void> _handlePressed() async {
    if (onPressed != null) {
      final Uri uri = Uri.parse(url);
      final bool success = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!success) {
        debugPrint("Gagal membuka link");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: (onPressed != null) ? _handlePressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFDF7FF), // Warna tombol putih keunguan/abu terang
          foregroundColor: const Color(0xFF6C757D), // Warna ikon & teks abu-abu gelap
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          elevation: 0, // Menghilangkan bayangan
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Sudut lebih tumpul
            side: const BorderSide(color: Color(0xFFE2E8F0)), // Border tipis
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}