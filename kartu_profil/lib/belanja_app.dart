import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => KeranjangModel()),
        ChangeNotifierProvider(create: (_) => PengaturanModel()),
      ],
      child: const AplikasiBelanja(),
    ),
  );
}

// ======================= PALET =======================
class Palet {
  final Color latar, panel, panel2, cyan, magenta, kuning, teks, pudar, merah;

  const Palet({
    required this.latar,
    required this.panel,
    required this.panel2,
    required this.cyan,
    required this.magenta,
    required this.kuning,
    required this.teks,
    required this.pudar,
    required this.merah,
  });

  static const gelap = Palet(
    latar: Color(0xFF0A0614),
    panel: Color(0xFF140B26),
    panel2: Color(0xFF1C1038),
    cyan: Color(0xFF00F0FF),
    magenta: Color(0xFFFF2BD6),
    kuning: Color(0xFFFCEE0A),
    teks: Color(0xFFEAF6FF),
    pudar: Color(0xFF8E86B8),
    merah: Color(0xFFFF3B5C),
  );

  static const terang = Palet(
    latar: Color(0xFFF1EEFB),
    panel: Color(0xFFFFFFFF),
    panel2: Color(0xFFE6E0FA),
    cyan: Color(0xFF007C89),
    magenta: Color(0xFFC1049D),
    kuning: Color(0xFF8A7B00),
    teks: Color(0xFF1B1235),
    pudar: Color(0xFF6C6590),
    merah: Color(0xFFD31F45),
  );
}

Palet paletDari(BuildContext context) =>
    context.watch<PengaturanModel>().gelap ? Palet.gelap : Palet.terang;

TextStyle judulStyle(double ukuran, Color warna, {double spasi = 1.8}) =>
    GoogleFonts.orbitron(
      fontSize: ukuran,
      fontWeight: FontWeight.w900,
      color: warna,
      letterSpacing: spasi,
    );

TextStyle isiStyle(double ukuran, Color warna) => GoogleFonts.rajdhani(
  fontSize: ukuran,
  fontWeight: FontWeight.w700,
  color: warna,
);

List<BoxShadow> glow(Color warna, {double kuat = 0.35}) => [
  BoxShadow(color: warna.withOpacity(kuat), blurRadius: 14),
];

ShapeBorder bentukSiku(Color warna, {double garis = 1.5}) =>
    BeveledRectangleBorder(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(14),
        bottomRight: Radius.circular(14),
      ),
      side: BorderSide(color: warna, width: garis),
    );

// ======================= MODEL DATA =======================
class Produk {
  final int id;
  final String nama;
  final int harga;
  final IconData ikon;
  const Produk(this.id, this.nama, this.harga, this.ikon);
}

