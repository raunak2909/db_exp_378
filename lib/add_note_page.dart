import 'package:db_exp_378/db_helper.dart';
import 'package:db_exp_378/db_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddNotePage extends StatelessWidget {
  var titleController = TextEditingController();
  var descController = TextEditingController();
  DBHelper? dbHelper;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Note'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ///Text('Save Note', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
              SizedBox(
                height: 11,
              ),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    labelText: 'Title',
                    hintText: 'Enter title'),
              ),
              SizedBox(
                height: 11,
              ),
              TextField(
                controller: descController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    labelText: 'Desc',
                    hintText: 'Enter desc'),
              ),
              SizedBox(
                height: 11,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                      onPressed: () {
                        var title = titleController.text;
                        var desc = descController.text;

                        dbHelper = DBHelper.getInstance();
                        context
                            .read<DBProvider>()
                            .addNote(title: title, desc: desc);

                        Navigator.pop(context);
                      },
                      child: Text('Save')),
                  SizedBox(
                    width: 11,
                  ),
                  OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel')),
                ],
              )
            ],
          ),
        ));
  }
}
