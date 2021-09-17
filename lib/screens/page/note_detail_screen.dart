import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:note_encryption/database/note_databse.dart';
import 'package:note_encryption/encryption/des/des.dart';
import 'package:note_encryption/encryption/rsa/rsa.dart';

import 'package:note_encryption/models/note.dart';
import 'package:note_encryption/screens/setting_screen/setting.dart';

import 'edit_note_srceen.dart';

class NoteDetailPage extends StatefulWidget {
  final int noteId;

  const NoteDetailPage({
    Key key,
    this.noteId,
  }) : super(key: key);

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  Note note;
  bool isLoading = false;
  String _decrypt;

  @override
  void initState() {
    super.initState();

    refreshNote();
  }

  Future refreshNote() async {
    setState(() => isLoading = true);

    this.note = await NotesDatabase.instance.readNote(widget.noteId);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [
            // editButton(),
            deleteButton()
          ],
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.all(12),
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  children: [
                    Text(
                      note.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      DateFormat.yMMMd().format(note.createdTime),
                      style: TextStyle(color: Colors.white38),
                    ),
                    SizedBox(height: 12),
                    Text(
                      note.description.replaceAll(RegExp(r'[^\w\s]+'), ''),
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                    SizedBox(height: 60),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          onPrimary: Colors.white,
                          // primary: isFormValid ? null : Colors.grey.shade700,
                        ),
                        onPressed: decText,
                        child: Text('Decrypt Note'),
                      ),
                    ),
                    SizedBox(height: 60),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hasil Decryption",
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 25),
                        Text(
                          _decrypt ?? '',
                          style: TextStyle(color: Colors.white70, fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      );

  Future<void> decText() async {
    DES des = DES();
    RSA rsa = RSA();

    List<String> chiper = note.description.split(' ');
    List<BigInt> bismillah = []; // ini chiper dari rsa
    List<BigInt> plainRSA = [];
    try {
      /// Merubah String chiper ke BigInt
      for (int i = 0; i < chiper.length; i++) {
        var x = chiper[i].replaceAll(RegExp(r'[^\w\s]+'), '');
        var big = BigInt.tryParse(x);
        bismillah.add(big);
      }

      /// fungsi decryption RSA
      for (int i = 0; i < bismillah.length; i++) {
        BigInt x = bismillah[i];
        BigInt d = rsa.decript(nilaiD, nilaiN, x);
        plainRSA.add(d);
      }

      // hasil decrypt dari [RSA] di convert ke hex dan di-decrypt menggunakan [DES]
      String chipDec = plainRSA.join();
      BigInt a = BigInt.tryParse(chipDec);
      String big2hex = a.toRadixString(16).toUpperCase();
      String decDes = des.decryptFromHexWithECB(big2hex, des.ascii2hex(desKey));

      _decrypt = decDes;

      refreshNote();
      print("chiper text [RSA] = $bismillah");
      print("plain text [RSA] = $a");
      print("chiper text [DES] = $big2hex");
      print("plain text = $decDes");
    } catch (e) {
      print("Error");
    }

    if (_decrypt == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Key Anda Salah"),
        ),
      );
    }
  }

  Widget deleteButton() => IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          await NotesDatabase.instance.delete(widget.noteId);

          Navigator.of(context).pop();
        },
      );

  Widget editButton() => IconButton(
      icon: Icon(Icons.edit_outlined),
      onPressed: () async {
        if (isLoading) return;

        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddEditNotePage(note: note),
        ));

        refreshNote();
      });
}
