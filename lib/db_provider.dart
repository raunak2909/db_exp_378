import 'package:db_exp_378/db_helper.dart';
import 'package:flutter/material.dart';

class DBProvider extends ChangeNotifier{

  DBHelper dbHelper;
  DBProvider({required this.dbHelper});

  ///data
  List<Map<String, dynamic>> _mData = [];

  List<Map<String, dynamic>> getData() => _mData;

  ///events
  void addNote({required String title, required String desc}) async{
    bool check = await dbHelper.addNote(title: title, desc: desc);

    if(check) {
      _mData = await dbHelper.fetchAllNotes();
      notifyListeners();
    }
  }

  void getInitialNotes() async{
    _mData = await dbHelper.fetchAllNotes();
    notifyListeners();
  }

  void updateNote({required String title, required String desc, required int id}) async{

    bool check = await dbHelper.updateNote(title: title, desc: desc, id: id);

    if(check){
      _mData = await dbHelper.fetchAllNotes();
      notifyListeners();
    }

  }

  void deleteNote({required int id}) async{

    bool check = await dbHelper.deleteNote(id);

    if(check){
      _mData = await dbHelper.fetchAllNotes();
      notifyListeners();
    }

  }

}