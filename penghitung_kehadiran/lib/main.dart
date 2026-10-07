import 'package:flutter/material.dart';

void main() {
  runApp(const AplikasiKehadiran());
}

class AplikasiKehadiran extends StatelessWidget {
  const AplikasiKehadiran({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Penghitung Kehadiran',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.green, useMaterial3: true),
      home: const HalamanKehadiran(),
    );
  }
}

class HalamanKehadiran extends StatefulWidget {
  const HalamanKehadiran({super.key});

  @override
  State<HalamanKehadiran> createState() => _HalamanKehadiranState();
}

class _HalamanKehadiranState extends State<HalamanKehadiran> {
  int _kehadiran = 0;

  void _hadir() {
    setState(() {
      _kehadiran++;
    });
  }

  void _reset() {
    setState(() {
      _kehadiran = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Hijau bila kehadiran minimal 12 pertemuan
    final warnaTeks = _kehadiran >= 12 ? Colors.green : Colors.red;

    return Scaffold(
      appBar: AppBar(title: const Text('Kehadiran'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$_kehadiran',
              style: Theme.of(context)
                  .textTheme
                  .displayLarge
                  ?.copyWith(color: warnaTeks, fontWeight: FontWeight.bold),
            ),
            const Text('pertemuan hadir'),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton.icon(
                  onPressed: _hadir,
                  icon: const Icon(Icons.check),
                  label: const Text('Hadir'),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: _reset,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}