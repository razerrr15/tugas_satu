class Mobil {
  String merek;
  String model;
  int tahun;

  Mobil(this.merek, this.model, this.tahun);

  void tampilkanInfo() {
    print('Mobil: $merek $model ($tahun)');
  }

  void nyalakanMesin() {
    print('Mesin mobil $merek dinyalakan...');
  }
}

class Honda extends Mobil {
  String tipe;

  Honda(String model, int tahun, this.tipe) : super('Honda', model, tahun);

  @override
  void tampilkanInfo() {
    print('Honda $model ($tahun) - Tipe: $tipe');
  }

  void fiturKhusus() {
    print('Fitur khusus Honda $tipe: Eco Mode dan i-VTEC Engine');
  }
}

void main() {
  Honda hondaCivic = Honda('Civic', 2023, 'Sedan');
  hondaCivic.tampilkanInfo();
  hondaCivic.nyalakanMesin();
  hondaCivic.fiturKhusus();
}
