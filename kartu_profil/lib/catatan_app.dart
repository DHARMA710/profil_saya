import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const AplikasiCatatan());
}

// ======================= PALET CYBERPUNK x HALLOWEEN =======================
class Neon {
  static const latar = Color(0xFF0A0614);
  static const panel = Color(0xFF140B26);
  static const panel2 = Color(0xFF1C1038);
  static const cyan = Color(0xFF00F0FF);
  static const magenta = Color(0xFFFF2BD6);
  static const kuning = Color(0xFFFCEE0A);
  static const oranye = Color(0xFFFF7A00);
  static const teks = Color(0xFFEAF6FF);
  static const pudar = Color(0xFF8E86B8);
  static const merah = Color(0xFFFF3B5C);
}

TextStyle judulNeon(
  double ukuran, {
  Color warna = Neon.cyan,
  double spasi = 2,
}) => GoogleFonts.orbitron(
  fontSize: ukuran,
  fontWeight: FontWeight.w900,
  color: warna,
  letterSpacing: spasi,
);

TextStyle isiNeon(double ukuran, {Color warna = Neon.teks}) =>
    GoogleFonts.rajdhani(
      fontSize: ukuran,
      fontWeight: FontWeight.w700,
      color: warna,
    );

List<BoxShadow> glow(Color warna, {double kuat = 0.45}) => [
  BoxShadow(color: warna.withOpacity(kuat), blurRadius: 14, spreadRadius: 0.5),
];

ShapeBorder bentukSiku(Color warna, {double garis = 1.6}) =>
    BeveledRectangleBorder(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(14),
        bottomRight: Radius.circular(14),
      ),
      side: BorderSide(color: warna, width: garis),
    );

// ======================= MODEL =======================
class Catatan {
  final int id;
  String judul;
  String isi;
  Uint8List? foto;

  Catatan({
    required this.id,
    required this.judul,
    required this.isi,
    this.foto,
  });
}

bool get _mobile =>
    !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS);

bool get kameraTersedia =>
    kIsWeb || _mobile || defaultTargetPlatform == TargetPlatform.windows;

// Membuka foto layar penuh
void bukaFoto(BuildContext context, Uint8List foto, String judul) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => HalamanFoto(foto: foto, judul: judul),
    ),
  );
}

// ======================= APLIKASI =======================
class AplikasiCatatan extends StatelessWidget {
  const AplikasiCatatan({super.key});

  @override
  Widget build(BuildContext context) {
    const skema = ColorScheme.dark(
      primary: Neon.cyan,
      onPrimary: Colors.black,
      secondary: Neon.magenta,
      onSecondary: Colors.black,
      surface: Neon.panel,
      onSurface: Neon.teks,
      error: Neon.merah,
    );

    return MaterialApp(
      title: 'Catatan Bergambar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: skema,
        scaffoldBackgroundColor: Neon.latar,
      ),
      // Animasi Halloween dipasang di atas seluruh halaman
      builder: (context, child) => HalloweenLatar(child: child!),
      home: const HalamanDaftar(),
    );
  }
}

// ======================= ANIMASI HALLOWEEN =======================
class HalloweenLatar extends StatefulWidget {
  final Widget child;
  const HalloweenLatar({super.key, required this.child});

  @override
  State<HalloweenLatar> createState() => _HalloweenLatarState();
}

