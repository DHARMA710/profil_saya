import 'package:flutter/material.dart';

void main() {
  runApp(const AplikasiKatalog());
}

// ======================= MODEL =======================
class Buku {
  final int id;
  final String judul;
  final String penulis;
  final String kategori;
  final int harga;
  final String deskripsi;
  final IconData ikon;
  final Color warna;

  const Buku({
    required this.id,
    required this.judul,
    required this.penulis,
    required this.kategori,
    required this.harga,
    required this.deskripsi,
    required this.ikon,
    required this.warna,
  });
}

// Daftar dinamis: 9 item (minimal 8)
const List<Buku> daftarBuku = [
  Buku(id: 1, judul: 'Pemrograman Dart', penulis: 'Andi Pratama', kategori: 'Pemrograman', harga: 85000, deskripsi: 'Dasar bahasa Dart: variabel, class, null safety, dan koleksi.', ikon: Icons.code, warna: Colors.green),
  Buku(id: 2, judul: 'Flutter untuk Pemula', penulis: 'Sari Dewi', kategori: 'Mobile', harga: 95000, deskripsi: 'Membangun aplikasi mobile dengan widget, layout, dan navigasi.', ikon: Icons.phone_android, warna: Colors.blue),
  Buku(id: 3, judul: 'Jaringan Komputer', penulis: 'Budi Santoso', kategori: 'Jaringan', harga: 90000, deskripsi: 'Konsep TCP/IP, routing, switching, dan keamanan jaringan.', ikon: Icons.lan, warna: Colors.orange),
  Buku(id: 4, judul: 'Basis Data Modern', penulis: 'Citra Lestari', kategori: 'Data', harga: 88000, deskripsi: 'Desain basis data, SQL, normalisasi, dan optimasi query.', ikon: Icons.storage, warna: Colors.purple),
  Buku(id: 5, judul: 'Kecerdasan Buatan', penulis: 'Dewa Putra', kategori: 'AI', harga: 110000, deskripsi: 'Pengantar machine learning, jaringan saraf, dan aplikasinya.', ikon: Icons.psychology, warna: Colors.red),
  Buku(id: 6, judul: 'Struktur Data', penulis: 'Eka Wijaya', kategori: 'Pemrograman', harga: 82000, deskripsi: 'Array, linked list, tree, graph, dan analisis algoritma.', ikon: Icons.account_tree, warna: Colors.teal),
  Buku(id: 7, judul: 'Sistem Operasi', penulis: 'Fajar Nugraha', kategori: 'Sistem', harga: 92000, deskripsi: 'Proses, memori, penjadwalan, dan sistem berkas.', ikon: Icons.memory, warna: Colors.indigo),
  Buku(id: 8, judul: 'Keamanan Siber', penulis: 'Gita Maharani', kategori: 'Jaringan', harga: 105000, deskripsi: 'Kriptografi, serangan umum, dan cara pertahanannya.', ikon: Icons.security, warna: Colors.brown),
  Buku(id: 9, judul: 'Rekayasa Perangkat Lunak', penulis: 'Hadi Kusuma', kategori: 'Sistem', harga: 98000, deskripsi: 'Siklus pengembangan, pengujian, dan manajemen proyek.', ikon: Icons.engineering, warna: Colors.cyan),
];

String rupiah(int angka) {
  final s = angka.toString();
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return 'Rp $buf';
}

// ======================= APLIKASI =======================
class AplikasiKatalog extends StatelessWidget {
  const AplikasiKatalog({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Katalog Buku',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.green, useMaterial3: true),
      // Named route
      initialRoute: '/',
      routes: {
        '/': (context) => const HalamanUtama(),
        '/tentang': (context) => const HalamanTentang(),
      },
    );
  }
}

// ============ HALAMAN UTAMA: 3 halaman + BottomNavigationBar ============
class HalamanUtama extends StatefulWidget {
  const HalamanUtama({super.key});

  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  int _tab = 0;
  final Set<int> _favorit = {};

