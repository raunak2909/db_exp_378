import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper{

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

      db.execute("create table notes ( note_id integer primary key autoincrement, note_title text, note_desc text)");

    });

  }






  ///queries
  void addNote({required String title, required String desc}) async{

    var db = await initDB();

    db.insert("notes", {
      "note_title" : title,
      "note_desc" : desc
    });

  }

  Future<List<Map<String, dynamic>>> fetchAllNotes() async{

    var db = await initDB();

    return await db.query("notes");

  }

  void updateNote(){

  }

  void deleteNote(){

  }


}