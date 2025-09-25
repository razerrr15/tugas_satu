void main() {
  String namaKaryawan = "Rudi Hartono";
  int jamKerjaPerMinggu = 40;
  double upahPerJam = 50000.0;
  bool statusTetap = true; 

  double gajiKotor = jamKerjaPerMinggu * upahPerJam;

  double pajak = statusTetap ? 0.10 * gajiKotor : 0.05 * gajiKotor;

  double gajiBersih = gajiKotor - pajak;

  print("=== Data Gaji Karyawan ===");
  print("Nama Karyawan : $namaKaryawan");
  print("Status        : ${statusTetap ? "Tetap" : "Kontrak"}");
  print("Gaji Kotor    : Rp ${gajiKotor.toStringAsFixed(2)}");
  print("Pajak         : Rp ${pajak.toStringAsFixed(2)}");
  print("Gaji Bersih   : Rp ${gajiBersih.toStringAsFixed(2)}");
}