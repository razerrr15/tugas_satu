// tongit_praktikum.dart
import 'dart:math';

enum KategoriProduk { DataManagement, NetworkAutomation }
enum Role { Developer, NetworkEngineer, Manager }
enum FaseProyek { Perencanaan, Pengembangan, Evaluasi }

class ProdukDigital {
  final String namaProduk;
  double _harga;
  final KategoriProduk kategori;
  int terjual;

  ProdukDigital({
    required this.namaProduk,
    required double harga,
    required this.kategori,
    this.terjual = 0,
  }) : _harga = harga {
    if (kategori == KategoriProduk.NetworkAutomation && harga < 200000) {
      throw ArgumentError(
          'NetworkAutomation harus memiliki harga minimal 200000.');
    }
    if (kategori == KategoriProduk.DataManagement && harga >= 200000) {
      throw ArgumentError('DataManagement harus memiliki harga < 200000.');
    }
  }

  double get harga => _harga;

  void terapkanDiskonJikaBerhak() {
    if (kategori == KategoriProduk.NetworkAutomation && terjual > 50) {
      final diskon = 0.15;
      final hargaDiskon = _harga * (1 - diskon);
      _harga = max(hargaDiskon, 200000);
    }
  }

  @override
  String toString() =>
      '$namaProduk (${kategori.name}) - Rp ${_harga.toStringAsFixed(0)} - Terjual: $terjual';
}

mixin Kinerja {
  int _produktifitas = 0;
  DateTime? _terakhirUpdateProduktivitas;
  String get roleName;

  int get produktifitas => _produktifitas;

  bool updateProduktivitas(int nilaiBaru) {
    final now = DateTime.now();
    if (nilaiBaru < 0 || nilaiBaru > 100) {
      throw ArgumentError('Produktivitas harus antara 0 dan 100.');
    }
    if (_terakhirUpdateProduktivitas != null) {
      final diff = now.difference(_terakhirUpdateProduktivitas!);
      if (diff.inDays < 30) {
        return false;
      }
    }
    if (roleName == 'Manager' && nilaiBaru < 85) {
      throw StateError('Manager harus memiliki produktivitas minimal 85.');
    }
    _produktifitas = nilaiBaru;
    _terakhirUpdateProduktivitas = now;
    return true;
  }

  DateTime? get terakhirUpdateProduktivitas => _terakhirUpdateProduktivitas;
}

abstract class Karyawan with Kinerja {
  final String nama;
  final int umur;
  final Role role;
  final int pengalamanTahun;
  bool aktif;

  Karyawan(this.nama,
      {required this.umur,
      required this.role,
      required this.pengalamanTahun,
      this.aktif = true});

  String get roleName => role.name;
  void bekerja();
}

class KaryawanTetap extends Karyawan {
  KaryawanTetap(String nama,
      {required int umur, required Role role, required int pengalamanTahun})
      : super(nama, umur: umur, role: role, pengalamanTahun: pengalamanTahun);

  @override
  void bekerja() {
    print('$nama (Tetap, ${role.name}) bekerja sesuai jam kerja reguler.');
  }
}

class KaryawanKontrak extends Karyawan {
  DateTime mulaiKontrak;
  DateTime selesaiKontrak;

  KaryawanKontrak(
    String nama, {
    required int umur,
    required Role role,
    required int pengalamanTahun,
    required this.mulaiKontrak,
    required this.selesaiKontrak,
  }) : super(nama,
            umur: umur, role: role, pengalamanTahun: pengalamanTahun);

  @override
  void bekerja() {
    final now = DateTime.now();
    final aktifSekarang = now.isAfter(mulaiKontrak) && now.isBefore(selesaiKontrak);
    print(
        '$nama (Kontrak, ${role.name}) ${aktifSekarang ? "aktif" : "tidak aktif"} pada periode kontrak.');
  }
}

class Proyek {
  final String nama;
  FaseProyek fase;
  final List<Karyawan> tim = [];
  final DateTime mulai;

  Proyek({required this.nama, required this.fase, required this.mulai});

  void tambahAnggota(Karyawan k) {
    if (!tim.contains(k)) tim.add(k);
  }

  void hapusAnggota(Karyawan k) {
    tim.remove(k);
  }

  bool lanjutKeFaseBerikutnya() {
    if (fase == FaseProyek.Perencanaan) {
      final aktifCount = tim.where((k) => k.aktif).length;
      if (aktifCount >= 5) {
        fase = FaseProyek.Pengembangan;
        return true;
      }
      return false;
    } else if (fase == FaseProyek.Pengembangan) {
      final now = DateTime.now();
      final runningDays = now.difference(mulai).inDays;
      if (runningDays > 45) {
        fase = FaseProyek.Evaluasi;
        return true;
      }
      return false;
    } else {
      return false;
    }
  }

  @override
  String toString() =>
      'Proyek: $nama - Fase: ${fase.name} - Tim aktif: ${tim.where((k) => k.aktif).length}';
}

class Perusahaan {
  final String nama;
  final List<Karyawan> _aktif = [];
  final List<Karyawan> _nonAktif = [];
  final int maxAktif;

  Perusahaan({required this.nama, this.maxAktif = 20});

  List<Karyawan> get aktif => List.unmodifiable(_aktif);
  List<Karyawan> get nonAktif => List.unmodifiable(_nonAktif);

