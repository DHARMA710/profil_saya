// Tugas Minggu 02 - Poin 3: var, final, const, late
// Nama : Dharma Putra
// NIM  : 20246312108

// const: nilainya sudah pasti saat kompilasi dan tidak pernah berubah,
// cocok untuk konstanta seperti nilai pi atau batas lulus.
const double batasLulus = 65;

// late: nilai baru diisi setelah deklarasi (ditunda). Cocok bila nilainya
// baru tersedia belakangan, misalnya setelah proses di dalam main().
late String kodeMataKuliah;

void main() {
  // var: tipe disimpulkan compiler (String) dan nilainya boleh diubah.
  // Dipakai untuk data yang berubah selama program berjalan.
  var kota = 'Denpasar';
  kota = 'Badung';

  // final: nilai ditentukan saat runtime lalu tidak bisa diganti.
  // Dipakai untuk hasil perhitungan yang tidak berubah, misalnya waktu sekarang.
  final waktuMulai = DateTime.now();

  // late: diisi di sini, baru boleh dibaca setelah terisi.
  kodeMataKuliah = 'TKO-4021';

  // Contoh pemakaian ke-4 jenis variabel
  var nilai = 78;
  nilai += 10; // var boleh berubah
  final status = nilai >= batasLulus ? 'Lulus' : 'Belum lulus';

  print('Kota           : $kota');
  print('Waktu mulai    : $waktuMulai');
  print('Kode matkul    : $kodeMataKuliah');
  print('Nilai          : $nilai ($status)');
  print('Batas lulus    : $batasLulus');

  // kota = 5;            // error: tipe String tidak bisa diisi int
  // waktuMulai = DateTime.now(); // error: final tidak bisa diubah lagi
  // batasLulus = 70;     // error: const tidak bisa diubah
}