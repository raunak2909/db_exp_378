import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper{

  static const String TABLE_NAME = "notes";
  static const String COLUMN_NOTE_ID = "note_id";
  static const String COLUMN_NOTE_TITLE = "note_title";
  static const String COLUMN_NOTE_DESC = "note_desc";
  static const String COLUMN_NOTE_CREATED_AT = "note_created_at";

  DBHelper._();
  ///private constructor

  static DBHelper getInstance(){
    return DBHelper._();
  }

  Database? mDB;

  Future<Database> initDB() async{

    if(mDB==null) {
      mDB = await openDB();
      return mDB!;
    } else {
      return mDB!;
    }

  }


  Future<Database> openDB() async{

    Directory appDir = await getApplicationDocumentsDirectory();

    String dbPath = join(appDir.path, "noteDB.db");


    return await openDatabase(dbPath, version: 1, onCreate: (db, version){
      /// create all tables

      db.execute("create table $TABLE_NAME ( $COLUMN_NOTE_ID integer primary key autoincrement, $COLUMN_NOTE_TITLE text, $COLUMN_NOTE_DESC text, $COLUMN_NOTE_CREATED_AT text)");

    });

  }






  ///queries
  Future<bool> addNote({required String title, required String desc}) async{

    var db = await initDB();

    int rowsEffected = await db.insert(TABLE_NAME, {
      COLUMN_NOTE_TITLE : title,
      COLUMN_NOTE_DESC : desc,
      COLUMN_NOTE_CREATED_AT : DateTime.now().millisecondsSinceEpoch.toString()
    });

    return rowsEffected>0;

  }

  Future<List<Map<String, dynamic>>> fetchAllNotes() async{

    var db = await initDB();

    return await db.query(TABLE_NAME);

  }

  Future<bool> updateNote({required String title, required String desc, required int id}) async{

    var db = await initDB();

    int rowsEffected = await db.update(TABLE_NAME, {
      COLUMN_NOTE_TITLE : title,
      COLUMN_NOTE_DESC : desc,
    }, where: "$COLUMN_NOTE_ID = ?", whereArgs: ["$id"]);

    return rowsEffected>0;

  }

  Future<bool> deleteNote(int id) async{

    var db = await initDB();

    int rowsEffected = await db.delete(TABLE_NAME, where: "$COLUMN_NOTE_ID = ?", whereArgs: ["$id"]);

    return rowsEffected>0;

  }


}