  void _ubahFavorit(int id) {
    setState(() {
      if (!_favorit.add(id)) _favorit.remove(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final judul = ['Beranda', 'Katalog', 'Profil'][_tab];

    return Scaffold(
      appBar: AppBar(
        title: Text(judul),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Tentang',
            onPressed: () => Navigator.pushNamed(context, '/tentang'),
          ),
        ],
      ),
      // IndexedStack: posisi gulir tiap halaman dipertahankan
      body: IndexedStack(
        index: _tab,
        children: [
          HalamanBeranda(
            favorit: _favorit,
            onPindah: (i) => setState(() => _tab = i),
          ),
          HalamanKatalog(favorit: _favorit, onFavorit: _ubahFavorit),
          HalamanProfil(jumlahFavorit: _favorit.length),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Katalog'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

// ======================= HALAMAN 1: BERANDA =======================
class HalamanBeranda extends StatelessWidget {
  final Set<int> favorit;
  final ValueChanged<int> onPindah;

  const HalamanBeranda({super.key, required this.favorit, required this.onPindah});

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;
    final terbaru = daftarBuku.take(3).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner dengan Stack
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    Container(
                      height: 160,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.green.shade700, Colors.green.shade300],
                        ),
                      ),
                    ),
                    const Positioned(
                      right: -10,
                      bottom: -10,
                      child: Icon(Icons.menu_book, size: 130, color: Colors.white24),
                    ),
                    const Positioned(
                      left: 20,
                      top: 24,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Katalog Buku Teknologi',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Koleksi buku untuk mahasiswa Teknik Komputer',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Statistik dengan Row + Expanded
              Row(
                children: [
                  Expanded(child: _Statistik(angka: '${daftarBuku.length}', label: 'Buku', ikon: Icons.book)),
                  const SizedBox(width: 12),
                  Expanded(child: _Statistik(angka: '${favorit.length}', label: 'Favorit', ikon: Icons.favorite)),
                ],
              ),
              const SizedBox(height: 20),

              const Text('Buku Pilihan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...terbaru.map(
                (b) => Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: b.warna.withValues(alpha: 0.2),
                      child: Icon(b.ikon, color: b.warna),
                    ),
                    title: Text(b.judul),
                    subtitle: Text(b.penulis),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => HalamanDetail(buku: b)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => onPindah(1),
                  icon: const Icon(Icons.menu_book),
                  label: const Text('Lihat Semua Katalog'),
                ),
              ),
              const SizedBox(height: 4),
              Text('', style: TextStyle(color: warna.outline)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Statistik extends StatelessWidget {
  final String angka;
  final String label;
  final IconData ikon;

  const _Statistik({required this.angka, required this.label, required this.ikon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(ikon, size: 28),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(angka, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text(label),
            ],
          ),
        ],
      ),
    );
  }
}

// ======================= HALAMAN 2: KATALOG =======================
class HalamanKatalog extends StatefulWidget {
  final Set<int> favorit;
  final ValueChanged<int> onFavorit;

  const HalamanKatalog({super.key, required this.favorit, required this.onFavorit});

  @override
  State<HalamanKatalog> createState() => _HalamanKatalogState();
}

class _HalamanKatalogState extends State<HalamanKatalog> {
  bool _grid = true;
  String _pilihan = 'Semua';

  List<Buku> get _tampil => _pilihan == 'Semua'
      ? daftarBuku
      : daftarBuku.where((b) => b.kategori == _pilihan).toList();

  // Halaman yang MENGEMBALIKAN nilai ke halaman pemanggil
  Future<void> _pilihKategori() async {
    final hasil = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => HalamanPilihKategori(terpilih: _pilihan)),
    );
    if (hasil != null) {
      setState(() => _pilihan = hasil);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _tampil;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pilihKategori,
                  icon: const Icon(Icons.filter_list),
                  label: Text('Kategori: $_pilihan', overflow: TextOverflow.ellipsis),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filledTonal(
                tooltip: _grid ? 'Tampilan daftar' : 'Tampilan grid',
                onPressed: () => setState(() => _grid = !_grid),
                icon: Icon(_grid ? Icons.view_list : Icons.grid_view),
              ),
            ],
          ),
        ),
        Expanded(
          child: data.isEmpty
              ? const Center(child: Text('Tidak ada buku'))
              : _grid
                  ? _bangunGrid(data)
                  : _bangunDaftar(data),
        ),
      ],
    );
  }

  // GridView responsif: LayoutBuilder (2 / 3 / 4 kolom)
  Widget _bangunGrid(List<Buku> data) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int kolom = 2;
        if (constraints.maxWidth >= 900) {
          kolom = 4;
        } else if (constraints.maxWidth >= 600) {
          kolom = 3;
        }
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: kolom,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemCount: data.length,
          itemBuilder: (context, index) => KartuBuku(
            buku: data[index],
            favorit: widget.favorit.contains(data[index].id),
            onFavorit: () => widget.onFavorit(data[index].id),
          ),
        );
      },
    );
  }

  Widget _bangunDaftar(List<Buku> data) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final b = data[index];
        final fav = widget.favorit.contains(b.id);
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: b.warna.withValues(alpha: 0.2),
              child: Icon(b.ikon, color: b.warna),
            ),
            title: Text(b.judul),
            subtitle: Text('${b.penulis} | ${rupiah(b.harga)}'),
            trailing: IconButton(
              icon: Icon(fav ? Icons.favorite : Icons.favorite_border,
                  color: fav ? Colors.red : null),
              onPressed: () => widget.onFavorit(b.id),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => HalamanDetail(buku: b)),
            ),
          ),
        );
      },
    );
  }
}

