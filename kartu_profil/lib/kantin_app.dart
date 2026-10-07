import 'package:flutter/material.dart';

void main() {
  runApp(const AplikasiKantin());
}

// Mengubah teks menjadi angka. Melempar FormatException bila tidak valid.
int bacaAngka(String teks) {
  if (teks.trim().isEmpty) {
    throw const FormatException('Masukan tidak boleh kosong');
  }
  return int.parse(teks.trim());
}

// switch: memproses pilihan menu
({String nama, int harga}) cariMenu(int pilihan) {
  switch (pilihan) {
    case 1:
      return (nama: 'Nasi Goreng', harga: 15000);
    case 2:
      return (nama: 'Mie Ayam', harga: 12000);
    case 3:
      return (nama: 'Soto Ayam', harga: 13000);
    case 4:
      return (nama: 'Es Teh', harga: 4000);
    case 5:
      return (nama: 'Jus Jeruk', harga: 8000);
    default:
      throw RangeError('Pilihan $pilihan tidak ada di menu');
  }
}

String rupiah(int angka) {
  final s = angka.toString();
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return 'Rp $buf';
}

class ItemPesanan {
  final String nama;
  final int harga;
  int jumlah;
  ItemPesanan(this.nama, this.harga, this.jumlah);
  int get subtotal => harga * jumlah;
}

class AplikasiKantin extends StatelessWidget {
  const AplikasiKantin({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menu Kantin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.green, useMaterial3: true),
      home: const HalamanKantin(),
    );
  }
}

class HalamanKantin extends StatefulWidget {
  const HalamanKantin({super.key});

  @override
  State<HalamanKantin> createState() => _HalamanKantinState();
}

class _HalamanKantinState extends State<HalamanKantin> {
  final _kontrolMenu = TextEditingController();
  final _kontrolJumlah = TextEditingController(text: '1');
  final List<ItemPesanan> _pesanan = [];
  String? _pesanError;

  int get _total => _pesanan.fold(0, (jumlah, item) => jumlah + item.subtotal);

  // Tambah pesanan lewat kotak input (try-catch untuk masukan tidak valid)
  void _tambahDariInput() {
    try {
      final pilihan = bacaAngka(_kontrolMenu.text);
      final jumlah = bacaAngka(_kontrolJumlah.text);
      if (jumlah <= 0) {
        throw ArgumentError('Jumlah harus lebih dari 0');
      }
      _tambah(pilihan, jumlah);
      setState(() {
        _pesanError = null;
        _kontrolMenu.clear();
        _kontrolJumlah.text = '1';
      });
    } on FormatException catch (e) {
      setState(() => _pesanError = 'Masukkan angka yang valid (${e.message})');
    } on RangeError catch (e) {
      setState(() => _pesanError = '${e.message}');
    } on ArgumentError catch (e) {
      setState(() => _pesanError = '${e.message}');
    } catch (e) {
      setState(() => _pesanError = 'Error tak terduga: $e');
    }
  }

  void _tambah(int pilihan, int jumlah) {
    final menu = cariMenu(pilihan);
    final ada = _pesanan.where((p) => p.nama == menu.nama);
    setState(() {
      if (ada.isNotEmpty) {
        ada.first.jumlah += jumlah;
      } else {
        _pesanan.add(ItemPesanan(menu.nama, menu.harga, jumlah));
      }
    });
  }

  void _hapus(ItemPesanan item) {
    setState(() => _pesanan.remove(item));
  }

  void _bayar() {
    final diskon = _total >= 50000 ? _total ~/ 10 : 0;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Struk Pembayaran'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ..._pesanan.map(
              (p) => Text('${p.jumlah} x ${p.nama}  ${rupiah(p.subtotal)}'),
            ),
            const Divider(),
            Text('Total belanja : ${rupiah(_total)}'),
            if (diskon > 0) Text('Diskon 10%    : ${rupiah(diskon)}'),
            const SizedBox(height: 4),
            Text(
              'Total bayar   : ${rupiah(_total - diskon)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _pesanan.clear());
            },
            child: const Text('Selesai'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _kontrolMenu.dispose();
    _kontrolJumlah.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;
    // Daftar menu ditampilkan dengan perulangan (for) lewat collection for
    const daftarMenu = [
      (1, 'Nasi Goreng', 15000),
      (2, 'Mie Ayam', 12000),
      (3, 'Soto Ayam', 13000),
      (4, 'Es Teh', 4000),
      (5, 'Jus Jeruk', 8000),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Kantin'),
        centerTitle: true,
        backgroundColor: warna.primaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Dharma Putra - 20246312108',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),

                // ===== DAFTAR MENU =====
                Card(
                  child: Column(
                    children: [
                      for (final m in daftarMenu)
                        ListTile(
                          leading: CircleAvatar(child: Text('${m.$1}')),
                          title: Text(m.$2),
                          subtitle: Text(rupiah(m.$3)),
                          trailing: IconButton(
                            icon: const Icon(Icons.add_circle),
                            color: warna.primary,
                            onPressed: () {
                              _tambah(m.$1, 1);
                              setState(() => _pesanError = null);
                            },
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ===== INPUT MANUAL =====
                const Text(
                  'Atau ketik nomor menu',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _kontrolMenu,
                        decoration: const InputDecoration(
                          labelText: 'No. menu',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 90,
                      child: TextField(
                        controller: _kontrolJumlah,
                        decoration: const InputDecoration(
                          labelText: 'Jumlah',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: _tambahDariInput,
                      child: const Text('Tambah'),
                    ),
                  ],
                ),
                if (_pesanError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _pesanError!,
                      style: TextStyle(color: warna.error),
                    ),
                  ),
                const SizedBox(height: 16),

                // ===== PESANAN =====
                const Text(
                  'Pesanan Anda',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                if (_pesanan.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('Belum ada pesanan'),
                  )
                else
                  ..._pesanan.map(
                    (p) => Card(
                      child: ListTile(
                        title: Text('${p.jumlah} x ${p.nama}'),
                        subtitle: Text(rupiah(p.subtotal)),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => _hapus(p),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: warna.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Total belanja: ${rupiah(_total)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _pesanan.isEmpty ? null : _bayar,
                    icon: const Icon(Icons.payments),
                    label: const Text('Bayar'),
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