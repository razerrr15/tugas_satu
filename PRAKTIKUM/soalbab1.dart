void main() {
  print('=== Contoh Program Try-Catch-Finally ===\n');

  try {
    int a = 10;
    int b = 1;

    int hasil = a ~/ b;

    print('Hasil pembagian: $hasil');
  } catch (e) {
    print('Terjadi kesalahan: $e');
  } finally {
    print('\nProgram selesai dijalankan.');
  }
}
