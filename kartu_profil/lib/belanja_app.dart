import 'dart:ui';

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
  final Color latar,
      latar2,
      kaca,
      garis,
      aksen,
      aksen2,
      emas,
      teks,
      pudar,
      merah;

  const Palet({
    required this.latar,
    required this.latar2,
    required this.kaca,
    required this.garis,
    required this.aksen,
    required this.aksen2,
    required this.emas,
    required this.teks,
    required this.pudar,
    required this.merah,
  });

  static const gelap = Palet(
    latar: Color(0xFF06141A),
    latar2: Color(0xFF0D3039),
    kaca: Color(0x1AFFFFFF),
    garis: Color(0x2EFFFFFF),
    aksen: Color(0xFF5FE3C4),
    aksen2: Color(0xFF7CC6FF),
    emas: Color(0xFFF2D58A),
    teks: Color(0xFFFFFFFF),
    pudar: Color(0xB3FFFFFF),
    merah: Color(0xFFFF8A8A),
  );

  static const terang = Palet(
    latar: Color(0xFFEAF7F4),
    latar2: Color(0xFFCDEBEC),
    kaca: Color(0xB3FFFFFF),
    garis: Color(0x330B2A33),
    aksen: Color(0xFF0F9D86),
    aksen2: Color(0xFF1F7AB8),
    emas: Color(0xFF8F6F0E),
    teks: Color(0xFF0B2A33),
    pudar: Color(0xFF4F6F78),
    merah: Color(0xFFD64545),
  );
}

Palet paletDari(BuildContext context) =>
    context.watch<PengaturanModel>().gelap ? Palet.gelap : Palet.terang;

// Judul dan angka besar: serif
TextStyle serif(
  double ukuran,
  Color warna, {
  FontWeight berat = FontWeight.w500,
}) => GoogleFonts.cormorantGaramond(
  fontSize: ukuran,
  fontWeight: berat,
  color: warna,
  height: 1.05,
);

// Teks isi: sans modern
TextStyle isi(
  double ukuran,
  Color warna, {
  FontWeight berat = FontWeight.w500,
}) => GoogleFonts.inter(fontSize: ukuran, fontWeight: berat, color: warna);

// Label kecil huruf kapital
TextStyle label(double ukuran, Color warna) => GoogleFonts.inter(
  fontSize: ukuran,
  fontWeight: FontWeight.w600,
  color: warna,
  letterSpacing: 1.6,
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
  final List<String> _riwayat = [];

  Map<int, int> get isiKeranjang => Map.unmodifiable(_jumlahPerProduk);
  List<String> get riwayat => List.unmodifiable(_riwayat);

  int get jumlah => _jumlahPerProduk.values.fold<int>(0, (a, b) => a + b);

  int get total => _jumlahPerProduk.entries.fold<int>(0, (jml, e) {
    final produk = daftarProduk.firstWhere((p) => p.id == e.key);
    return jml + produk.harga * e.value;
  });

  int jumlahDari(int id) => _jumlahPerProduk[id] ?? 0;

  void _catat(String pesan) {
    _riwayat.insert(0, '[${jam(DateTime.now())}] $pesan');
    if (_riwayat.length > 10) _riwayat.removeLast();
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
          seedColor: p.aksen,
          brightness: gelap ? Brightness.dark : Brightness.light,
        ),
      ),
      home: const HalamanUtama(),
    );
  }
}

// ======================= KOMPONEN BERSAMA =======================

