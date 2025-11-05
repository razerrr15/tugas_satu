import 'dart:io';

class Homestay {
  String nama, alamat;
  double harga;
  List<Kamar> kamarList = [];
  Homestay(this.nama, this.alamat, this.harga);

  void tambahKamar(bool tersedia) => kamarList.add(Kamar(tersedia));
  void info() =>
      print("=== $nama ===\nAlamat: $alamat\nHarga/Malam: Rp$harga\n");
  void daftarKamar() {
    print("=== DAFTAR KAMAR ===");
    for (int i = 0; i < kamarList.length; i++) {
      print("Kamar ${i + 1}: ${kamarList[i].status}");
    }
  }
}

class Kamar {
  bool tersedia;
  Kamar(this.tersedia);
  String get status => tersedia ? "Tersedia" : "Sudah disewa";
  void sewa() => tersedia = false;
}

class Pemesanan {
  Homestay h;
  Kamar k;
  String namaTamu;
  int malam;
  String bank, kartu, pemilik;
  double bayar;
  Pemesanan(this.h, this.k, this.namaTamu, this.malam, this.bank, this.kartu,
      this.pemilik, this.bayar);

  double get tagihan => h.harga * malam;
  void pembayaran() {
    print("\n=== PEMBAYARAN ===");
    print("Bank: $bank | Kartu: $kartu | Pemilik: $pemilik | Bayar: Rp$bayar");
    if (bayar < tagihan) {
      print("❌ Uang tidak cukup");
    } else if (bayar > tagihan)
      print("⚠ Uang lebih, kembalian diproses");
    else
      print("✅ Pembayaran berhasil!");
  }

  void data() {
    print("\n=== DATA PEMESANAN ===");
    print("Homestay: ${h.nama} | Alamat: ${h.alamat}");
    print("Kamar: ${h.kamarList.indexOf(k) + 1} | ${k.status}");
    print("Tamu: $namaTamu | Lama: $malam malam | Total: Rp$tagihan");
    print("✨ Terima kasih telah memesan ✨");
  }
}

void main() {
  var h = Homestay(
      "Razer Homestay", "Jl. Pahlawan Revolusi No.45, Ternate", 130000);
  for (int i = 0; i < 5; i++) {
    h.tambahKamar(i % 2 == 0);
  }

  h.info();
  h.daftarKamar();
  stdout.write("\nPilih kamar: ");
  int pilih = int.parse(stdin.readLineSync()!);
  if (pilih < 1 ||
      pilih > h.kamarList.length ||
      !h.kamarList[pilih - 1].tersedia) {
    print("Kamar tidak valid atau sudah disewa.");
    return;
  }
  var k = h.kamarList[pilih - 1];

  print("\n1.BNI  2.BRI  3.BANK INDONESIA  4.BANK MANDIRI");
  stdout.write("Pilih bank: ");
  String bank = [
    "BNI",
    "BRI",
    "BANK INDONESIA",
    "BANK MANDIRI"
  ][(int.parse(stdin.readLineSync()!) - 1)];

  stdout.write("Nomor kartu: ");
  String kartu = stdin.readLineSync()!;
  stdout.write("Nama pemilik: ");
  String pemilik = stdin.readLineSync()!;
  stdout.write("Nama tamu: ");
  String tamu = stdin.readLineSync()!;
  stdout.write("Lama menginap (malam): ");
  int malam = int.parse(stdin.readLineSync()!);

  double tagihan = h.harga * malam;
  print("\nTotal Tagihan: Rp$tagihan");
  stdout.write("Jumlah bayar: Rp");
  double bayar = double.parse(stdin.readLineSync()!);

  k.sewa();
  var p = Pemesanan(h, k, tamu, malam, bank, kartu, pemilik, bayar);
  p.pembayaran();
  p.data();
}
