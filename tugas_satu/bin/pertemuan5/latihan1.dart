class Mobil {
  String merk;
  int tahun;
  String warna;
  int kecepatan;
  int harga;
  int kapasitas;

  Mobil({
    required this.merk,
    required this.tahun,
    required this.warna,
    required this.kecepatan,
    required this.harga,
    required this.kapasitas,
  });

  void info() {
    print("Merk Mobil: $merk");
    print("Tahun: $tahun");
    print("Warna: $warna");
    print("Kecepatan Maksimal: $kecepatan km/h");
    print("Harga: Rp $harga");
    print("Kapasitas Penumpang: $kapasitas orang");
  }
}

void main() {
  Mobil mobil1 = Mobil(
    merk: "Toyota",
    tahun: 2020,
    warna: "Hitam",
    kecepatan: 180,
    harga: 300000000,
    kapasitas: 5,
  );

  mobil1.info();
}
