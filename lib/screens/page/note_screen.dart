import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:note_encryption/database/note_databse.dart';
import 'package:note_encryption/encryption/rsa/rsa.dart';
import 'package:note_encryption/models/note.dart';
import 'package:note_encryption/screens/setting_screen/setting.dart';
import 'package:note_encryption/widgets/note_card_widget.dart';

import 'edit_note_srceen.dart';
import 'note_detail_screen.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<Note> notes;
  bool isLoading = false;

  RSA realRSA = RSA();

  BigInt valueN() {
    var n = realRSA.fn(nilaiP, nilaiQ);
    return nilaiN = n;
  }

  BigInt valueR() {
    var r = realRSA.fr(nilaiP, nilaiQ);
    return nilaiR = r;
  }

  BigInt valueD() {
    BigInt d = realRSA.multInv(nilaiE, nilaiR);
    return nilaiD = d;
  }

  @override
  void initState() {
    desKey = 12345678.toString();
    valueN();
    valueR();
    for (BigInt i = BigInt.one; i < BigInt.from(100); i += BigInt.one) {
      if (realRSA.egcd(i, nilaiR) == BigInt.one) {
        nilaiE = i;
      }
    }
    valueD();
    print("nilai R = $nilaiR");
    print("nilai E = $nilaiE");
    print("nilai D = $nilaiD");
    print("DES-Key = $desKey");
    super.initState();

    refreshNotes();
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();

    super.dispose();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    this.notes = await NotesDatabase.instance.readAllNotes();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          elevation: .5,
          title: Text(
            'Notes',
            style: TextStyle(fontSize: 24),
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  );
                },
                icon: Icon(Icons.settings)),
            SizedBox(width: 12),
          ],
        ),
        body: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : notes.isEmpty
                  ? Text(
                      'Tidak ada catatan',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    )
                  : buildNotes(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(Icons.add),
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddEditNotePage()),
            );

            refreshNotes();
          },
        ),
      );

  Widget buildNotes() => StaggeredGridView.countBuilder(
        padding: EdgeInsets.all(8),
        itemCount: notes.length,
        staggeredTileBuilder: (index) => StaggeredTile.fit(2),
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) {
          final note = notes[index];

          return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NoteDetailPage(noteId: note.id),
              ));

              refreshNotes();
            },
            child: NoteCardWidget(note: note, index: index),
          );
        },
      );
}
