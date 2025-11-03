// ===============================
// TONGIT - SISTEM MANAJEMEN PERUSAHAAN
// Bab 2: Implementasi Konsep OOP Lengkap
// ===============================

enum KategoriProduk { DataManagement, NetworkAutomation }
enum Role { Developer, NetworkEngineer, Manager }
enum FaseProyek { Perencanaan, Pengembangan, Evaluasi }

// ======================================================
// 1. KELAS UTAMA DAN SUBKELAS
// ======================================================

class ProdukDigital {
  String namaProduk;
  double harga;
  KategoriProduk kategori;
  int terjual;

  ProdukDigital(this.namaProduk, this.harga, this.kategori, {this.terjual = 0});

  void terapkanDiskon() {
    if (kategori == KategoriProduk.NetworkAutomation && terjual > 50) {
      double diskon = harga * 0.15;
      double hargaAkhir = harga - diskon;
      if (hargaAkhir < 200000) {
        hargaAkhir = 200000;
      }
      harga = hargaAkhir;
    }
  }

  void tampilProduk() {
    print(
        'Produk: $namaProduk | Kategori: ${kategori.name} | Harga: Rp$harga | Terjual: $terjual');
  }
}

// ======================================================
// 2. POSITONAL DAN NAMED ARGUMENTS
// ======================================================

abstract class Karyawan {
  String nama; // positional argument
  int umur; // named argument
  Role peran; // named argument

  Karyawan(this.nama, {required this.umur, required this.peran});

  void bekerja();
}

// ======================================================
// 3. MIXIN KINERJA UNTUK PRODUKTIVITAS
// ======================================================

mixin Kinerja {
  int produktivitas = 0;
  DateTime? terakhirUpdate;

  bool updateProduktivitas(int nilaiBaru, Role peran) {
    DateTime sekarang = DateTime.now();

    if (terakhirUpdate != null &&
        sekarang.difference(terakhirUpdate!).inDays < 30) {
      print('❌ Produktivitas hanya bisa diperbarui setiap 30 hari sekali.');
      return false;
    }

    if (nilaiBaru < 0 || nilaiBaru > 100) {
      print('❌ Nilai produktivitas harus 0 - 100.');
      return false;
    }

    if (peran == Role.Manager && nilaiBaru < 85) {
      print('⚠️ Manager harus memiliki produktivitas minimal 85.');
      return false;
    }

    produktivitas = nilaiBaru;
    terakhirUpdate = sekarang;
    print('✅ Produktivitas diperbarui ke $produktifitas');
    return true;
  }

  int get produktifitas => produktivitas;
}

// ======================================================
// 4. SUBCLASS KARYAWAN
// ======================================================

class KaryawanTetap extends Karyawan with Kinerja {
  int tahunPengalaman;

  KaryawanTetap(String nama,
      {required int umur,
      required Role peran,
      required this.tahunPengalaman})
      : super(nama, umur: umur, peran: peran);

  @override
  void bekerja() {
    print(
        '$nama (Karyawan Tetap - ${peran.name}) bekerja setiap hari kerja reguler.');
  }
}

class KaryawanKontrak extends Karyawan with Kinerja {
  DateTime mulaiKontrak;
  DateTime selesaiKontrak;

  KaryawanKontrak(String nama,
      {required int umur,
      required Role peran,
      required this.mulaiKontrak,
      required this.selesaiKontrak})
      : super(nama, umur: umur, peran: peran);

  @override
  void bekerja() {
    print('$nama (Karyawan Kontrak - ${peran.name}) sedang menjalankan proyek.');
  }
}

// ======================================================
// 5. ENUM FASE PROYEK
// ======================================================

class Proyek {
  String namaProyek;
  FaseProyek fase;
  List<Karyawan> tim;
  DateTime tanggalMulai;

  Proyek(
      {required this.namaProyek,
      required this.fase,
      required this.tanggalMulai,
      required this.tim});

