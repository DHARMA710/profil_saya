import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const AplikasiKartuDigital());
}

class AplikasiKartuDigital extends StatelessWidget {
  const AplikasiKartuDigital({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kartu Identitas Digital',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
  colorSchemeSeed: Colors.green,
  useMaterial3: true,
),
      home: const HalamanKartu(),
    );
  }
}

// StatefulWidget: menyimpan status tema kartu (terang / gelap)
class HalamanKartu extends StatefulWidget {
  const HalamanKartu({super.key});

  @override
  State<HalamanKartu> createState() => _HalamanKartuState();
}

class _HalamanKartuState extends State<HalamanKartu> {
  bool _gelap = false;

  void _gantiTema() {
    setState(() {
      _gelap = !_gelap;
    });
  }

  @override
  Widget build(BuildContext context) {
    final warnaLatar = _gelap ? const Color(0xFF1B2420) : Colors.white;
    final warnaTeks = _gelap ? Colors.white : const Color(0xFF1B2420);
    final warnaTeksPudar = _gelap ? Colors.white70 : Colors.black54;
    final warnaAksen = _gelap ? const Color(0xFF6FD39B) : Colors.green.shade700;
    final warnaGaris = _gelap ? Colors.white24 : const Color(0xFFE2E8E4);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kartu Identitas Digital',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ========== KARTU ==========
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 360,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: warnaLatar,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: warnaGaris),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Judul kartu (font gaya teknologi)
                    Text(
                      'KARTU MAHASISWA',
                      style: GoogleFonts.orbitron(
                        color: warnaAksen,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Foto profil (bulat)
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: warnaAksen, width: 3),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/foto.jpg',
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Nama (font elegan)
                    Text(
                      'Dharma Putra',
                      style: GoogleFonts.playfairDisplay(
                        color: warnaTeks,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Teknik Komputer',
                      style: GoogleFonts.poppins(
                        color: warnaAksen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Divider(color: warnaGaris),
                    const SizedBox(height: 8),

                    BarisData(
                      ikon: Icons.badge,
                      label: 'NIM',
                      nilai: '20246312108',
                      warnaIkon: warnaAksen,
                      warnaLabel: warnaTeksPudar,
                      warnaNilai: warnaTeks,
                    ),
                    const SizedBox(height: 12),
                    BarisData(
                      ikon: Icons.school,
                      label: 'Program Studi',
                      nilai: 'Teknik Komputer',
                      warnaIkon: warnaAksen,
                      warnaLabel: warnaTeksPudar,
                      warnaNilai: warnaTeks,
                    ),
                    const SizedBox(height: 12),
                    BarisData(
                      ikon: Icons.email,
                      label: 'Email',
                      nilai: 'dharma@kampus.ac.id',
                      warnaIkon: warnaAksen,
                      warnaLabel: warnaTeksPudar,
                      warnaNilai: warnaTeks,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ========== TOMBOL GANTI TEMA ==========
              FilledButton.icon(
                onPressed: _gantiTema,
                icon: Icon(_gelap ? Icons.light_mode : Icons.dark_mode),
                label: Text(_gelap ? 'Mode Terang' : 'Mode Gelap'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Satu baris data: ikon di kiri, label dan nilai di kanan
class BarisData extends StatelessWidget {
  final IconData ikon;
  final String label;
  final String nilai;
  final Color warnaIkon;
  final Color warnaLabel;
  final Color warnaNilai;

  const BarisData({
    super.key,
    required this.ikon,
    required this.label,
    required this.nilai,
    required this.warnaIkon,
    required this.warnaLabel,
    required this.warnaNilai,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(ikon, color: warnaIkon),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(color: warnaLabel, fontSize: 12),
            ),
            Text(
              nilai,
              style: GoogleFonts.poppins(
                color: warnaNilai,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}