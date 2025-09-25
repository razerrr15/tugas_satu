import 'dart:io';
import 'package:math_expressions/math_expressions.dart';

void main() {
  final parser = Parser();
  final cm = ContextModel();

  print("=== Kalkulator Sederhana (Dart) ===");
  print("Ketik 'exit' untuk keluar.\n");

  while (true) {
    stdout.write("Masukkan ekspresi: ");
    String? input = stdin.readLineSync();

    if (input == null || input.toLowerCase() == 'exit') break;

    try {
      Expression exp = parser.parse(input);
      double hasil = exp.evaluate(EvaluationType.REAL, cm);
      print("Hasil: ${hasil.toStringAsFixed(0)}");
    } catch (e) {
      print("Error: Ekspresi tidak valid");
    }
  }
}