// Latar samudra: gradasi + cahaya lembut
class LatarSamudra extends StatelessWidget {
  final Widget child;
  const LatarSamudra({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final p = paletDari(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [p.latar2, p.latar],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -120,
            right: -80,
            child: Container(
              width: 340,
              height: 340,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [p.aksen.withOpacity(0.28), Colors.transparent],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -140,
            left: -100,
            child: Container(
              width: 360,
              height: 360,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [p.aksen2.withOpacity(0.22), Colors.transparent],
                ),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

// Kartu kaca (glassmorphism)
class Kaca extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double radius;
  final EdgeInsets margin;

  const Kaca({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = 22,
    this.margin = const EdgeInsets.only(bottom: 14),
  });

  @override
  Widget build(BuildContext context) {
    final p = paletDari(context);
    return Padding(
      padding: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: p.kaca,
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(color: p.garis),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

// Judul halaman gaya hero: label kecil + garis mint + judul serif besar
class JudulHero extends StatelessWidget {
  final String eyebrow;
  final String judul;
  final String? sub;

  const JudulHero({
    super.key,
    required this.eyebrow,
    required this.judul,
    this.sub,
  });

  @override
  Widget build(BuildContext context) {
    final p = paletDari(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 28, height: 1.5, color: p.aksen),
              const SizedBox(width: 10),
              Text(eyebrow.toUpperCase(), style: label(11, p.aksen)),
            ],
          ),
          const SizedBox(height: 12),
          Text(judul, style: serif(44, p.teks)),
          if (sub != null) ...[
            const SizedBox(height: 10),
            Text(sub!, style: isi(14, p.pudar)),
          ],
        ],
      ),
    );
  }
}

// Tombol pil mint dengan panah
class TombolPil extends StatelessWidget {
  final String teks;
  final IconData? ikon;
  final bool panah;
  final bool terisi;
  final Color? warna;
  final VoidCallback? onTap;

  const TombolPil({
    super.key,
    required this.teks,
    required this.onTap,
    this.ikon,
    this.panah = true,
    this.terisi = true,
    this.warna,
  });

  @override
  Widget build(BuildContext context) {
    final p = paletDari(context);
    final w = onTap == null ? p.pudar : (warna ?? p.aksen);
    final warnaTeks = terisi ? (p.latar) : w;

    return Material(
      color: terisi ? w : Colors.transparent,
      shape: StadiumBorder(side: BorderSide(color: w, width: 1.2)),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (ikon != null) ...[
                Icon(ikon, size: 18, color: warnaTeks),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  teks,
                  overflow: TextOverflow.ellipsis,
                  style: isi(13.5, warnaTeks, berat: FontWeight.w700),
                ),
              ),
              if (panah) ...[
                const SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 16, color: warnaTeks),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// Badge keranjang di AppBar
class BadgeKeranjang extends StatelessWidget {
  const BadgeKeranjang({super.key});

  @override
  Widget build(BuildContext context) {
    final jumlah = context.watch<KeranjangModel>().jumlah;
    final p = paletDari(context);

    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: p.kaca,
        border: Border.all(color: p.garis),
      ),
      child: Center(
        child: Badge(
          isLabelVisible: jumlah > 0,
          backgroundColor: p.aksen,
          textColor: p.latar,
          label: Text(
            '$jumlah',
            style: isi(10, p.latar, berat: FontWeight.w800),
          ),
          child: Icon(Icons.shopping_bag_outlined, color: p.teks),
        ),
      ),
    );
  }
}

// Daftar riwayat (dipakai di tab Hitung dan Keranjang)
class DaftarRiwayat extends StatelessWidget {
  final String judul;
  final List<String> data;

  const DaftarRiwayat({super.key, required this.judul, required this.data});

  @override
  Widget build(BuildContext context) {
    final p = paletDari(context);
    return Kaca(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.history, color: p.aksen, size: 20),
              const SizedBox(width: 8),
              Text(judul.toUpperCase(), style: label(11, p.aksen)),
              const Spacer(),
              Text('${data.length}/10', style: isi(12, p.pudar)),
            ],
          ),
          const SizedBox(height: 10),
          if (data.isEmpty)
            Text('Belum ada riwayat.', style: isi(14, p.pudar))
          else
            for (final baris in data)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Text(baris, style: isi(13.5, p.teks)),
              ),
        ],
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

  @override
  Widget build(BuildContext context) {
    final p = paletDari(context);

    return Scaffold(
      extendBody: true,
      body: LatarSamudra(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Header: logo di kiri, badge keranjang di kanan
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.shopping_basket_outlined,
                      color: p.aksen,
                      size: 30,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'BELANJA',
                          style: GoogleFonts.inter(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: p.teks,
                            letterSpacing: 3,
                          ),
                        ),
                        Text(
                          'PILIH. HITUNG. BAYAR.',
                          style: GoogleFonts.inter(
                            fontSize: 9,
                            color: p.pudar,
                            letterSpacing: 2.2,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const BadgeKeranjang(),
                  ],
                ),
              ),
              Expanded(
                child: IndexedStack(
                  index: _tab,
                  children: const [
                    HalamanPenghitung(),
                    HalamanLifting(),
                    HalamanKatalog(),
                    HalamanKeranjang(),
                    HalamanPengaturan(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // Navigasi kaca melayang
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: p.kaca,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: p.garis),
                ),
                child: NavigationBarTheme(
                  data: NavigationBarThemeData(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    height: 66,
                    indicatorColor: p.aksen.withOpacity(0.2),
                    labelTextStyle: WidgetStateProperty.resolveWith(
                      (s) => isi(
                        10,
                        s.contains(WidgetState.selected) ? p.aksen : p.pudar,
                        berat: FontWeight.w600,
                      ),
                    ),
                    iconTheme: WidgetStateProperty.resolveWith(
                      (s) => IconThemeData(
                        color: s.contains(WidgetState.selected)
                            ? p.aksen
                            : p.pudar,
                      ),
                    ),
                  ),
                  child: NavigationBar(
                    selectedIndex: _tab,
                    onDestinationSelected: (i) => setState(() => _tab = i),
                    destinations: const [
                      NavigationDestination(
                        icon: Icon(Icons.calculate_outlined),
                        label: 'Hitung',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.account_tree_outlined),
                        label: 'Lifting',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.storefront_outlined),
                        label: 'Katalog',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.shopping_bag_outlined),
                        label: 'Keranjang',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.tune),
                        label: 'Setelan',
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
    if (_nilai == 0) return; // tidak boleh di bawah nol
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

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 110),
      children: [
        const JudulHero(
          eyebrow: 'Praktikum 1 • setState',
          judul: 'Hitung Setiap\nLangkahmu',
          sub: 'Nilai tidak akan turun di bawah nol.',
        ),
        Kaca(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              Text('NILAI SAAT INI', style: label(11, p.pudar)),
              const SizedBox(height: 6),
              Text(
                '$_nilai',
                style: serif(88, p.aksen, berat: FontWeight.w600),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  TombolPil(
                    teks: 'Kurang',
                    ikon: Icons.remove,
                    panah: false,
                    terisi: false,
                    warna: p.merah,
                    onTap: _nilai == 0 ? null : _kurang,
                  ),
                  TombolPil(
                    teks: 'Tambah',
                    ikon: Icons.add,
                    panah: false,
                    onTap: _tambah,
                  ),
                  TombolPil(
                    teks: 'Reset',
                    ikon: Icons.refresh,
                    panah: false,
                    terisi: false,
                    warna: p.aksen2,
                    onTap: _reset,
                  ),
                ],
              ),
            ],
          ),
        ),
        DaftarRiwayat(judul: 'Riwayat perubahan', data: _riwayat),
      ],
    );
  }
}

