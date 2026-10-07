import 'package:flutter/material.dart';

class KartuMahasiswa extends StatelessWidget {
  final String nama;
  final String nim;
  final String programStudi;

  const KartuMahasiswa({
    super.key,
    required this.nama,
    required this.nim,
    required this.programStudi,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320.0,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Kartu Mahasiswa",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const Divider(),

          Text(
            "Nama",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(nama),

          const Divider(),

          Text(
            "NIM",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(nim),

          const Divider(),

          Text(
            "Program Studi",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(programStudi),
        ],
      ),
    );
  }
}