  void lanjutFase() {
    if (fase == FaseProyek.Perencanaan && tim.length >= 5) {
      fase = FaseProyek.Pengembangan;
      print('✅ Proyek beralih ke fase Pengembangan.');
    } else if (fase == FaseProyek.Pengembangan &&
        DateTime.now().difference(tanggalMulai).inDays > 45) {
      fase = FaseProyek.Evaluasi;
      print('✅ Proyek beralih ke fase Evaluasi.');
    } else {
      print('⚠️ Syarat belum terpenuhi untuk lanjut fase.');
    }
  }

  void tampilFase() {
    print('Proyek: $namaProyek | Fase Sekarang: ${fase.name}');
  }
}

// ======================================================
// 6. PEMBATASAN JUMLAH KARYAWAN AKTIF
// ======================================================

class Perusahaan {
  String namaPerusahaan;
  List<Karyawan> aktif = [];
  List<Karyawan> nonAktif = [];
  int maxKaryawan = 20;

  Perusahaan(this.namaPerusahaan);

  void tambahKaryawan(Karyawan k) {
    if (aktif.length >= maxKaryawan) {
      print('❌ Tidak bisa menambah karyawan lagi (maksimal $maxKaryawan).');
    } else {
      aktif.add(k);
      print('✅ Karyawan ${k.nama} berhasil ditambahkan.');
    }
  }

  void resignKaryawan(Karyawan k) {
    if (aktif.contains(k)) {
      aktif.remove(k);
      nonAktif.add(k);
      print('ℹ️ ${k.nama} telah resign dan menjadi non-aktif.');
    }
  }

  void tampilKaryawan() {
    print(
        'Karyawan Aktif: ${aktif.length} | Non-Aktif: ${nonAktif.length}');
  }
}

// ======================================================
// 7. TUGAS TAMBAHAN: DEMO PROYEK LENGKAP
// ======================================================

void main() {
  print('=== SISTEM MANAJEMEN PERUSAHAAN TONGIT ===\n');

  var produk1 =
      ProdukDigital('DataMaster Pro', 180000, KategoriProduk.DataManagement);
  var produk2 = ProdukDigital(
      'AutoNet Optimizer', 250000, KategoriProduk.NetworkAutomation,
      terjual: 60);

  print('--- PRODUK ---');
  produk1.tampilProduk();
  produk2.terapkanDiskon();
  produk2.tampilProduk();

  print('\n--- KARYAWAN ---');
  var k1 = KaryawanTetap('Alya',
      umur: 28, peran: Role.Developer, tahunPengalaman: 4);
  var k2 = KaryawanTetap('Rizky',
      umur: 35, peran: Role.Manager, tahunPengalaman: 8);
  var k3 = KaryawanKontrak('Dewi',
      umur: 25,
      peran: Role.NetworkEngineer,
      mulaiKontrak: DateTime(2025, 1, 1),
      selesaiKontrak: DateTime(2025, 12, 31));

  var perusahaan = Perusahaan('TongIT');
  perusahaan.tambahKaryawan(k1);
  perusahaan.tambahKaryawan(k2);
  perusahaan.tambahKaryawan(k3);
  perusahaan.tampilKaryawan();

  print('\n--- PRODUKTIVITAS ---');
  k2.updateProduktivitas(90, Role.Manager); // sukses
  k1.updateProduktivitas(70, Role.Developer);

  print('\n--- PROYEK ---');
  var proyek = Proyek(
      namaProyek: 'Jaringan AI Otomatis',
      fase: FaseProyek.Perencanaan,
      tanggalMulai: DateTime(2025, 8, 1),
      tim: [k1, k2, k3, k1, k2]);

  proyek.tampilFase();
  proyek.lanjutFase();
  proyek.tampilFase();

  print('\n--- STATUS PERUSAHAAN ---');
  perusahaan.resignKaryawan(k3);
  perusahaan.tampilKaryawan();
}