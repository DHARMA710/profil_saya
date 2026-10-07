// Tugas Minggu 02 - Poin 2: Class Produk
// Nama : Dharma Putra
// NIM  : 20246312108

class Produk {
  final String nama;
  final double harga;
  final double? diskon; // opsional, dalam persen (null = tanpa diskon)

  Produk({required this.nama, required this.harga, this.diskon});

  // Getter: harga akhir setelah diskon
  double get hargaAkhir {
    final potongan = diskon ?? 0; // null-aware: pakai 0 bila tidak ada diskon
    return harga - (harga * potongan / 100);
  }

  @override
  String toString() {
    final info = diskon == null ? 'tanpa diskon' : 'diskon ${diskon!.toStringAsFixed(0)}%';
    return '$nama | Rp ${harga.toStringAsFixed(0)} ($info) -> Rp ${hargaAkhir.toStringAsFixed(0)}';
  }
}

void main() {
  final daftar = [
    Produk(nama: 'Buku Tulis', harga: 10000),
    Produk(nama: 'Pensil', harga: 5000, diskon: 10),
    Produk(nama: 'Tas Ransel', harga: 250000, diskon: 20),
  ];

  daftar.forEach(print);
}