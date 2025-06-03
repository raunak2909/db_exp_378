import 'package:db_exp_378/add_note_page.dart';
import 'package:db_exp_378/db_helper.dart';
import 'package:db_exp_378/db_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => DBProvider(dbHelper: DBHelper.getInstance()),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> mNotes = [];
  var titleController = TextEditingController();
  var descController = TextEditingController();
  DateFormat df = DateFormat.yMMMEd();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<DBProvider>().getInitialNotes();

    ///getAllNotes();
  }

  /*getAllNotes() async {
    mNotes = await dbHelper!.fetchAllNotes();
    setState(() {});
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: Consumer<DBProvider>(
        builder: (_, provider, __) {
          mNotes = provider.getData();

          return mNotes.isNotEmpty
              ? ListView.builder(
                  itemCount: mNotes.length,
                  itemBuilder: (_, index) {
                    var eachDate = df.format(
                        DateTime.fromMillisecondsSinceEpoch(int.parse(
                            mNotes[index][DBHelper.COLUMN_NOTE_CREATED_AT])));
                    return ListTile(
                      title: Text(mNotes[index][DBHelper.COLUMN_NOTE_TITLE]),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(mNotes[index][DBHelper.COLUMN_NOTE_DESC]),
                          Text(eachDate),
                        ],
                      ),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  ///update the data
                                  titleController.text =
                                      mNotes[index][DBHelper.COLUMN_NOTE_TITLE];
                                  descController.text =
                                      mNotes[index][DBHelper.COLUMN_NOTE_DESC];
                                  showModalBottomSheet(
                                      enableDrag: false,
                                      isDismissible: false,
                                      context: context,
                                      builder: (_) {
                                        return getBottomSheetUI(
                                            isUpdate: true, index: index);
                                      });
                                },
                                icon: Icon(
                                  Icons.edit,
                                )),
                            IconButton(
                                onPressed: () {
                                  context.read<DBProvider>().deleteNote(
                                      id: mNotes[index]
                                          [DBHelper.COLUMN_NOTE_ID]);
                                  /*dbHelper!.deleteNote(
                                  mNotes[index][DBHelper.COLUMN_NOTE_ID]);
                              getAllNotes();*/
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )),
                          ],
                        ),
                      ),
                    );
                  })
              : Center(
                  child: Text("No Notes yet!!"),
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          titleController.clear();
          descController.clear();

          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddNotePage(),
              ));

          /*showModalBottomSheet(
            enableDrag: false,
            isDismissible: false,
              context: context,
              builder: (_){
                return getBottomSheetUI();
              });*/
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget getBottomSheetUI({bool isUpdate = false, int index = -1}) {
    return Container(
      width: double.infinity,
      height: 500,
      padding: EdgeInsets.all(11),
      child: Column(
        children: [
          Text(
            'Save Note',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 11,
          ),
          TextField(
            controller: titleController,
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                labelText: 'Title',
                hintText: 'Enter title'),
          ),
          SizedBox(
            height: 11,
          ),
          TextField(
            controller: descController,
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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

                    if (isUpdate) {
                      context.read<DBProvider>().updateNote(
                          title: title,
                          desc: desc,
                          id: mNotes[index][DBHelper.COLUMN_NOTE_ID]);
                      Navigator.pop(context);
                    }

                    /*if (isUpdate) {
                      dbHelper!.updateNote(
                          title: title,
                          desc: desc,
                          id: mNotes[index][DBHelper.COLUMN_NOTE_ID]);
                    } else {
                      dbHelper!.addNote(title: title, desc: desc);
                    }
                    getAllNotes();
                    Navigator.pop(context);*/
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
    );
  }
}
