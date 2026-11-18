# Aplikasi Daftar Belanja (Minggu 10)

**Nama:** Dharma Putra | **NIM:** 20246312108 | **Prodi:** Teknik Komputer

Aplikasi daftar belanja dengan tiga halaman: Katalog, Keranjang, dan Pengaturan.
Menjalankan: `flutter run -d windows -t lib/belanja_app.dart`

## Penempatan State dan Alasannya

| State | Lokasi | Jenis | Alasan |
|---|---|---|---|
| Isi keranjang (`KeranjangModel`) | Provider, di atas `MaterialApp` | App state | Dibutuhkan lintas halaman: katalog menambah, keranjang menampilkan, badge di AppBar dan halaman pengaturan menghitung jumlah. Bila disimpan di satu widget, data harus diteruskan lebih dari tiga tingkat widget (prop drilling) |
| Tema terang/gelap (`PengaturanModel`) | Provider, di atas `MaterialApp` | App state | Diubah di halaman Pengaturan tetapi harus memengaruhi `MaterialApp`, yaitu seluruh aplikasi |
| Tab aktif (`_tab`) | `setState` di `_HalamanUtamaState` | State lokal | Hanya dipakai `HalamanUtama` untuk memilih halaman. Tidak ada widget lain yang membutuhkannya |
| Kata kunci pencarian (`_kataKunci`) dan `TextEditingController` | `setState` di `_HalamanKatalogState` | State lokal | Hanya relevan untuk kolom pencarian di katalog. Controller dibuat di `initState` dan dilepas di `dispose` |

## Cara Akses Provider

| Cara | Dipakai di | Alasan |
|---|---|---|
| `context.watch` | `build` pada `BadgeKeranjang`, `KartuProduk`, `HalamanKeranjang`, `AplikasiBelanja` | Tampilan harus ikut berubah saat data berubah |
| `context.read` | `onPressed` tombol (tambah, kurang, hapus, bayar, ganti tema) | Hanya memicu aksi, tidak perlu membangun ulang widget |
| `Consumer` | Kartu "Item di keranjang" pada halaman Pengaturan | Membatasi pembangunan ulang hanya pada bagian kecil |

## Lifting State Up
Pada `HalamanKatalog`, state pencarian disimpan di induk (`_HalamanKatalogState`), sedangkan `KartuProduk` hanya menerima data dan memanggil aksi.

## Siklus Hidup
`initState` membuat `TextEditingController` dan listener, `dispose` melepasnya agar tidak terjadi kebocoran memori.