  bool _cekKriteria(Role role, int umur, int pengalaman) {
    switch (role) {
      case Role.Developer:
        return umur >= 20 && pengalaman >= 1;
      case Role.NetworkEngineer:
        return umur >= 22 && pengalaman >= 2;
      case Role.Manager:
        return umur >= 30 && pengalaman >= 5;
    }
  }

  bool tambahKaryawan(Karyawan k) {
    if (!_cekKriteria(k.role, k.umur, k.pengalamanTahun)) {
      return false;
    }
    if (_aktif.length >= maxAktif) return false;
    _aktif.add(k);
    return true;
  }

  bool resignKaryawan(Karyawan k) {
    if (_aktif.remove(k)) {
      k.aktif = false;
      _nonAktif.add(k);
      return true;
    }
    return false;
  }

  bool reaktifkanKaryawan(Karyawan k) {
    if (!_nonAktif.contains(k)) return false;
    if (_aktif.length >= maxAktif) return false;
    _nonAktif.remove(k);
    k.aktif = true;
    _aktif.add(k);
    return true;
  }
}

void main() {
  final p1 = ProdukDigital(
      namaProduk: 'SistemMan Data Basic',
      harga: 150000,
      kategori: KategoriProduk.DataManagement,
      terjual: 40);
  final p2 = ProdukDigital(
      namaProduk: 'AutoNet Pro',
      harga: 250000,
      kategori: KategoriProduk.NetworkAutomation,
      terjual: 60);

  print('=== PRODUK SEBELUM DISKON ===');
  print(p1);
  print(p2);
  p2.terapkanDiskonJikaBerhak();
  print('\n=== PRODUK SETELAH CEK DISKON ===');
  print(p1);
  print(p2);

  final perusahaan = Perusahaan(nama: 'TongIT', maxAktif: 20);

  final k1 = KaryawanTetap('Asep', umur: 28, role: Role.Developer, pengalamanTahun: 2);
  final k2 = KaryawanTetap('Budi', umur: 32, role: Role.NetworkEngineer, pengalamanTahun: 3);
  final k3 = KaryawanTetap('Cici', umur: 40, role: Role.Manager, pengalamanTahun: 6);
  final k4 = KaryawanKontrak('Dedi',
      umur: 27,
      role: Role.Developer,
      pengalamanTahun: 1,
      mulaiKontrak: DateTime.now().subtract(Duration(days: 10)),
      selesaiKontrak: DateTime.now().add(Duration(days: 20)));
  final k5 = KaryawanTetap('Eka', umur: 30, role: Role.Developer, pengalamanTahun: 4);

  print('\nMenambah karyawan ke perusahaan:');
  print('Tambah Asep: ${perusahaan.tambahKaryawan(k1)}');
  print('Tambah Budi: ${perusahaan.tambahKaryawan(k2)}');
  print('Tambah Cici: ${perusahaan.tambahKaryawan(k3)}');
  print('Tambah Dedi: ${perusahaan.tambahKaryawan(k4)}');
  print('Tambah Eka : ${perusahaan.tambahKaryawan(k5)}');

  print('\nJumlah karyawan aktif: ${perusahaan.aktif.length}');

  try {
    final berhasil = k3.updateProduktivitas(90);
    print('\nUpdate produktivitas Manager Cici berhasil: $berhasil (nilai: ${k3.produktifitas})');
  } catch (e) {
    print('Error update produktivitas: $e');
  }

  final proyek = Proyek(
      nama: 'Sistem Otomasi Jaringan vNext',
      fase: FaseProyek.Perencanaan,
      mulai: DateTime.now().subtract(Duration(days: 60)));

  proyek.tambahAnggota(k1);
  proyek.tambahAnggota(k2);
  proyek.tambahAnggota(k3);
  proyek.tambahAnggota(k4);
  proyek.tambahAnggota(k5);

  print('\nProyek sebelum transisi: $proyek');
  final t1 = proyek.lanjutKeFaseBerikutnya();
  print('Transisi Perencanaan->Pengembangan: $t1, fase sekarang: ${proyek.fase.name}');
  final t2 = proyek.lanjutKeFaseBerikutnya();
  print('Transisi Pengembangan->Evaluasi: $t2, fase sekarang: ${proyek.fase.name}');

  print('\nDemonstrasi pembatasan karyawan aktif:');
  for (int i = 0; i < 18; i++) {
    final temp = KaryawanTetap('Karyawan$i', umur: 25, role: Role.Developer, pengalamanTahun: 1);
    final added = perusahaan.tambahKaryawan(temp);
    if (!added) {
      print('Gagal tambah Karyawan$i pada indeks $i (batas mungkin tercapai atau kriteria tidak terpenuhi).');
      break;
    }
  }
  print('Jumlah karyawan aktif setelah bulk add: ${perusahaan.aktif.length}');

  final resignOk = perusahaan.resignKaryawan(k2);
  print('\nBudi resign: $resignOk');
  print('Aktif: ${perusahaan.aktif.length}, Non-aktif: ${perusahaan.nonAktif.length}');

  print('\nContoh: coba update produktivitas sebelum 30 hari lagi (harus gagal jika dilakukan sekarang):');
  final updateSoon = k1.updateProduktivitas(80);
  print('Update produktivitas Asep sebelum 30 hari: $updateSoon (nilai sekarang: ${k1.produktifitas})');

  print('\nSelesai demo.');
}
