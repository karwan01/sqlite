import 'package:flutter/material.dart';
import 'package:sql_project/src/helper/database.dart';
import 'package:sql_project/src/models/note_model.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  @override
  Widget build(BuildContext context) {
    DateTime selectedDate = DateTime.now();
    TextEditingController _note = TextEditingController();

    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101),
      );
      if (picked != null && picked != selectedDate)
        setState(() {
          selectedDate = picked;
        });
    }

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            TextFormField(
              controller: _note,
              decoration: InputDecoration(
                hintText: "Note",
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text("${selectedDate.toLocal()}".split(' ')[0]),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () async {
                await _databaseHelper.add(NoteModel(
                    note: _note.value.text,
                    date: DateTime.now().toIso8601String()));
                Navigator.pop(context);
              },
              child: Text("ADD"),
            )
          ],
        ),
      ),
    );
  }
}
