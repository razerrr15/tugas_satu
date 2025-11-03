abstract class Transportasi {
  final String id, nama;
  final int kapasitas;
  final double _tarifDasar;

  Transportasi(this.id, this.nama, this.kapasitas, double tarif) : _tarifDasar = tarif;

  double get tarifDasar => _tarifDasar;
  double hitungTarif(int penumpang);
  void info() => print('[$id] $nama | Kapasitas: $kapasitas | Tarif: $_tarifDasar');
}

class Taksi extends Transportasi {
  double jarak;
  Taksi(super.id, super.nama, super.kapasitas, super.tarifDasar, this.jarak);

  @override
  double hitungTarif(int p) => (p > kapasitas) ? throw Exception('Kelebihan penumpang') : tarifDasar * jarak;

  @override
  void info() {
    super.info();
    print('Taksi (Grab) - Jarak: ${jarak}km');
  }
}

class Bus extends Transportasi {
  bool wifi;
  Bus(super.id, super.nama, super.kapasitas, super.tarifDasar, this.wifi);

  @override
  double hitungTarif(int p) =>
      (p > kapasitas) ? throw Exception('Kelebihan penumpang') : (tarifDasar * p) + (wifi ? 5000 : 0);

  @override
  void info() {
    super.info();
    print('Bus Pariwisata | WiFi: ${wifi ? "Ya" : "Tidak"}');
  }
}

class Pesawat extends Transportasi {
  String kelas;
  Pesawat(super.id, super.nama, super.kapasitas, super.tarifDasar, this.kelas);

  @override
  double hitungTarif(int p) {
    if (p > kapasitas) throw Exception('Kelebihan penumpang');
    double faktor = (kelas.toLowerCase() == 'bisnis') ? 1.5 : 1.0;
    return tarifDasar * p * faktor;
  }

  @override
  void info() {
    super.info();
    print('Pesawat Garuda | Kelas: $kelas');
  }
}

class Pemesanan {
  final String id, nama;
  final Transportasi t;
  final int penumpang;
  Pemesanan(this.id, this.nama, this.t, this.penumpang);

  void struk() => print('''
--------------------------------
Pemesanan: $id
Nama: $nama
${t.nama} (${t.runtimeType})
Penumpang: $penumpang
Total: Rp ${t.hitungTarif(penumpang).toStringAsFixed(2)}
--------------------------------''');
}

void main() {
  var grab = Taksi('TX-001', 'Grab', 4, 3500, 12);
  var bus = Bus('BS-001', 'Bus Pariwisata', 40, 8000, true);
  var garuda = Pesawat('PS-001', 'Garuda', 180, 500000, 'Bisnis');

  grab.info();
  print('---');
  bus.info();
  print('---');
  garuda.info();

  var daftar = [
    Pemesanan('PM-001', 'Eza', grab, 2),
    Pemesanan('PM-002', 'Zixi', bus, 3),
    Pemesanan('PM-003', 'Bryan', garuda, 2)
  ];

  print('\n=== DAFTAR PEMESANAN ===');
  for (var p in daftar) p.struk();
}
