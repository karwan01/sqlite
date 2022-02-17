import 'package:flutter/material.dart';
import 'package:sql_project/src/helper/database.dart';
import 'package:sql_project/src/models/note_model.dart';
import 'package:sql_project/src/update_screen/update_screen.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  int? selectedId;
  String? note;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<List<NoteModel>>(
        future: _databaseHelper.getNotes(),
        builder:
            (BuildContext context, AsyncSnapshot<List<NoteModel>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.isEmpty) {
            return Center(
              child: Text("No notes to show "),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final item = snapshot.data![index];
              return Dismissible(
                  direction: DismissDirection.endToStart,
                  // Each Dismissible must contain a Key. Keys allow Flutter to
                  // uniquely identify widgets.
                  key: Key(item.id.toString()),
                  // Provide a function that tells the app
                  // what to do after an item has been swiped away.
                  onDismissed: (direction) {
                    // Remove the item from the data source.
                    _databaseHelper.remove(item.id!);
                    setState(() {
                      snapshot.data!.removeAt(index);
                    });

                    // Then show a snackbar.
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${item.note} deleted')));
                  },
                  // Show a red background as the item is swiped away.
                  background: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      child: Center(
                        child: Text(
                          "delete",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      color: Colors.red.shade400,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedId = item.id;
                          note = item.note;
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UpdateScreen(
                                      note: item.note,
                                      selectedId: item.id,
                                    )));
                      },
                      child: Card(
                        color: Colors.blue.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Note: ${item.id}"),
                              Text(item.note),
                              Text(item.date),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ));
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addScreen');
        },
        child: Icon(Icons.note_add),
      ),
    );
  }
}
