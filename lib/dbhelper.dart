import 'package:praktikum/departement.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'item.dart';
import 'departement.dart';

class DbHelper {
  static DbHelper _dbHelper;
  static Database _database;
  DbHelper._createObject();
  Future<Database> initDb() async {
//untuk menentukan nama database dan lokasi yg dibuat
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'item.db';
//create, read databases
    var itemDatabase = openDatabase(path,
        version: 7, onCreate: _createDb, onUpgrade: _upgradeDb);
//mengembalikan nilai object sebagai hasil dari fungsinya
    return itemDatabase;
  }

  Future<FutureOr<void>> _upgradeDb(
      Database db, int oldVersion, int newVersion) async {
    // if (oldVersion < 5) {
    //   await db.execute('''ALTER TABLE item ADD COLUMN stock INTEGER;''');
    // }
    // if (oldVersion < 6) {
    //   await db.execute('''ALTER TABLE item ADD COLUMN kodebrg INTEGER;''');
    // }
    _createDb(db, newVersion);
  }

//buat tabel baru dengan nama item
  void _createDb(Database db, int version) async {
    var batch = db.batch();
    batch.execute('DROP TABLE IF EXISTS item');
    batch.execute('DROP TABLE IF EXISTS departement');
    batch.execute('''
CREATE TABLE item (
nip INTEGER PRIMARY KEY AUTOINCREMENT,
name TEXT,
phone TEXT,
address TEXT
)
''');
    batch.execute('''
CREATE TABLE departement (
depid INTEGER PRIMARY KEY AUTOINCREMENT,
depname TEXT
)
''');

    batch.insert('departement', {'depname': 'sales'});
    batch.insert('departement', {'depname': 'admin'});
    batch.insert('departement', {'depname': 'hrd'});
    await batch.commit();
  }

//select databases
  Future<List<Map<String, dynamic>>> select() async {
    Database db = await this.initDb();
    var mapList = await db.query('item', orderBy: 'name');
    return mapList;
  }

  //select dep
  Future<List<String>> selectDepartement() async {
    Database db = await this.initDb();
    var mapList = await db.rawQuery('SELECT depname from departement');
    return mapList.map((Map<String, dynamic> row) {
      return row["depname"] as String;
    }).toList();
  }

//create databases
  Future<int> insert(Item object) async {
    Database db = await this.initDb();
    int count = await db.insert('item', object.toMap());
    return count;
  }

//update databases
  Future<int> update(Item object) async {
    Database db = await this.initDb();
    int count = await db
        .update('item', object.toMap(), where: 'id=?', whereArgs: [object.nip]);
    return count;
  }

//delete databases
  Future<int> delete(int id) async {
    Database db = await this.initDb();
    int count = await db.delete('item', where: 'id=?', whereArgs: [id]);
    return count;
  }

  Future<List<Item>> getItemList() async {
    var itemMapList = await select();
    int count = itemMapList.length;
    // ignore: deprecated_member_use
    List<Item> itemList = List<Item>();
    for (int i = 0; i < count; i++) {
      itemList.add(Item.fromMap(itemMapList[i]));
    }
    return itemList;
  }

  Future<List<Departement>> getDepartementList() async {
    var depMapList = await select();
    int count = depMapList.length;
    List<Departement> kategoriList = List<Departement>();
    for (int i = 0; i < count; i++) {
      kategoriList.add(Departement.fromMapDep(depMapList[i]));
    }
    return kategoriList;
  }

  factory DbHelper() {
    if (_dbHelper == null) {
      _dbHelper = DbHelper._createObject();
    }
    return _dbHelper;
  }
  Future<Database> get database async {
    if (_database == null) {
      _database = await initDb();
    }
    return _database;
  }
}