// ======================= PRAKTIKUM 2: LIFTING STATE UP =======================
// Data disimpan di INDUK. Dua anak bersaudara hanya menerima data dan callback.
class HalamanLifting extends StatefulWidget {
  const HalamanLifting({super.key});

  @override
  State<HalamanLifting> createState() => _HalamanLiftingState();
}

class _HalamanLiftingState extends State<HalamanLifting> {
  final List<String> _item = [];

  void _tambah(String nama) => setState(() => _item.add(nama));
  void _hapus(int index) => setState(() => _item.removeAt(index));

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 110),
      children: [
        const JudulHero(
          eyebrow: 'Praktikum 2 • Lifting state up',
          judul: 'Satu Data,\nDua Widget',
          sub: 'Data berada di induk, anak hanya menerima data dan aksi.',
        ),
        DaftarProdukLifting(onTambah: _tambah),
        RingkasanLifting(item: _item, onHapus: _hapus),
      ],
    );
  }
}

class DaftarProdukLifting extends StatelessWidget {
  final ValueChanged<String> onTambah;
  const DaftarProdukLifting({super.key, required this.onTambah});

  @override
  Widget build(BuildContext context) {
    final p = paletDari(context);
    return Kaca(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('DAFTAR PRODUK', style: label(11, p.aksen)),
          const SizedBox(height: 6),
          for (final produk in daftarProduk.take(5))
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Icon(produk.ikon, color: p.aksen),
              title: Text(
                produk.nama,
                style: isi(14.5, p.teks, berat: FontWeight.w600),
              ),
              subtitle: Text(rupiah(produk.harga), style: isi(12.5, p.emas)),
              trailing: IconButton(
                icon: Icon(Icons.add_circle_outline, color: p.aksen),
                onPressed: () => onTambah(produk.nama),
              ),
            ),
        ],
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
    return Kaca(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('RINGKASAN KERANJANG', style: label(11, p.aksen2)),
              const Spacer(),
              Text(
                '${item.length} item',
                style: isi(12.5, p.emas, berat: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (item.isEmpty)
            Text(
              'Belum ada item. Tekan + pada daftar produk.',
              style: isi(14, p.pudar),
            )
          else
            for (int i = 0; i < item.length; i++)
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  '${i + 1}. ${item[i]}',
                  style: isi(14.5, p.teks, berat: FontWeight.w600),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete_outline, color: p.merah),
                  onPressed: () => onHapus(i),
                ),
              ),
        ],
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
    final keranjang = context.watch<KeranjangModel>();
    final hasil = daftarProduk
        .where((x) => x.nama.toLowerCase().contains(_kataKunci.toLowerCase()))
        .toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 110),
      children: [
        const JudulHero(
          eyebrow: 'Kebutuhan harian',
          judul: 'Belanja Yang\nTetap Rapi',
          sub: 'Pilih produk, pantau total, dan bayar dalam satu tempat.',
        ),

        // Kolom pencarian kaca
        Kaca(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          radius: 18,
          child: TextField(
            controller: _cari,
            style: isi(15, p.teks),
            cursorColor: p.aksen,
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: p.aksen),
              hintText: 'Cari produk...',
              hintStyle: isi(14, p.pudar),
            ),
          ),
        ),

        // Baris statistik
        Kaca(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: _Statistik(
                  angka: '${daftarProduk.length}',
                  teks: 'Produk',
                ),
              ),
              Container(width: 1, height: 36, color: p.garis),
              Expanded(
                child: _Statistik(
                  angka: '${keranjang.jumlah}',
                  teks: 'Item dipilih',
                ),
              ),
              Container(width: 1, height: 36, color: p.garis),
              Expanded(
                child: _Statistik(
                  angka: rupiah(keranjang.total),
                  teks: 'Total',
                  kecil: true,
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(4, 6, 4, 10),
          child: Row(
            children: [
              Text('Produk Populer', style: serif(26, p.teks)),
              const Spacer(),
              Text('${hasil.length} hasil', style: isi(12, p.aksen)),
            ],
          ),
        ),

        if (hasil.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Center(
              child: Text('Produk tidak ditemukan', style: isi(15, p.pudar)),
            ),
          )
        else
          for (int i = 0; i < hasil.length; i++)
            KartuProduk(produk: hasil[i], indeks: i),
      ],
    );
  }
}

