class Item {
  int _nip;
  String _name;
  String _phone;
  String _address;

  int get nip => this._nip;

  String get name => this._name;
  set name(String value) => this._name = value;

  String get phone => this._phone;
  set phone(String value) => this._phone = value;

  String get address => this._address;
  set address(String value) => this._address = value;

  //konstrultor versi1
  Item(this._name, this._phone, this._address, String text);

  //konstruktor versi2
  Item.fromMap(Map<String, dynamic> map) {
    this._nip = map['nip'];
    this._name = map['name'];
    this._phone = map['phone'];
    this._address = map['address'];
  }

  //konversi item ke map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['nip'] = this._nip;
    map['name'] = this._name;
    map['phone'] = this._phone;
    map['address'] = this._address;
  }
}
