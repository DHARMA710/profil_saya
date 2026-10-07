import 'package:flutter/material.dart';

void main() {
  runApp(const AplikasiKartuProfil());
}

class AplikasiKartuProfil extends StatelessWidget {
  const AplikasiKartuProfil({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kartu Profil',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        useMaterial3: true,
      ),
      home: const HalamanKartuProfil(),
    );
  }
}

class HalamanKartuProfil extends StatelessWidget {
  const HalamanKartuProfil({super.key});

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kartu Profil'),
        centerTitle: true,
        backgroundColor: warna.primaryContainer,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8E4)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 48,
                backgroundColor: warna.primaryContainer,
                child: Icon(Icons.person, size: 48, color: warna.primary),
                // Jika memakai foto asli:
                // backgroundImage: AssetImage('assets/foto.jpg'),
              ),
              const SizedBox(height: 14),
              const Text(
                'Dharma Putra',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Text('NIM 20246312108'),
              Text(
                'Teknik Komputer',
                style: TextStyle(
                  color: warna.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Divider(height: 32),
              const BarisInfo(ikon: Icons.badge, teks: 'NIM: 20246312108'),
              const SizedBox(height: 10),
              const BarisInfo(ikon: Icons.school, teks: 'Program Studi Teknik Komputer'),
              const SizedBox(height: 10),
              const BarisInfo(ikon: Icons.email, teks: 'dharma@kampus.ac.id'),
            ],
          ),
        ),
      ),
    );
  }
}

class BarisInfo extends StatelessWidget {
  final IconData ikon;
  final String teks;

  const BarisInfo({super.key, required this.ikon, required this.teks});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(ikon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Text(teks),
      ],
    );
  }
}