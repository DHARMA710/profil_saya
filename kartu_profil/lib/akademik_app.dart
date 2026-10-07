import 'package:flutter/material.dart';

void main() {
  runApp(const AplikasiAkademik());
}

// ======================= DATA =======================
final List<Map<String, dynamic>> mataKuliah = [
  {'kode': 'TK101', 'nama': 'Pemrograman Mobile', 'sks': 3},
  {'kode': 'TK102', 'nama': 'Jaringan Komputer', 'sks': 3},
  {'kode': 'TK103', 'nama': 'Basis Data', 'sks': 4},
  {'kode': 'TK104', 'nama': 'Kecerdasan Buatan', 'sks': 2},
  {'kode': 'TK105', 'nama': 'Algoritma dan Struktur Data', 'sks': 4},
  {'kode': 'TK106', 'nama': 'Sistem Operasi', 'sks': 3},
  {'kode': 'TK107', 'nama': 'Etika Profesi', 'sks': 2},
];

// ================= FUNGSI (dari tugas konsol) =================
List<Map<String, dynamic>> cari(
  List<Map<String, dynamic>> data,
  String kataKunci,
) {
  final kunci = kataKunci.toLowerCase();
  return data
      .where((mk) =>
          (mk['nama'] as String).toLowerCase().contains(kunci) ||
          (mk['kode'] as String).toLowerCase().contains(kunci))
      .toList();
}

List<Map<String, dynamic>> saringSks(
  List<Map<String, dynamic>> data, {
  int? minSks,
  int? maxSks,
}) {
  return data
      .where((mk) =>
          (minSks == null || (mk['sks'] as int) >= minSks) &&
          (maxSks == null || (mk['sks'] as int) <= maxSks))
      .toList();
}

List<Map<String, dynamic>> urutkanNama(
  List<Map<String, dynamic>> data, {
  bool naik = true,
}) {
  final salinan = [...data];
  salinan.sort((a, b) {
    final hasil = (a['nama'] as String).compareTo(b['nama'] as String);
    return naik ? hasil : -hasil;
  });
  return salinan;
}

// ======================= APLIKASI =======================
class AplikasiAkademik extends StatelessWidget {
  const AplikasiAkademik({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pengolah Data Akademik',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.green, useMaterial3: true),
      home: const HalamanAkademik(),
    );
  }
}

class HalamanAkademik extends StatefulWidget {
  const HalamanAkademik({super.key});

  @override
  State<HalamanAkademik> createState() => _HalamanAkademikState();
}

class _HalamanAkademikState extends State<HalamanAkademik> {
  String _kataKunci = '';
  int? _filterSks; // null = semua SKS
  bool _naik = true;

  // Menggabungkan cari -> saring -> urut
  List<Map<String, dynamic>> get _hasil {
    var data = cari(mataKuliah, _kataKunci);
    if (_filterSks != null) {
      data = saringSks(data, minSks: _filterSks, maxSks: _filterSks);
    }
    return urutkanNama(data, naik: _naik);
  }

  @override
  Widget build(BuildContext context) {
    final hasil = _hasil;
    final totalSks = hasil.fold<int>(0, (jumlah, mk) => jumlah + (mk['sks'] as int));
    final warna = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Akademik'),
        centerTitle: true,
        backgroundColor: warna.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Kotak pencarian
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Cari nama atau kode mata kuliah',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (teks) => setState(() => _kataKunci = teks),
            ),
            const SizedBox(height: 12),

            // Filter SKS + tombol urut
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('Semua'),
                        selected: _filterSks == null,
                        onSelected: (_) => setState(() => _filterSks = null),
                      ),
                      ...[2, 3, 4].map(
                        (n) => ChoiceChip(
                          label: Text('$n SKS'),
                          selected: _filterSks == n,
                          onSelected: (_) => setState(() => _filterSks = n),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () => setState(() => _naik = !_naik),
                  icon: Icon(_naik ? Icons.arrow_upward : Icons.arrow_downward),
                  label: Text(_naik ? 'A-Z' : 'Z-A'),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Ringkasan
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: warna.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${hasil.length} mata kuliah  |  Total $totalSks SKS',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 12),

            // Daftar
            Expanded(
              child: hasil.isEmpty
                  ? const Center(child: Text('Tidak ada data yang cocok'))
                  : ListView(
                      children: hasil
                          .map(
                            (mk) => Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Text('${mk['sks']}'),
                                ),
                                title: Text(mk['nama'] as String),
                                subtitle: Text(
                                  '${mk['kode']}  |  ${mk['sks']} SKS',
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}