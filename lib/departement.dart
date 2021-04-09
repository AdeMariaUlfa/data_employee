class Departement {
  int _depid;
  String _depname;

  int get nip => this._depid;

  String get depname => this._depname;
  set depname(String value) => this._depname = value;

  //konstrultor versi1
  Departement(this._depname);

  //konstruktor versi2
  Departement.fromMapDep(Map<String, dynamic> map) {
    this._depid = map['depid'];
    this._depname = map['depname'];
  }

  //konversi pegawai ke map
  Map<String, dynamic> toMapDep() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['depid'] = this._depid;
    map['depname'] = this._depname;
  }
}
