// Tugas Minggu 03: Aplikasi Konsol Menu Kantin
// Nama : Dharma Putra
// NIM  : 20246312108

import 'dart:io';

// Mengubah masukan menjadi angka. Melempar FormatException bila bukan angka.
int bacaAngka(String? teks) {
  if (teks == null || teks.trim().isEmpty) {
    throw const FormatException('Masukan tidak boleh kosong');
  }
  return int.parse(teks.trim()); // FormatException bila bukan angka
}

void tampilkanMenu() {
  print('\n=========== MENU KANTIN ===========');
  print('1. Nasi Goreng      Rp 15.000');
  print('2. Mie Ayam         Rp 12.000');
  print('3. Soto Ayam        Rp 13.000');
  print('4. Es Teh           Rp  4.000');
  print('5. Jus Jeruk        Rp  8.000');
  print('0. Selesai dan bayar');
  print('===================================');
}

void main() {
  int total = 0;
  int jumlahPesanan = 0;

  print('SELAMAT DATANG DI KANTIN KAMPUS');
  print('Dharma Putra - 20246312108 - Teknik Komputer');

  // Perulangan: terus menerima pesanan sampai pengguna memilih 0
  while (true) {
    tampilkanMenu();
    stdout.write('Pilih menu (0-5): ');

    try {
      final pilihan = bacaAngka(stdin.readLineSync());

      if (pilihan == 0) {
        break; // keluar dari perulangan
      }

      // switch: memproses pilihan menu
      String nama;
      int harga;
      switch (pilihan) {
        case 1:
          nama = 'Nasi Goreng';
          harga = 15000;
          break;
        case 2:
          nama = 'Mie Ayam';
          harga = 12000;
          break;
        case 3:
          nama = 'Soto Ayam';
          harga = 13000;
          break;
        case 4:
          nama = 'Es Teh';
          harga = 4000;
          break;
        case 5:
          nama = 'Jus Jeruk';
          harga = 8000;
          break;
        default:
          throw RangeError('Pilihan $pilihan tidak ada di menu');
      }

      stdout.write('Jumlah $nama: ');
      final jumlah = bacaAngka(stdin.readLineSync());

      if (jumlah <= 0) {
        throw ArgumentError('Jumlah harus lebih dari 0');
      }

      final subtotal = harga * jumlah;
      total += subtotal;
      jumlahPesanan++;
      print('Ditambahkan: $jumlah x $nama = Rp $subtotal');
      print('Total sementara: Rp $total');
    } on FormatException catch (e) {
      print('[Input salah] Masukkan angka yang valid. (${e.message})');
    } on RangeError catch (e) {
      print('[Menu tidak ada] ${e.message}');
    } on ArgumentError catch (e) {
      print('[Jumlah salah] ${e.message}');
    } catch (e) {
      print('[Error tak terduga] $e');
    } finally {
      // Blok ini selalu dijalankan setiap putaran
    }
  }

  // Struk akhir
  print('\n=========== STRUK ===========');
  print('Jumlah pesanan : $jumlahPesanan');
  print('Total belanja  : Rp $total');

  // Ekspresi kondisional / percabangan: diskon bila belanja besar
  if (total >= 50000) {
    final diskon = total ~/ 10;
    print('Diskon 10%     : Rp $diskon');
    print('Total bayar    : Rp ${total - diskon}');
  } else if (total > 0) {
    print('Total bayar    : Rp $total');
  } else {
    print('Anda belum memesan apa pun.');
  }
  print('Terima kasih!');
}