const daftarProduk = [
  Produk(1, 'Beras 5 kg', 68000, Icons.rice_bowl),
  Produk(2, 'Minyak Goreng 1 L', 18000, Icons.opacity),
  Produk(3, 'Telur 1 kg', 30000, Icons.egg),
  Produk(4, 'Susu UHT', 7000, Icons.local_drink),
  Produk(5, 'Roti Tawar', 15000, Icons.bakery_dining),
  Produk(6, 'Kopi Bubuk', 22000, Icons.coffee),
  Produk(7, 'Gula 1 kg', 17000, Icons.cookie),
  Produk(8, 'Sabun Mandi', 5000, Icons.soap),
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

String jam(DateTime t) =>
    '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}:${t.second.toString().padLeft(2, '0')}';

// ======================= STATE: KERANJANG (Provider) =======================
class KeranjangModel extends ChangeNotifier {
  final Map<int, int> _jumlahPerProduk = {};
  final List<String> _riwayat = []; // riwayat aktivitas keranjang

  Map<int, int> get isi => Map.unmodifiable(_jumlahPerProduk);
  List<String> get riwayat => List.unmodifiable(_riwayat);

  int get jumlah => _jumlahPerProduk.values.fold<int>(0, (a, b) => a + b);

  int get total => _jumlahPerProduk.entries.fold<int>(0, (jml, e) {
    final produk = daftarProduk.firstWhere((p) => p.id == e.key);
    return jml + produk.harga * e.value;
  });

  int jumlahDari(int id) => _jumlahPerProduk[id] ?? 0;

  void _catat(String pesan) {
    _riwayat.insert(0, '[${jam(DateTime.now())}] $pesan');
    if (_riwayat.length > 10) _riwayat.removeLast(); // simpan 10 terakhir
  }

  void tambah(Produk p) {
    _jumlahPerProduk[p.id] = jumlahDari(p.id) + 1;
    _catat('Tambah ${p.nama}');
    notifyListeners();
  }

  void kurang(Produk p) {
    final sekarang = jumlahDari(p.id);
    if (sekarang <= 1) {
      _jumlahPerProduk.remove(p.id);
    } else {
      _jumlahPerProduk[p.id] = sekarang - 1;
    }
    _catat('Kurang ${p.nama}');
    notifyListeners();
  }

  void hapus(Produk p) {
    _jumlahPerProduk.remove(p.id);
    _catat('Hapus ${p.nama}');
    notifyListeners();
  }

  void kosongkan({String alasan = 'Keranjang dikosongkan'}) {
    _jumlahPerProduk.clear();
    _catat(alasan);
    notifyListeners();
  }
}

// ======================= STATE: PENGATURAN (Provider) =======================
class PengaturanModel extends ChangeNotifier {
  bool _gelap = true;
  bool get gelap => _gelap;

  void ubahTema(bool nilai) {
    _gelap = nilai;
    notifyListeners();
  }
}

// ======================= APLIKASI =======================
class AplikasiBelanja extends StatelessWidget {
  const AplikasiBelanja({super.key});

  @override
  Widget build(BuildContext context) {
    final gelap = context.watch<PengaturanModel>().gelap;
    final p = gelap ? Palet.gelap : Palet.terang;

    return MaterialApp(
      title: 'Minggu 10 - State Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: gelap ? Brightness.dark : Brightness.light,
        scaffoldBackgroundColor: p.latar,
        colorScheme: ColorScheme.fromSeed(
          seedColor: p.cyan,
          brightness: gelap ? Brightness.dark : Brightness.light,
        ),
      ),
      home: const HalamanUtama(),
    );
  }
}

// ======================= KOMPONEN BERSAMA =======================
class BadgeKeranjang extends StatelessWidget {
  const BadgeKeranjang({super.key});

  @override
  Widget build(BuildContext context) {
    final jumlah = context.watch<KeranjangModel>().jumlah;
    final p = paletDari(context);

    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: p.magenta, width: 1.4),
          boxShadow: jumlah > 0 ? glow(p.magenta, kuat: 0.5) : null,
        ),
        child: Badge(
          isLabelVisible: jumlah > 0,
          backgroundColor: p.kuning,
          textColor: Colors.black,
          label: Text(
            '$jumlah',
            style: GoogleFonts.orbitron(
              fontWeight: FontWeight.w900,
              fontSize: 11,
            ),
          ),
          child: Icon(Icons.shopping_cart, color: p.magenta),
        ),
      ),
    );
  }
}

class TombolNeon extends StatelessWidget {
  final String label;
  final IconData ikon;
  final Color warna;
  final VoidCallback? onTap;
  final bool isi;

  const TombolNeon({
    super.key,
    required this.label,
    required this.ikon,
    required this.warna,
    required this.onTap,
    this.isi = true,
  });

