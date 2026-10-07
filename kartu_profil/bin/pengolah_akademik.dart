// Tugas Minggu 04: Pengolah Data Akademik
// Nama : Dharma Putra
// NIM  : 20246312108

// Data mata kuliah disimpan dalam List<Map>
final List<Map<String, dynamic>> mataKuliah = [
  {'kode': 'TK101', 'nama': 'Pemrograman Mobile', 'sks': 3},
  {'kode': 'TK102', 'nama': 'Jaringan Komputer', 'sks': 3},
  {'kode': 'TK103', 'nama': 'Basis Data', 'sks': 4},
  {'kode': 'TK104', 'nama': 'Kecerdasan Buatan', 'sks': 2},
  {'kode': 'TK105', 'nama': 'Algoritma dan Struktur Data', 'sks': 4},
  {'kode': 'TK106', 'nama': 'Sistem Operasi', 'sks': 3},
  {'kode': 'TK107', 'nama': 'Etika Profesi', 'sks': 2},
];

// 1. Pencarian berdasarkan kata kunci (nama atau kode, tidak peduli besar kecil huruf)
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

// 2. Penyaringan berdasarkan SKS (parameter bernama: minimal dan maksimal opsional)
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

// 3. Pengurutan berdasarkan nama (salinan, data asli tidak berubah)
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

// Menampilkan hasil dengan method iterable (map + forEach)
void tampilkan(String judul, List<Map<String, dynamic>> data) {
  print('\n=== $judul ===');
  if (data.isEmpty) {
    print('(tidak ada data)');
    return;
  }
  data
      .map((mk) => '${mk['kode']} | ${mk['nama']} (${mk['sks']} SKS)')
      .forEach(print);
}

void main() {
  print('PENGOLAH DATA AKADEMIK');
  print('Dharma Putra - 20246312108 - Teknik Komputer');

  tampilkan('Semua mata kuliah', mataKuliah);

  // Pencarian
  tampilkan('Cari "data"', cari(mataKuliah, 'data'));
  tampilkan('Cari "komputer"', cari(mataKuliah, 'komputer'));
  tampilkan('Cari "xyz" (tidak ada)', cari(mataKuliah, 'xyz'));

  // Penyaringan SKS
  tampilkan('SKS minimal 3', saringSks(mataKuliah, minSks: 3));
  tampilkan('SKS tepat 2', saringSks(mataKuliah, minSks: 2, maxSks: 2));
  tampilkan('SKS 3 sampai 4', saringSks(mataKuliah, minSks: 3, maxSks: 4));

  // Pengurutan
  tampilkan('Urut nama A-Z', urutkanNama(mataKuliah));
  tampilkan('Urut nama Z-A', urutkanNama(mataKuliah, naik: false));

  // Ringkasan memakai reduce, map, dan any/every
  final totalSks = mataKuliah.map((mk) => mk['sks'] as int).reduce((a, b) => a + b);
  final adaEmpatSks = mataKuliah.any((mk) => mk['sks'] == 4);
  final semuaMinDua = mataKuliah.every((mk) => (mk['sks'] as int) >= 2);

  print('\n=== Ringkasan ===');
  print('Jumlah mata kuliah : ${mataKuliah.length}');
  print('Total SKS          : $totalSks');
  print('Ada yang 4 SKS?    : $adaEmpatSks');
  print('Semua minimal 2?   : $semuaMinDua');
}