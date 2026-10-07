import 'package:flutter/material.dart';

void main() {
  runApp(const AplikasiLatihan());
}

// ================= POIN 1: FUNCTION SUHU (terpisah) =================
double celsiusKeFahrenheit(double c) => (c * 9 / 5) + 32;
double celsiusKeKelvin(double c) => c + 273.15;

// ================= POIN 2: CLASS PRODUK =================
class Produk {
  final String nama;
  final double harga;
  final double? diskon; // opsional, dalam persen

  Produk({required this.nama, required this.harga, this.diskon});

  double get hargaAkhir {
    final potongan = diskon ?? 0;
    return harga - (harga * potongan / 100);
  }
}

// ================= POIN 3: const global =================
// const: pasti saat kompilasi, tidak pernah berubah
const double batasLulus = 65;

String rupiah(double angka) {
  final s = angka.round().toString();
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return 'Rp $buf';
}

class AplikasiLatihan extends StatelessWidget {
  const AplikasiLatihan({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Latihan Dart Minggu 02',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.green, useMaterial3: true),
      home: const HalamanLatihan(),
    );
  }
}

class HalamanLatihan extends StatelessWidget {
  const HalamanLatihan({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Latihan Dart Minggu 02'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.thermostat), text: 'Suhu'),
              Tab(icon: Icon(Icons.shopping_bag), text: 'Produk'),
              Tab(icon: Icon(Icons.code), text: 'Variabel'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            TabSuhu(),
            TabProduk(),
            TabVariabel(),
          ],
        ),
      ),
    );
  }
}

// ======================= TAB 1: SUHU =======================
class TabSuhu extends StatefulWidget {
  const TabSuhu({super.key});

  @override
  State<TabSuhu> createState() => _TabSuhuState();
}

class _TabSuhuState extends State<TabSuhu> {
  final _kontrol = TextEditingController();
  double? _celsius;
  String? _error;

  void _ubah(String teks) {
    if (teks.trim().isEmpty) {
      setState(() {
        _celsius = null;
        _error = null;
      });
      return;
    }
    final nilai = double.tryParse(teks.trim().replaceAll(',', '.'));
    setState(() {
      if (nilai == null) {
        _celsius = null;
        _error = 'Masukkan angka yang valid';
      } else {
        _celsius = nilai;
        _error = null;
      }
    });
  }