  @override
  Widget build(BuildContext context) {
    final p = paletDari(context);
    final w = onTap == null ? p.pudar : warna;

    return Container(
      decoration: BoxDecoration(
        boxShadow: onTap == null ? null : glow(w, kuat: 0.3),
      ),
      child: Material(
        color: isi ? w : Colors.transparent,
        shape: bentukSiku(w),
        child: InkWell(
          customBorder: bentukSiku(w),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(ikon, size: 18, color: isi ? p.latar : w),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    label.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    style: judulStyle(11, isi ? p.latar : w, spasi: 1.4),
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

// Kartu neon umum
Widget kartuNeon(
  Palet p,
  Color warna,
  Widget isi, {
  EdgeInsets margin = const EdgeInsets.only(bottom: 12),
}) {
  return Container(
    margin: margin,
    decoration: BoxDecoration(boxShadow: glow(warna, kuat: 0.18)),
    child: Material(color: p.panel, shape: bentukSiku(warna), child: isi),
  );
}

// Daftar riwayat (dipakai di tab Hitung dan Keranjang)
class DaftarRiwayat extends StatelessWidget {
  final String judul;
  final List<String> data;
  final Color warna;

  const DaftarRiwayat({
    super.key,
    required this.judul,
    required this.data,
    required this.warna,
  });

  @override
  Widget build(BuildContext context) {
    final p = paletDari(context);
    return kartuNeon(
      p,
      warna,
      Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.history, color: warna, size: 20),
                const SizedBox(width: 8),
                Text(
                  judul.toUpperCase(),
                  style: judulStyle(12, warna, spasi: 1.4),
                ),
                const Spacer(),
                Text(
                  '${data.length}/10',
                  style: judulStyle(11, p.pudar, spasi: 1),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (data.isEmpty)
              Text('Belum ada riwayat.', style: isiStyle(17, p.pudar))
            else
              for (final baris in data)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(baris, style: isiStyle(16, p.teks)),
                ),
          ],
        ),
      ),
    );
  }
}

// ======================= HALAMAN UTAMA (5 tab) =======================
class HalamanUtama extends StatefulWidget {
  const HalamanUtama({super.key});

  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  int _tab = 0; // state lokal: hanya dipakai di sini

  static const _judul = [
    'Penghitung',
    'Lifting State',
    'Katalog',
    'Keranjang',
    'Setelan',
  ];

