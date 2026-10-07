// Tugas Minggu 02 - Poin 1: Konversi suhu
// Nama : Dharma Putra
// NIM  : 20246312108

// Function terpisah untuk tiap konversi
double celsiusKeFahrenheit(double c) => (c * 9 / 5) + 32;

double celsiusKeKelvin(double c) => c + 273.15;

void main() {
  final suhu = [0.0, 25.0, 36.5, 100.0, -40.0];

  for (final c in suhu) {
    final f = celsiusKeFahrenheit(c);
    final k = celsiusKeKelvin(c);
    print('${c.toStringAsFixed(1)} C = ${f.toStringAsFixed(1)} F = ${k.toStringAsFixed(2)} K');
  }
}