class KartuBuku extends StatelessWidget {
  final Buku buku;
  final bool favorit;
  final VoidCallback onFavorit;

  const KartuBuku({
    super.key,
    required this.buku,
    required this.favorit,
    required this.onFavorit,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => HalamanDetail(buku: buku)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: buku.warna.withValues(alpha: 0.18),
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: Center(child: Icon(buku.ikon, size: 52, color: buku.warna)),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton(
                      icon: Icon(favorit ? Icons.favorite : Icons.favorite_border,
                          color: favorit ? Colors.red : Colors.black54),
                      onPressed: onFavorit,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    buku.judul,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    buku.penulis,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    rupiah(buku.harga),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================= HALAMAN 3: PROFIL =======================
class HalamanProfil extends StatelessWidget {
  final int jumlahFavorit;

  const HalamanProfil({super.key, required this.jumlahFavorit});

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            children: [
              const SizedBox(height: 8),
              CircleAvatar(
                radius: 52,
                backgroundColor: warna.primaryContainer,
                child: Icon(Icons.person, size: 52, color: warna.primary),
              ),
              const SizedBox(height: 12),
              const Text(
                'Dharma Putra',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text('Teknik Komputer', style: TextStyle(color: warna.primary)),
              const SizedBox(height: 20),
              Card(
                child: Column(
                  children: [
                    const ListTile(
                      leading: Icon(Icons.badge),
                      title: Text('NIM'),
                      subtitle: Text('20246312108'),
                    ),
                    const Divider(height: 1),
                    const ListTile(
                      leading: Icon(Icons.school),
                      title: Text('Program Studi'),
                      subtitle: Text('Teknik Komputer'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.favorite),
                      title: const Text('Buku favorit'),
                      subtitle: Text('$jumlahFavorit buku'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============ HALAMAN DETAIL: menerima data lewat konstruktor ============
class HalamanDetail extends StatelessWidget {
  final Buku buku;

  const HalamanDetail({super.key, required this.buku});

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(buku.judul)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: buku.warna.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(buku.ikon, size: 90, color: buku.warna),
                ),
                const SizedBox(height: 20),
                Text(
                  buku.judul,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text('oleh ${buku.penulis}'),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    Chip(label: Text(buku.kategori)),
                    Chip(label: Text('ID ${buku.id}')),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  rupiah(buku.harga),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: warna.primary,
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Deskripsi', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(buku.deskripsi, style: const TextStyle(fontSize: 16, height: 1.5)),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Kembali'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ====== HALAMAN YANG MENGEMBALIKAN NILAI ke halaman pemanggil ======
class HalamanPilihKategori extends StatelessWidget {
  final String terpilih;

  const HalamanPilihKategori({super.key, required this.terpilih});

  @override
  Widget build(BuildContext context) {
    final kategori = [
      'Semua',
      ...{for (final b in daftarBuku) b.kategori},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Kategori')),
      body: ListView(
        children: kategori
            .map(
              (k) => ListTile(
                title: Text(k),
                leading: Icon(
                  k == terpilih
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                ),
                // Mengembalikan nilai ke halaman pemanggil
                onTap: () => Navigator.pop(context, k),
              ),
            )
            .toList(),
      ),
    );
  }
}

// ======================= HALAMAN TENTANG (named route) =======================
class HalamanTentang extends StatelessWidget {
  const HalamanTentang({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tentang Aplikasi')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.menu_book, size: 64),
              SizedBox(height: 12),
              Text('Katalog Buku Teknologi',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Tugas Minggu 06: Layout dan Navigasi'),
              Text('Dharma Putra - 20246312108'),
            ],
          ),
        ),
      ),
    );
  }
}