class _Statistik extends StatelessWidget {
  final String angka;
  final String teks;
  final bool kecil;
  const _Statistik({
    required this.angka,
    required this.teks,
    this.kecil = false,
  });

  @override
  Widget build(BuildContext context) {
    final p = paletDari(context);
    return Column(
      children: [
        Text(
          angka,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: serif(kecil ? 22 : 30, p.aksen, berat: FontWeight.w600),
        ),
        const SizedBox(height: 2),
        Text(teks, style: isi(11.5, p.pudar)),
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
    final warna = indeks.isEven ? p.aksen : p.aksen2;

    return Kaca(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [warna.withOpacity(0.45), warna.withOpacity(0.10)],
              ),
              border: Border.all(color: warna.withOpacity(0.5)),
            ),
            child: Icon(produk.ikon, color: p.teks, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  produk.nama,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: isi(15, p.teks, berat: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star_rounded, size: 14, color: p.emas),
                    const SizedBox(width: 3),
                    Text('4.${(produk.id % 4) + 6}', style: isi(12, p.pudar)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  rupiah(produk.harga),
                  style: serif(22, p.emas, berat: FontWeight.w700),
                ),
              ],
            ),
          ),
          if (jumlah == 0)
            TombolPil(
              teks: 'Tambah',
              // read: hanya memicu aksi
              onTap: () => context.read<KeranjangModel>().tambah(produk),
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
                Text(
                  '$jumlah',
                  style: serif(24, p.teks, berat: FontWeight.w700),
                ),
                IconButton(
                  icon: Icon(Icons.add_circle, color: warna),
                  onPressed: () =>
                      context.read<KeranjangModel>().tambah(produk),
                ),
              ],
            ),
        ],
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
    final List<MapEntry<int, int>> item = keranjang.isiKeranjang.entries
        .toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 110),
      children: [
        const JudulHero(
          eyebrow: 'Keranjang',
          judul: 'Pilihanmu,\nSiap Dibayar',
        ),
        if (item.isEmpty)
          Kaca(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Column(
              children: [
                Icon(
                  Icons.remove_shopping_cart_outlined,
                  size: 52,
                  color: p.aksen,
                ),
                const SizedBox(height: 12),
                Text('Keranjang masih kosong', style: serif(26, p.teks)),
                const SizedBox(height: 4),
                Text(
                  'Tambah produk dari tab Katalog.',
                  style: isi(14, p.pudar),
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
                return Kaca(
                  padding: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: p.aksen.withOpacity(0.18),
                      ),
                      child: Icon(produk.ikon, color: p.aksen),
                    ),
                    title: Text(
                      produk.nama,
                      style: isi(14.5, p.teks, berat: FontWeight.w700),
                    ),
                    subtitle: Text(
                      '$jumlah x ${rupiah(produk.harga)} = ${rupiah(subtotal)}',
                      style: isi(12.5, p.pudar),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete_outline, color: p.merah),
                      onPressed: () =>
                          context.read<KeranjangModel>().hapus(produk),
                    ),
                  ),
                );
              },
            ),

        // Ringkasan total
        Kaca(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${keranjang.jumlah} ITEM', style: label(11, p.pudar)),
              const SizedBox(height: 4),
              Text(
                rupiah(keranjang.total),
                style: serif(42, p.emas, berat: FontWeight.w700),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  TombolPil(
                    teks: 'Kosongkan',
                    ikon: Icons.delete_sweep_outlined,
                    panah: false,
                    terisi: false,
                    warna: p.merah,
                    onTap: item.isEmpty
                        ? null
                        : () => context.read<KeranjangModel>().kosongkan(),
                  ),
                  TombolPil(
                    teks: 'Bayar Sekarang',
                    onTap: item.isEmpty
                        ? null
                        : () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: p.latar2,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: BorderSide(color: p.aksen),
                                ),
                                content: Text(
                                  'Terima kasih, belanja selesai!',
                                  style: isi(14, Colors.white),
                                ),
                              ),
                            );
                            context.read<KeranjangModel>().kosongkan(
                              alasan: 'Pembayaran selesai',
                            );
                          },
                  ),
                ],
              ),
            ],
          ),
        ),

        // Riwayat aktivitas keranjang (maks. 10)
        DaftarRiwayat(judul: 'Riwayat aktivitas', data: keranjang.riwayat),
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
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 110),
      children: [
        const JudulHero(
          eyebrow: 'Pengaturan',
          judul: 'Atur Suasana\nAplikasimu',
          sub: 'Pilihan tema berlaku untuk seluruh halaman.',
        ),
        Kaca(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: SwitchListTile(
            activeColor: p.aksen,
            secondary: Icon(
              gelap ? Icons.dark_mode : Icons.light_mode,
              color: p.aksen,
            ),
            title: Text(
              gelap ? 'Tema Samudra (gelap)' : 'Tema Pagi (terang)',
              style: isi(15, p.teks, berat: FontWeight.w700),
            ),
            subtitle: Text(
              'Berlaku untuk seluruh halaman aplikasi',
              style: isi(12.5, p.pudar),
            ),
            value: gelap,
            onChanged: (nilai) =>
                context.read<PengaturanModel>().ubahTema(nilai),
          ),
        ),
        // Consumer: hanya kartu ini yang dibangun ulang
        Consumer<KeranjangModel>(
          builder: (context, keranjang, _) => Kaca(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.shopping_bag_outlined, color: p.aksen2),
              title: Text(
                'Item di keranjang',
                style: isi(15, p.teks, berat: FontWeight.w700),
              ),
              subtitle: Text(
                '${keranjang.jumlah} item',
                style: isi(13, p.pudar),
              ),
            ),
          ),
        ),
        Kaca(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.person_outline, color: p.emas),
            title: Text(
              'Dharma Putra',
              style: isi(15, p.teks, berat: FontWeight.w700),
            ),
            subtitle: Text(
              '20246312108 - Teknik Komputer',
              style: isi(13, p.pudar),
            ),
          ),
        ),
      ],
    );
  }
}