class _HalloweenLatarState extends State<HalloweenLatar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  // (posisi y 0..1, kecepatan terbang, fase)
  static const _kelelawar = [
    (0.10, 1, 0.00),
    (0.22, 2, 0.35),
    (0.40, 1, 0.65),
    (0.58, 3, 0.15),
    (0.74, 2, 0.80),
  ];

  // (posisi x 0..1, posisi y 0..1, fase)
  static const _hantu = [
    (0.08, 0.30, 0.00),
    (0.86, 0.50, 0.40),
    (0.18, 0.78, 0.70),
    (0.72, 0.84, 0.20),
  ];

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 24))
      ..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: IgnorePointer(
            child: LayoutBuilder(
              builder: (context, box) {
                final w = box.maxWidth;
                final h = box.maxHeight;
                return AnimatedBuilder(
                  animation: _c,
                  builder: (context, _) {
                    final t = _c.value;
                    final denyut = (math.sin(2 * math.pi * t * 6) + 1) / 2;
                    final panjangBenang =
                        50 + 40 * (math.sin(2 * math.pi * t * 5) + 1) / 2;

                    return Stack(
                      clipBehavior: Clip.hardEdge,
                      children: [
                        // Bulan berdenyut
                        Positioned(
                          right: 22,
                          top: 78,
                          child: Opacity(
                            opacity: 0.55,
                            child: Container(
                              width: 54,
                              height: 54,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFFFD27A),
                                boxShadow: [
                                  BoxShadow(
                                    color: Neon.oranye.withOpacity(
                                      0.35 + 0.35 * denyut,
                                    ),
                                    blurRadius: 18 + 18 * denyut,
                                    spreadRadius: 2 + 4 * denyut,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Laba-laba turun naik
                        Positioned(
                          left: 36,
                          top: 0,
                          child: Opacity(
                            opacity: 0.7,
                            child: Column(
                              children: [
                                Container(
                                  width: 1.5,
                                  height: panjangBenang,
                                  color: Colors.white54,
                                ),
                                const Text(
                                  '🕷️',
                                  style: TextStyle(fontSize: 26),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Kelelawar terbang melintas
                        for (final k in _kelelawar)
                          Positioned(
                            left: ((t * k.$2 + k.$3) % 1.0) * (w + 120) - 60,
                            top:
                                h * k.$1 +
                                math.sin(2 * math.pi * (t * 3 + k.$3 * 6)) * 18,
                            child: Opacity(
                              opacity: 0.5,
                              child: Transform.scale(
                                scaleY:
                                    0.55 +
                                    0.45 * math.sin(2 * math.pi * t * 40).abs(),
                                child: const Text(
                                  '🦇',
                                  style: TextStyle(fontSize: 30),
                                ),
                              ),
                            ),
                          ),

                        // Hantu melayang
                        for (final g in _hantu)
                          Positioned(
                            left:
                                w * g.$1 +
                                math.sin(2 * math.pi * (t * 3 + g.$3)) * 14,
                            top:
                                h * g.$2 +
                                math.sin(2 * math.pi * (t * 4 + g.$3)) * 22,
                            child: Opacity(
                              opacity:
                                  0.28 +
                                  0.2 *
                                      (math.sin(2 * math.pi * (t * 5 + g.$3)) +
                                          1) /
                                      2,
                              child: const Text(
                                '👻',
                                style: TextStyle(fontSize: 40),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

// Widget yang bergoyang (untuk labu)
class Goyang extends StatefulWidget {
  final Widget child;
  final double sudut;
  const Goyang({super.key, required this.child, this.sudut = 0.18});

  @override
  State<Goyang> createState() => _GoyangState();
}

class _GoyangState extends State<Goyang> with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final kurva = CurvedAnimation(parent: _c, curve: Curves.easeInOut);
    return AnimatedBuilder(
      animation: kurva,
      builder: (context, child) => Transform.rotate(
        angle: (kurva.value - 0.5) * 2 * widget.sudut,
        child: child,
      ),
      child: widget.child,
    );
  }
}

// ======================= KOMPONEN BERSAMA =======================
class AppBarNeon extends StatelessWidget implements PreferredSizeWidget {
  final String judul;
  final List<Widget> aksi;
  final bool kembali;

  const AppBarNeon({
    super.key,
    required this.judul,
    this.aksi = const [],
    this.kembali = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Neon.panel,
        border: const Border(bottom: BorderSide(color: Neon.oranye, width: 2)),
        boxShadow: glow(Neon.oranye, kuat: 0.35),
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 62,
          child: Row(
            children: [
              if (kembali)
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Neon.cyan),
                  onPressed: () => Navigator.maybePop(context),
                )
              else
                const SizedBox(width: 16),
              Expanded(
                child: Text(
                  judul.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: judulNeon(18, warna: Neon.oranye),
                ),
              ),
              ...aksi,
              const SizedBox(width: 8),
            ],
          ),
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
    required this.onTap,
    this.warna = Neon.cyan,
    this.isi = true,
  });

  @override
  Widget build(BuildContext context) {
    final aktif = onTap != null;
    final w = aktif ? warna : Neon.pudar;

    return Container(
      decoration: BoxDecoration(boxShadow: aktif ? glow(w, kuat: 0.35) : null),
      child: Material(
        color: isi ? w : Colors.transparent,
        shape: bentukSiku(w),
        child: InkWell(
          customBorder: bentukSiku(w),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(ikon, size: 20, color: isi ? Colors.black : w),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    label.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.orbitron(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                      color: isi ? Colors.black : w,
                    ),
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

InputDecoration kolomNeon(String label, {Color warna = Neon.cyan}) =>
    InputDecoration(
      labelText: label.toUpperCase(),
      labelStyle: GoogleFonts.orbitron(
        fontSize: 12,
        fontWeight: FontWeight.w900,
        color: warna,
        letterSpacing: 1.5,
      ),
      alignLabelWithHint: true,
      filled: true,
      fillColor: Neon.panel,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: warna.withOpacity(0.55), width: 1.4),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: warna, width: 2.2),
      ),
    );

// ======================= LAYAR FOTO PENUH =======================
class HalamanFoto extends StatelessWidget {
  final Uint8List foto;
  final String judul;

  const HalamanFoto({super.key, required this.foto, required this.judul});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBarNeon(judul: judul.isEmpty ? 'Foto' : judul, kembali: true),
      body: Column(
        children: [
          Expanded(
            child: Center(
              // Cubit atau scroll mouse untuk zoom, geser untuk memindahkan
              child: InteractiveViewer(
                minScale: 0.8,
                maxScale: 6,
                child: Image.memory(foto, fit: BoxFit.contain),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'CUBIT / SCROLL UNTUK ZOOM  •  GESER UNTUK MEMINDAH',
              textAlign: TextAlign.center,
              style: judulNeon(10, warna: Neon.pudar, spasi: 1),
            ),
          ),
        ],
      ),
    );
  }
}

// ======================= DAFTAR CATATAN =======================
class HalamanDaftar extends StatefulWidget {
  const HalamanDaftar({super.key});

  @override
  State<HalamanDaftar> createState() => _HalamanDaftarState();
}

class _HalamanDaftarState extends State<HalamanDaftar> {
  final List<Catatan> _catatan = [];

  Future<void> _tambah() async {
    final hasil = await Navigator.push<Catatan>(
      context,
      MaterialPageRoute(builder: (_) => const HalamanEditor(baru: true)),
    );
    if (hasil == null || !mounted) return;
    setState(() => _catatan.insert(0, hasil));
  }

  Future<void> _edit(Catatan asal) async {
    final hasil = await Navigator.push<Catatan>(
      context,
      MaterialPageRoute(builder: (_) => HalamanEditor(catatan: asal)),
    );
    if (hasil == null || !mounted) return;
    setState(() {
      final i = _catatan.indexWhere((c) => c.id == hasil.id);
      if (i >= 0) _catatan[i] = hasil;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarNeon(
        judul: 'Catatan Bergambar',
        aksi: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Neon.magenta, width: 1.4),
            ),
            child: Text(
              '${_catatan.length} DATA',
              style: GoogleFonts.orbitron(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: Neon.magenta,
              ),
            ),
          ),
        ],
      ),
      body: _catatan.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Goyang(
                      child: Text('🎃', style: TextStyle(fontSize: 76)),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'DATABASE KOSONG',
                      textAlign: TextAlign.center,
                      style: judulNeon(20, warna: Neon.oranye),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ketuk labu di kanan bawah untuk menyimpan catatan.',
                      textAlign: TextAlign.center,
                      style: isiNeon(18, warna: Neon.pudar),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(14),
              itemCount: _catatan.length,
              itemBuilder: (context, i) {
                final c = _catatan[i];
                final warna = i.isEven ? Neon.cyan : Neon.magenta;
                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(boxShadow: glow(warna, kuat: 0.22)),
                  child: Material(
                    color: Neon.panel,
                    shape: bentukSiku(warna),
                    child: InkWell(
                      customBorder: bentukSiku(warna),
                      onTap: () => _edit(c),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            // Foto bisa diketuk untuk dibuka layar penuh
                            GestureDetector(
                              onTap: c.foto == null
                                  ? null
                                  : () => bukaFoto(context, c.foto!, c.judul),
                              child: MouseRegion(
                                cursor: c.foto == null
                                    ? SystemMouseCursors.basic
                                    : SystemMouseCursors.click,
                                child: Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: warna,
                                      width: 1.6,
                                    ),
                                    color: Neon.panel2,
                                  ),
                                  child: c.foto == null
                                      ? Icon(
                                          Icons.notes,
                                          color: warna,
                                          size: 28,
                                        )
                                      : Image.memory(
                                          c.foto!,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    c.judul.toUpperCase(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: judulNeon(
                                      14,
                                      warna: warna,
                                      spasi: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    c.isi.isEmpty ? '— tanpa isi —' : c.isi,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: isiNeon(16),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_forever,
                                color: Neon.merah,
                              ),
                              tooltip: 'Hapus',
                              onPressed: () => setState(
                                () => _catatan.removeWhere((x) => x.id == c.id),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: Goyang(
        sudut: 0.12,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: glow(Neon.oranye, kuat: 0.65),
          ),
          child: FloatingActionButton(
            onPressed: _tambah,
            backgroundColor: Neon.oranye,
            foregroundColor: Colors.black,
            shape: const CircleBorder(),
            child: const Text('🎃', style: TextStyle(fontSize: 30)),
          ),
        ),
      ),
    );
  }
}

// ======================= EDITOR CATATAN =======================
class HalamanEditor extends StatefulWidget {
  final Catatan? catatan;
  final bool baru;

  const HalamanEditor({super.key, this.catatan, this.baru = false});

  @override
  State<HalamanEditor> createState() => _HalamanEditorState();
}

class _HalamanEditorState extends State<HalamanEditor> {
  final _picker = ImagePicker();
  late final TextEditingController _judul;
  late final TextEditingController _isi;
  Uint8List? _foto;
  bool _memproses = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _judul = TextEditingController(text: widget.catatan?.judul ?? '');
    _isi = TextEditingController(text: widget.catatan?.isi ?? '');
    _foto = widget.catatan?.foto;
  }

  @override
  void dispose() {
    _judul.dispose();
    _isi.dispose();
    super.dispose();
  }

  Future<bool> _izinKamera() async {
    if (!_mobile) return true;

    final status = await Permission.camera.request();
    if (status.isGranted) return true;
    if (!mounted) return false;

    if (status.isPermanentlyDenied) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: Neon.panel,
          shape: bentukSiku(Neon.cyan),
          title: Text(
            'IZIN KAMERA DIBLOKIR',
            style: judulNeon(15, warna: Neon.merah),
          ),
          content: Text(
            'Kamera dipakai untuk memotret gambar yang dilampirkan pada catatan. '
            'Izin ditolak permanen, aktifkan lewat pengaturan aplikasi.',
            style: isiNeon(17),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('BATAL', style: judulNeon(12, warna: Neon.pudar)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                openAppSettings();
              },
              child: Text('BUKA PENGATURAN', style: judulNeon(12)),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Neon.panel2,
          behavior: SnackBarBehavior.floating,
          shape: bentukSiku(Neon.magenta),
          content: Text(
            'Izin kamera dibutuhkan untuk memotret lampiran catatan.',
            style: isiNeon(16),
          ),
          action: SnackBarAction(
            label: 'COBA LAGI',
            textColor: Neon.cyan,
            onPressed: _bukaKamera,
          ),
        ),
      );
    }
    return false;
  }

  Future<void> _bukaKamera() async {
    if (_memproses) return;
    if (!await _izinKamera()) return;
    if (!mounted) return;

    final bytes = await Navigator.push<Uint8List>(
      context,
      MaterialPageRoute(builder: (_) => const HalamanKamera()),
    );
    if (bytes == null || !mounted) return;
    setState(() {
      _foto = bytes;
      _error = null;
    });
  }

  Future<void> _bukaGaleri() async {
    if (_memproses) return;
    setState(() {
      _memproses = true;
      _error = null;
    });
    try {
      final berkas = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1280,
      );
      if (berkas == null) return;
      final bytes = await berkas.readAsBytes();
      if (!mounted) return;
      setState(() => _foto = bytes);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = 'Gagal memilih gambar. Coba lagi.');
    } finally {
      if (mounted) setState(() => _memproses = false);
    }
  }

  void _simpan() {
    final judul = _judul.text.trim();
    if (judul.isEmpty) {
      setState(() => _error = 'Judul catatan wajib diisi');
      return;
    }
    Navigator.pop(
      context,
      Catatan(
        id: widget.catatan?.id ?? DateTime.now().millisecondsSinceEpoch,
        judul: judul,
        isi: _isi.text.trim(),
        foto: _foto,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarNeon(
        judul: widget.baru ? 'Catatan Baru' : 'Edit Catatan',
        kembali: true,
        aksi: [
          IconButton(
            icon: const Icon(Icons.check_circle, color: Neon.kuning, size: 30),
            tooltip: 'Simpan',
            onPressed: _memproses ? null : _simpan,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _judul,
                  style: isiNeon(20),
                  cursorColor: Neon.cyan,
                  decoration: kolomNeon('Judul'),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _isi,
                  maxLines: 5,
                  style: isiNeon(19),
                  cursorColor: Neon.magenta,
                  decoration: kolomNeon('Isi catatan', warna: Neon.magenta),
                ),
                const SizedBox(height: 18),

                // Area foto: ketuk untuk membuka layar penuh
                GestureDetector(
                  onTap: (_foto == null || _memproses)
                      ? null
                      : () => bukaFoto(context, _foto!, _judul.text.trim()),
                  child: MouseRegion(
                    cursor: _foto == null
                        ? SystemMouseCursors.basic
                        : SystemMouseCursors.click,
                    child: Container(
                      height: 220,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Neon.panel,
                        border: Border.all(color: Neon.kuning, width: 1.8),
                        boxShadow: glow(Neon.kuning, kuat: 0.25),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (_foto != null)
                            Image.memory(_foto!, fit: BoxFit.cover)
                          else
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.image_outlined,
                                    size: 48,
                                    color: Neon.kuning,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'BELUM ADA FOTO',
                                    style: judulNeon(13, warna: Neon.kuning),
                                  ),
                                ],
                              ),
                            ),
                          if (_foto != null)
                            Positioned(
                              right: 8,
                              bottom: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                color: Colors.black87,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.zoom_out_map,
                                      size: 14,
                                      color: Neon.cyan,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'KETUK UNTUK MEMBESARKAN',
                                      style: judulNeon(9, spasi: 1),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (_memproses)
                            Container(
                              color: Colors.black87,
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const CircularProgressIndicator(
                                      color: Neon.cyan,
                                    ),
                                    const SizedBox(height: 14),
                                    Text(
                                      'MEMPROSES GAMBAR...',
                                      style: judulNeon(13),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                Row(
                  children: [
                    if (kameraTersedia) ...[
                      Expanded(
                        child: TombolNeon(
                          label: 'Kamera',
                          ikon: Icons.camera_alt,
                          onTap: _memproses ? null : _bukaKamera,
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                    Expanded(
                      child: TombolNeon(
                        label: 'Galeri',
                        ikon: Icons.photo_library,
                        warna: Neon.magenta,
                        isi: false,
                        onTap: _memproses ? null : _bukaGaleri,
                      ),
                    ),
                    if (_foto != null) ...[
                      const SizedBox(width: 6),
                      IconButton(
                        tooltip: 'Hapus foto',
                        onPressed: _memproses
                            ? null
                            : () => setState(() => _foto = null),
                        icon: const Icon(
                          Icons.delete_forever,
                          color: Neon.merah,
                        ),
                      ),
                    ],
                  ],
                ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber, color: Neon.merah),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _error!,
                            style: isiNeon(17, warna: Neon.merah),
                          ),
                        ),
                      ],
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

// ======================= HALAMAN KAMERA (pratinjau live) =======================
class HalamanKamera extends StatefulWidget {
  const HalamanKamera({super.key});

  @override
  State<HalamanKamera> createState() => _HalamanKameraState();
}

class _HalamanKameraState extends State<HalamanKamera>
    with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _kamera = [];
  int _indeks = 0;
  String? _pesanError;
  bool _mengambil = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _siapkan();
  }

  Future<void> _siapkan() async {
    final lama = _controller;
    if (lama != null) {
      setState(() => _controller = null);
      await lama.dispose();
    }

    try {
      if (_kamera.isEmpty) {
        _kamera = await availableCameras();
      }
      if (_kamera.isEmpty) {
        if (!mounted) return;
        setState(
          () => _pesanError = 'Tidak ada kamera pada perangkat ini. Colok webcam atau uji di HP Android.',
        );
        return;
      }

      final controller = CameraController(
        _kamera[_indeks % _kamera.length],
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await controller.initialize();

      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() {
        _controller = controller;
        _pesanError = null;
      });
    } on CameraException catch (e) {
      debugPrint('CameraException: ${e.code} - ${e.description}');
      if (!mounted) return;
      final ditolak = e.code.contains('AccessDenied');
      setState(() {
        _pesanError = ditolak
            ? 'Akses kamera ditolak. Kamera dipakai untuk memotret lampiran catatan. '
                  'Aktifkan izin kamera di pengaturan (Windows: Settings > Privacy & security > Camera).'
            : 'Kamera gagal disiapkan.\n\nKode: ${e.code}\n${e.description ?? ''}';
      });
    } catch (e) {
      debugPrint('Error kamera: $e');
      if (!mounted) return;
      setState(
        () => _pesanError = 'Terjadi kesalahan saat membuka kamera.\n\n$e',
      );
    }
  }

  Future<void> _ganti() async {
    if (_kamera.length < 2 || _mengambil) return;
    _indeks = (_indeks + 1) % _kamera.length;
    await _siapkan();
  }

  Future<void> _ambilFoto() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    if (_mengambil || controller.value.isTakingPicture) return;

    setState(() => _mengambil = true);
    try {
      final berkas = await controller.takePicture();
      final bytes = await berkas.readAsBytes();
      if (!mounted) return;
      Navigator.pop(context, bytes);
    } on CameraException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengambil gambar: ${e.description ?? e.code}'),
        ),
      );
    } finally {
      if (mounted) setState(() => _mengambil = false);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      setState(() => _controller = null);
      controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _siapkan();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;

    Widget isi;
    if (_pesanError != null) {
      isi = Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.no_photography, size: 52, color: Neon.merah),
              const SizedBox(height: 14),
              Text('KAMERA OFFLINE', style: judulNeon(18, warna: Neon.merah)),
              const SizedBox(height: 10),
              Text(
                _pesanError!,
                textAlign: TextAlign.center,
                style: isiNeon(17),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: 200,
                child: TombolNeon(
                  label: 'Coba lagi',
                  ikon: Icons.refresh,
                  onTap: () {
                    setState(() => _pesanError = null);
                    _siapkan();
                  },
                ),
              ),
            ],
          ),
        ),
      );
    } else if (controller == null) {
      isi = const Center(child: CircularProgressIndicator(color: Neon.cyan));
    } else {
      isi = Center(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Neon.cyan, width: 2),
            boxShadow: glow(Neon.cyan, kuat: 0.4),
          ),
          child: CameraPreview(controller),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBarNeon(
        judul: 'Kamera',
        kembali: true,
        aksi: [
          if (_kamera.length > 1)
            IconButton(
              tooltip: 'Ganti kamera',
              icon: const Icon(Icons.cameraswitch, color: Neon.magenta),
              onPressed: _ganti,
            ),
        ],
      ),
      body: isi,
      floatingActionButton: controller == null
          ? null
          : Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: glow(Neon.magenta, kuat: 0.6),
              ),
              child: FloatingActionButton.large(
                onPressed: _mengambil ? null : _ambilFoto,
                backgroundColor: Neon.magenta,
                foregroundColor: Colors.black,
                shape: const CircleBorder(),
                child: _mengambil
                    ? const CircularProgressIndicator(color: Colors.black)
                    : const Icon(Icons.camera_alt, size: 36),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