  @override
  Widget build(BuildContext context) {
    final p = paletDari(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(66),
        child: Container(
          decoration: BoxDecoration(
            color: p.panel,
            border: Border(bottom: BorderSide(color: p.cyan, width: 2)),
            boxShadow: glow(p.cyan, kuat: 0.3),
          ),
          child: SafeArea(
            bottom: false,
            child: SizedBox(
              height: 64,
              child: Row(
                children: [
                  const SizedBox(width: 18),
                  Icon(Icons.bolt, color: p.kuning),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _judul[_tab].toUpperCase(),
                      overflow: TextOverflow.ellipsis,
                      style: judulStyle(17, p.cyan),
                    ),
                  ),
                  const BadgeKeranjang(),
                ],
              ),
            ),
          ),
        ),
      ),
      body: IndexedStack(
        index: _tab,
        children: const [
          HalamanPenghitung(),
          HalamanLifting(),
          HalamanKatalog(),
          HalamanKeranjang(),
          HalamanPengaturan(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: p.panel,
          border: Border(top: BorderSide(color: p.magenta, width: 2)),
          boxShadow: glow(p.magenta, kuat: 0.25),
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: Colors.transparent,
            indicatorColor: p.cyan.withOpacity(0.2),
            labelTextStyle: WidgetStateProperty.resolveWith(
              (s) => judulStyle(
                8.5,
                s.contains(WidgetState.selected) ? p.cyan : p.pudar,
                spasi: 0.6,
              ),
            ),
            iconTheme: WidgetStateProperty.resolveWith(
              (s) => IconThemeData(
                color: s.contains(WidgetState.selected) ? p.cyan : p.pudar,
              ),
            ),
          ),
          child: NavigationBar(
            selectedIndex: _tab,
            onDestinationSelected: (i) => setState(() => _tab = i),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.calculate),
                label: 'HITUNG',
              ),
              NavigationDestination(
                icon: Icon(Icons.account_tree),
                label: 'LIFTING',
              ),
              NavigationDestination(
                icon: Icon(Icons.storefront),
                label: 'KATALOG',
              ),
              NavigationDestination(
                icon: Icon(Icons.shopping_cart),
                label: 'KERANJANG',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings),
                label: 'SETELAN',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ======================= PRAKTIKUM 1: PENGHITUNG (setState) =======================
class HalamanPenghitung extends StatefulWidget {
  const HalamanPenghitung({super.key});

  @override
  State<HalamanPenghitung> createState() => _HalamanPenghitungState();
}

class _HalamanPenghitungState extends State<HalamanPenghitung> {
  int _nilai = 0;
  final List<String> _riwayat = []; // sepuluh perubahan terakhir

  void _catat(String aksi) {
    _riwayat.insert(0, '[${jam(DateTime.now())}] $aksi  ->  $_nilai');
    if (_riwayat.length > 10) _riwayat.removeLast();
  }

  void _tambah() => setState(() {
    _nilai++;
    _catat('Tambah (+1)');
  });

  void _kurang() {
    // Nilai tidak boleh turun di bawah nol
    if (_nilai == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nilai tidak boleh di bawah nol')),
      );
      return;
    }
    setState(() {
      _nilai--;
      _catat('Kurang (-1)');
    });
  }

  void _reset() => setState(() {
    _nilai = 0;
    _catat('Reset');
  });

  @override
  Widget build(BuildContext context) {
    final p = paletDari(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            children: [
              kartuNeon(
                p,
                p.cyan,
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        'NILAI SAAT INI',
                        style: judulStyle(11, p.pudar, spasi: 2),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$_nilai',
                        style: judulStyle(64, p.kuning, spasi: 0),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: TombolNeon(
                              label: 'Kurang',
                              ikon: Icons.remove,
                              warna: p.merah,
                              isi: false,
                              onTap: _nilai == 0 ? null : _kurang,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TombolNeon(
                              label: 'Tambah',
                              ikon: Icons.add,
                              warna: p.cyan,
                              onTap: _tambah,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TombolNeon(
                              label: 'Reset',
                              ikon: Icons.refresh,
                              warna: p.magenta,
                              isi: false,
                              onTap: _reset,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              DaftarRiwayat(
                judul: 'Riwayat perubahan',
                data: _riwayat,
                warna: p.magenta,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ======================= PRAKTIKUM 2: LIFTING STATE UP =======================
// Data keranjang disimpan di INDUK (_HalamanLiftingState). Dua anak
// bersaudara hanya menerima data dan callback.
class HalamanLifting extends StatefulWidget {
  const HalamanLifting({super.key});

  @override
  State<HalamanLifting> createState() => _HalamanLiftingState();
}

class _HalamanLiftingState extends State<HalamanLifting> {
  final List<String> _item = []; // state diangkat ke induk

  void _tambah(String nama) => setState(() => _item.add(nama));
  void _hapus(int index) => setState(() => _item.removeAt(index));

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            children: [
              // Anak 1: hanya menerima aksi, tidak menyimpan data
              DaftarProdukLifting(onTambah: _tambah),
              // Anak 2: hanya menerima data dan aksi hapus
              RingkasanLifting(item: _item, onHapus: _hapus),
            ],
          ),
        ),
      ),
    );
  }
}

class DaftarProdukLifting extends StatelessWidget {
  final ValueChanged<String> onTambah;
  const DaftarProdukLifting({super.key, required this.onTambah});

  @override
  Widget build(BuildContext context) {
    final p = paletDari(context);
    return kartuNeon(
      p,
      p.cyan,
      Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('DAFTAR PRODUK', style: judulStyle(12, p.cyan, spasi: 1.4)),
            const SizedBox(height: 8),
            for (final produk in daftarProduk.take(5))
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: Icon(produk.ikon, color: p.cyan),
                title: Text(produk.nama, style: isiStyle(18, p.teks)),
                subtitle: Text(
                  rupiah(produk.harga),
                  style: isiStyle(15, p.kuning),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.add_circle, color: p.magenta),
                  onPressed: () => onTambah(produk.nama),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class RingkasanLifting extends StatelessWidget {
  final List<String> item;
  final ValueChanged<int> onHapus;
  const RingkasanLifting({
    super.key,
    required this.item,
    required this.onHapus,
  });

  @override
  Widget build(BuildContext context) {
    final p = paletDari(context);
    return kartuNeon(
      p,
      p.magenta,
      Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'RINGKASAN KERANJANG',
                  style: judulStyle(12, p.magenta, spasi: 1.4),
                ),
                const Spacer(),
                Text(
                  '${item.length} ITEM',
                  style: judulStyle(11, p.kuning, spasi: 1),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (item.isEmpty)
              Text(
                'Belum ada item. Tekan + pada daftar produk.',
                style: isiStyle(17, p.pudar),
              )
            else
              for (int i = 0; i < item.length; i++)
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    '${i + 1}. ${item[i]}',
                    style: isiStyle(18, p.teks),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete_forever, color: p.merah),
                    onPressed: () => onHapus(i),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

// ======================= PRAKTIKUM 3 + TUGAS: KATALOG (Provider) =======================
class HalamanKatalog extends StatefulWidget {
  const HalamanKatalog({super.key});

  @override
  State<HalamanKatalog> createState() => _HalamanKatalogState();
}

class _HalamanKatalogState extends State<HalamanKatalog> {
  late final TextEditingController _cari;
  String _kataKunci = '';

  @override
  void initState() {
    super.initState();
    _cari = TextEditingController();
    _cari.addListener(() => setState(() => _kataKunci = _cari.text));
  }

  @override
  void dispose() {
    _cari.dispose(); // wajib: mencegah kebocoran memori
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = paletDari(context);
    final hasil = daftarProduk
        .where((x) => x.nama.toLowerCase().contains(_kataKunci.toLowerCase()))
        .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(14),
          child: TextField(
            controller: _cari,
            style: isiStyle(19, p.teks),
            cursorColor: p.cyan,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search, color: p.cyan),
              hintText: 'CARI PRODUK...',
              hintStyle: judulStyle(12, p.pudar, spasi: 1.4),
              filled: true,
              fillColor: p.panel,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: p.cyan.withOpacity(0.5)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: p.cyan, width: 2),
              ),
            ),
          ),
        ),
        Expanded(
          child: hasil.isEmpty
              ? Center(
                  child: Text(
                    'PRODUK TIDAK DITEMUKAN',
                    style: judulStyle(14, p.magenta),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  itemCount: hasil.length,
                  itemBuilder: (context, i) =>
                      KartuProduk(produk: hasil[i], indeks: i),
                ),
        ),
      ],
    );
  }
}

class KartuProduk extends StatelessWidget {
  final Produk produk;
  final int indeks;
  const KartuProduk({super.key, required this.produk, required this.indeks});

  @override
  Widget build(BuildContext context) {
    final p = paletDari(context);
    final jumlah = context.watch<KeranjangModel>().jumlahDari(produk.id);
    final warna = indeks.isEven ? p.cyan : p.magenta;

    return kartuNeon(
      p,
      warna,
      Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: p.panel2,
                border: Border.all(color: warna, width: 1.4),
              ),
              child: Icon(produk.ikon, color: warna),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produk.nama.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: judulStyle(12.5, warna, spasi: 1),
                  ),
                  const SizedBox(height: 4),
                  Text(rupiah(produk.harga), style: isiStyle(18, p.kuning)),
                ],
              ),
            ),
            if (jumlah == 0)
              SizedBox(
                width: 112,
                child: TombolNeon(
                  label: 'Tambah',
                  ikon: Icons.add_shopping_cart,
                  warna: warna,
                  // read: hanya memicu aksi
                  onTap: () => context.read<KeranjangModel>().tambah(produk),
                ),
              )
            else
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove_circle_outline, color: p.merah),
                    onPressed: () =>
                        context.read<KeranjangModel>().kurang(produk),
                  ),
                  Text('$jumlah', style: judulStyle(16, p.teks, spasi: 0)),
                  IconButton(
                    icon: Icon(Icons.add_circle, color: warna),
                    onPressed: () =>
                        context.read<KeranjangModel>().tambah(produk),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

// ======================= TUGAS: KERANJANG =======================
class HalamanKeranjang extends StatelessWidget {
  const HalamanKeranjang({super.key});

  @override
  Widget build(BuildContext context) {
    final p = paletDari(context);
    final keranjang = context.watch<KeranjangModel>();
    final List<MapEntry<int, int>> item = keranjang.isi.entries.toList();

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(14),
            children: [
              if (item.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    children: [
                      Icon(
                        Icons.remove_shopping_cart,
                        size: 56,
                        color: p.magenta,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'KERANJANG KOSONG',
                        style: judulStyle(16, p.magenta),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tambah produk dari tab Katalog.',
                        style: isiStyle(17, p.pudar),
                      ),
                    ],
                  ),
                )
              else
                for (int i = 0; i < item.length; i++)
                  Builder(
                    builder: (context) {
                      final produk = daftarProduk.firstWhere(
                        (x) => x.id == item[i].key,
                      );
                      final int jumlah = item[i].value;
                      final int subtotal = produk.harga * jumlah;
                      final warna = i.isEven ? p.cyan : p.magenta;
                      return kartuNeon(
                        p,
                        warna,
                        ListTile(
                          leading: Icon(produk.ikon, color: warna, size: 30),
                          title: Text(
                            produk.nama.toUpperCase(),
                            style: judulStyle(12.5, warna, spasi: 1),
                          ),
                          subtitle: Text(
                            '$jumlah x ${rupiah(produk.harga)} = ${rupiah(subtotal)}',
                            style: isiStyle(17, p.teks),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete_forever, color: p.merah),
                            onPressed: () =>
                                context.read<KeranjangModel>().hapus(produk),
                          ),
                        ),
                      );
                    },
                  ),
              // Riwayat aktivitas keranjang (maks. 10)
              DaftarRiwayat(
                judul: 'Riwayat aktivitas',
                data: keranjang.riwayat,
                warna: p.kuning,
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: p.panel,
            border: Border(top: BorderSide(color: p.kuning, width: 2)),
            boxShadow: glow(p.kuning, kuat: 0.2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${keranjang.jumlah} ITEM',
                style: judulStyle(11, p.pudar, spasi: 2),
              ),
              const SizedBox(height: 2),
              Text(
                'TOTAL ${rupiah(keranjang.total)}',
                style: judulStyle(22, p.kuning, spasi: 1),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TombolNeon(
                      label: 'Kosongkan',
                      ikon: Icons.delete_sweep,
                      warna: p.merah,
                      isi: false,
                      onTap: item.isEmpty
                          ? null
                          : () => context.read<KeranjangModel>().kosongkan(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TombolNeon(
                      label: 'Bayar',
                      ikon: Icons.payments,
                      warna: p.cyan,
                      onTap: item.isEmpty
                          ? null
                          : () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: p.panel2,
                                  behavior: SnackBarBehavior.floating,
                                  shape: bentukSiku(p.cyan),
                                  content: Text(
                                    'Terima kasih, belanja selesai!',
                                    style: isiStyle(17, p.teks),
                                  ),
                                ),
                              );
                              context.read<KeranjangModel>().kosongkan(
                                alasan: 'Pembayaran selesai',
                              );
                            },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ======================= TUGAS: PENGATURAN =======================
class HalamanPengaturan extends StatelessWidget {
  const HalamanPengaturan({super.key});

  @override
  Widget build(BuildContext context) {
    final p = paletDari(context);
    final gelap = context.watch<PengaturanModel>().gelap;

    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        kartuNeon(
          p,
          p.cyan,
          SwitchListTile(
            activeColor: p.cyan,
            secondary: Icon(
              gelap ? Icons.dark_mode : Icons.light_mode,
              color: p.cyan,
            ),
            title: Text(
              gelap ? 'CYBER NEON (GELAP)' : 'CYBER LIGHT (TERANG)',
              style: judulStyle(12.5, p.cyan, spasi: 1),
            ),
            subtitle: Text(
              'Berlaku untuk seluruh halaman aplikasi',
              style: isiStyle(16, p.pudar),
            ),
            value: gelap,
            onChanged: (nilai) =>
                context.read<PengaturanModel>().ubahTema(nilai),
          ),
        ),
        // Consumer: hanya kartu ini yang dibangun ulang
        Consumer<KeranjangModel>(
          builder: (context, keranjang, _) => kartuNeon(
            p,
            p.magenta,
            ListTile(
              leading: Icon(Icons.shopping_cart, color: p.magenta),
              title: Text(
                'ITEM DI KERANJANG',
                style: judulStyle(12.5, p.magenta, spasi: 1),
              ),
              subtitle: Text(
                '${keranjang.jumlah} item',
                style: isiStyle(17, p.teks),
              ),
            ),
          ),
        ),
        kartuNeon(
          p,
          p.kuning,
          ListTile(
            leading: Icon(Icons.person, color: p.kuning),
            title: Text(
              'DHARMA PUTRA',
              style: judulStyle(12.5, p.kuning, spasi: 1),
            ),
            subtitle: Text(
              '20246312108 - Teknik Komputer',
              style: isiStyle(17, p.teks),
            ),
          ),
        ),
      ],
    );
  }
}
