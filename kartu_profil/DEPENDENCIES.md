# Dokumentasi Dependency Project

**Nama:** Dharma Putra
**NIM:** 20246312108
**Program Studi:** Teknik Komputer
**Project:** kartu_profil (Flutter)

## Tabel Dependency

### dependencies (ikut ke aplikasi rilis)

| Package | Versi (pubspec) | Terpasang (lock) | Alasan pemakaian | Alternatif yang dipertimbangkan |
|---|---|---|---|---|
| flutter (sdk) | sdk: flutter | sdk | Framework utama untuk membangun UI | Tidak ada, ini fondasi project |
| cupertino_icons | ^2.0.0 | 2.0.0 | Ikon bergaya iOS, bawaan template project | Material Icons (`Icons.*`), sudah tersedia tanpa package tambahan |
| google_fonts | ^9.0.0 | 9.0.0 | Memakai font Poppins, Orbitron, dan Playfair Display pada kartu identitas digital tanpa mengunduh file font manual | Font lokal lewat bagian `fonts:` di pubspec (bisa offline, tetapi file `.ttf` harus disimpan manual) |
| intl | ^0.20.3 | 0.20.3 | Memformat tanggal ke bahasa Indonesia | Pemformatan manual dengan `DateTime` dan daftar nama bulan (lebih panjang dan rawan salah) |

### dev_dependencies (hanya untuk pengembangan)

| Package | Versi (pubspec) | Terpasang (lock) | Alasan pemakaian | Alternatif yang dipertimbangkan |
|---|---|---|---|---|
| flutter_test (sdk) | sdk: flutter | sdk | Menjalankan widget test (`flutter test`) | Package `test` (tanpa dukungan widget) |
| flutter_lints | ^6.0.0 | 6.0.0 | Aturan analisis kode agar gaya penulisan konsisten | Aturan lint kustom di `analysis_options.yaml` |

### Dependency transitif (otomatis, tidak dipasang langsung)

| Package | Versi | Ditarik oleh |
|---|---|---|
| http | 1.6.0 | google_fonts (mengunduh font) |
| path_provider | 2.1.6 | google_fonts (menyimpan font di cache) |
| crypto | 3.0.7 | google_fonts |
| leak_tracker | 11.0.2 | flutter_test |
| lints | 6.1.0 | flutter_lints |

## Catatan Pemilihan

- **google_fonts**: dipilih karena paling cepat dipasang. Kekurangannya butuh internet saat font pertama kali dipakai. Untuk aplikasi yang harus berjalan offline, font lokal lebih aman.
- **intl**: paket resmi tim Dart dan mendukung banyak bahasa.
- Saat memakai `GoogleFonts.poppinsTextTheme()` sebagai `textTheme` global terjadi galat tipe `TextTheme`. Solusinya memanggil `GoogleFonts.poppins(...)` langsung pada masing-masing `Text`.
- Versi `google_fonts` semula `any`, lalu diubah menjadi `^9.0.0` karena `any` tidak dianjurkan (versi bisa berubah tanpa disadari).

## Salinan pubspec.yaml

```yaml
name: kartu_profil
description: "A new Flutter project."
publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: ^3.13.4

dependencies:
  flutter:
    sdk: flutter

  cupertino_icons: ^2.0.0
  google_fonts: ^9.0.0
  intl: ^0.20.3

dev_dependencies:
  flutter_test:
    sdk: flutter

  flutter_lints: ^6.0.0

flutter:
  uses-material-design: true

  assets:
    - assets/foto.jpg
```

## Tangkapan Layar

![Aplikasi berjalan](screenshot_kartu.png)