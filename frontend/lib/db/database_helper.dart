import 'package:i_forgot_eggs/models/app_list.dart';
import 'package:i_forgot_eggs/models/list_item.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'i_forgot_eggs.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE appLists (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE listItems (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        appListId INTEGER,
        text TEXT,
        completed INTEGER,
        FOREIGN KEY (appListId) REFERENCES appLists (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<int> insertAppList(AppList appList) async {
    final db = await database;
    return await db.insert('appLists', appList.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> insertListItem(ListItem listItem) async {
    final db = await database;
    return await db.insert('listItems', listItem.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<AppList>> getAppLists() async {
    final db = await database;
    final appListMaps = await db.query('appLists');
    List<AppList> appLists = [];

    for (var appListMap in appListMaps) {
      final listItemMaps = await db.query('listItems',
          where: 'appListId = ?', whereArgs: [appListMap['id']]);
      List<ListItem> listItems =
          listItemMaps.map((item) => ListItem.fromMap(item)).toList();
      appLists.add(AppList.fromMap(appListMap, listItems));
    }

    return appLists;
  }

  Future<int> updateAppList(AppList appList) async {
    final db = await database;
    return await db.update('appLists', appList.toMap(),
        where: 'id = ?', whereArgs: [appList.id]);
  }

  Future<int> updateListItem(ListItem listItem) async {
    final db = await database;
    return await db.update('listItems', listItem.toMap(),
        where: 'id = ?', whereArgs: [listItem.id]);
  }

  Future<int> deleteAppList(int id) async {
    final db = await database;
    return await db.delete('appLists', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteListItem(int id) async {
    final db = await database;
    return await db.delete('listItems', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
