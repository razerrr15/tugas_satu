import 'dart:io';

void main() {
  stdout.write('Masukkan panjang: ');
  double panjang = double.parse(stdin.readLineSync()!);
  stdout.write('Masukkan lebar: ');
  double lebar = double.parse(stdin.readLineSync()!);
  print('Luas persegi panjang = ${panjang * lebar}');
  print('Keliling persegi panjang = ${2 * (panjang + lebar)}');
}