  @override
  void dispose() {
    _kontrol.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          controller: _kontrol,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
            signed: true,
          ),
          decoration: InputDecoration(
            labelText: 'Suhu dalam Celsius (°C)',
            prefixIcon: const Icon(Icons.thermostat),
            errorText: _error,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: _ubah,
        ),
        const SizedBox(height: 16),
        KartuHasil(
          judul: 'Fahrenheit',
          nilai: _celsius == null
              ? '-'
              : '${celsiusKeFahrenheit(_celsius!).toStringAsFixed(1)} °F',
          ikon: Icons.wb_sunny,
          warna: warna.primaryContainer,
        ),
        const SizedBox(height: 8),
        KartuHasil(
          judul: 'Kelvin',
          nilai: _celsius == null
              ? '-'
              : '${celsiusKeKelvin(_celsius!).toStringAsFixed(2)} K',
          ikon: Icons.science,
          warna: warna.secondaryContainer,
        ),
        const SizedBox(height: 16),
        const Text('Contoh cepat', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [0.0, 25.0, 36.5, 100.0, -40.0]
              .map(
                (c) => ActionChip(
                  label: Text('$c °C'),
                  onPressed: () {
                    _kontrol.text = c.toString();
                    _ubah(c.toString());
                  },
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class KartuHasil extends StatelessWidget {
  final String judul;
  final String nilai;
  final IconData ikon;
  final Color warna;

  const KartuHasil({
    super.key,
    required this.judul,
    required this.nilai,
    required this.ikon,
    required this.warna,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: warna,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(ikon, size: 32),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(judul),
              Text(
                nilai,
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ======================= TAB 2: PRODUK =======================
class TabProduk extends StatefulWidget {
  const TabProduk({super.key});

  @override
  State<TabProduk> createState() => _TabProdukState();
}

class _TabProdukState extends State<TabProduk> {
  final _nama = TextEditingController();
  final _harga = TextEditingController();
  final _diskon = TextEditingController();
  String? _error;

  final List<Produk> _daftar = [
    Produk(nama: 'Buku Tulis', harga: 10000),
    Produk(nama: 'Pensil', harga: 5000, diskon: 10),
    Produk(nama: 'Tas Ransel', harga: 250000, diskon: 20),
  ];

  void _tambah() {
    final nama = _nama.text.trim();
    final harga = double.tryParse(_harga.text.trim());
    final diskonTeks = _diskon.text.trim();
    final diskon = diskonTeks.isEmpty ? null : double.tryParse(diskonTeks);

    String? pesan;
    if (nama.isEmpty) {
      pesan = 'Nama produk wajib diisi';
    } else if (harga == null || harga <= 0) {
      pesan = 'Harga harus berupa angka lebih dari 0';
    } else if (diskonTeks.isNotEmpty && (diskon == null || diskon < 0 || diskon > 100)) {
      pesan = 'Diskon harus angka 0 sampai 100';
    }

    if (pesan != null) {
      setState(() => _error = pesan);
      return;
    }

    setState(() {
      _daftar.add(Produk(nama: nama, harga: harga!, diskon: diskon));
      _error = null;
      _nama.clear();
      _harga.clear();
      _diskon.clear();
    });
  }

  @override
  void dispose() {
    _nama.dispose();
    _harga.dispose();
    _diskon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          controller: _nama,
          decoration: const InputDecoration(
            labelText: 'Nama produk',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _harga,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Harga (Rp)',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _diskon,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Diskon % (opsional)',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(_error!, style: TextStyle(color: warna.error)),
          ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: _tambah,
          icon: const Icon(Icons.add),
          label: const Text('Tambah Produk'),
        ),
        const SizedBox(height: 16),
        const Text('Daftar Produk', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ..._daftar.map(
          (p) => Card(
            child: ListTile(
              title: Text(p.nama),
              subtitle: p.diskon == null
                  ? Text('${rupiah(p.harga)} (tanpa diskon)')
                  : Text(
                      '${rupiah(p.harga)} | diskon ${p.diskon!.toStringAsFixed(0)}%',
                    ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Harga akhir', style: TextStyle(fontSize: 11)),
                  Text(
                    rupiah(p.hargaAkhir),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: warna.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ======================= TAB 3: VARIABEL =======================
class TabVariabel extends StatefulWidget {
  const TabVariabel({super.key});

  @override
  State<TabVariabel> createState() => _TabVariabelState();
}

class _TabVariabelState extends State<TabVariabel> {
  // var: tipe disimpulkan compiler, nilai boleh berubah
  var _nilai = 78;

  // final: ditentukan saat runtime, lalu tidak bisa diganti
  final DateTime _waktuMulai = DateTime.now();

  // late: nilai diisi belakangan (di initState), bukan saat deklarasi
  late String _kodeMataKuliah;

  @override
  void initState() {
    super.initState();
    _kodeMataKuliah = 'TKO-4021';
  }

  @override
  Widget build(BuildContext context) {
    final status = _nilai >= batasLulus ? 'Lulus' : 'Belum lulus';
    final jam = _waktuMulai.toString().substring(0, 19);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        KartuVariabel(
          kata: 'var',
          isi: 'nilai = $_nilai ($status)',
          alasan: 'Nilai berubah selama aplikasi berjalan, jadi memakai var.',
          aksi: Row(
            children: [
              OutlinedButton.icon(
                onPressed: () => setState(() => _nilai -= 5),
                icon: const Icon(Icons.remove),
                label: const Text('Kurangi 5'),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: () => setState(() => _nilai += 5),
                icon: const Icon(Icons.add),
                label: const Text('Tambah 5'),
              ),
            ],
          ),
        ),
        KartuVariabel(
          kata: 'final',
          isi: 'waktuMulai = $jam',
          alasan:
              'Ditentukan saat runtime (DateTime.now()), lalu tidak boleh diganti. '
              'Waktu ini tetap meski tombol ditekan.',
        ),
        KartuVariabel(
          kata: 'const',
          isi: 'batasLulus = $batasLulus',
          alasan:
              'Sudah pasti saat kompilasi dan tidak pernah berubah, cocok untuk konstanta.',
        ),
        KartuVariabel(
          kata: 'late',
          isi: 'kodeMataKuliah = $_kodeMataKuliah',
          alasan:
              'Dideklarasikan tanpa nilai, lalu diisi di initState(). '
              'Nilainya baru tersedia setelah inisialisasi.',
        ),
      ],
    );
  }
}

class KartuVariabel extends StatelessWidget {
  final String kata;
  final String isi;
  final String alasan;
  final Widget? aksi;

  const KartuVariabel({
    super.key,
    required this.kata,
    required this.isi,
    required this.alasan,
    this.aksi,
  });

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: warna.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                kata,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              isi,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(alasan, style: const TextStyle(color: Colors.black54)),
            if (aksi != null) ...[
              const SizedBox(height: 12),
              aksi!,
            ],
          ],
        ),
      ),
    );
  }
}