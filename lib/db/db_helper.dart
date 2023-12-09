import 'package:sqflite/sqflite.dart';
import 'package:todoapp/models/task.dart';

class DBHelper {
  static Database? _database;
  static const int _version = 1;
  static const String _tableName = 'tasks';

  // 1# Method to initialize db
  static Future<void> initDatabase() async {
    if (_database != null) {
      print('DataBase != null');
      return;
    } else {
      try {
        // Get a location using getDatabasesPath
        String _path = await getDatabasesPath()+'task.db';
        print('in db path');
        // open the database
        _database = await openDatabase(_path, version: _version,
            onCreate: (Database db, int version) async {
          // When creating the db, create the table
          print('Create new Db');
          await db.execute(
            'CREATE TABLE $_tableName ('
            'id INTEGER PRIMARY KEY AUTOINCREMENT, '
            'title STRING, '
            'note TEXT, '
            'date STRING, '
            'startTime STRING, '
            'endTime STRING, '
            'repeat STRING, '
            'isCompleted INTEGER, '
            'remind INTEGER, '
            'color INTEGER)',
          );
        });
      } catch (e) {
        print(e);
      }
    }
  }

  //2# Start insert method
  static Future<int> insert(Task? task) async {
    print('insert Function called');
    return await _database!.insert(_tableName, task!.toJson());
  }

  //3# Start delete method
  static Future<int> delete(Task? task) async {
    print('delete Function called');

    /// id = something  , 'id = ?'  => SQL Syntax

    return await _database!.delete(_tableName,
        where: 'id = ?',
        whereArgs: [task!.id]); //delete in condition  =>  id = task.id
  }

  static Future<int> deleteAll() async {
    print('delete Function called');
    // id = something  , 'id = ?'  => SQL Syntax
    return await _database!.delete(_tableName); //delete in condition  =>  id = task.id
  }

  // Start Query method  استفسر من الداتابيز على مجموعة من البيانات
  // 3# Get Data
  static Future<List<Map<String, Object?>>> query() async {
    print('query Function called');
    return await _database!.query(_tableName);
  }

  // 4# start Update method
  static Future<int> update(int id) async {
    print('update Function called');
    return await _database!.rawUpdate('''
    UPDATE tasks
    SET isCompleted = ?
    WHERE id = ?
    ''', [1, id]);
  }



}
