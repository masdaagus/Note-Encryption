import 'package:flutter/material.dart';
import 'package:note_encryption/database/note_databse.dart';
import 'package:note_encryption/encryption/des/des.dart';
import 'package:note_encryption/encryption/rsa/rsa.dart';
import 'package:note_encryption/models/note.dart';
import 'package:note_encryption/screens/setting_screen/setting.dart';
import 'package:note_encryption/widgets/note_form_widget.dart';

class AddEditNotePage extends StatefulWidget {
  final Note note;

  const AddEditNotePage({
    Key key,
    this.note,
  }) : super(key: key);
  @override
  _AddEditNotePageState createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final _formKey = GlobalKey<FormState>();
  String title;
  String description;

  @override
  void initState() {
    super.initState();

    // isImportant = widget.note?.isImportant ?? false;
    // number = widget.note?.number ?? 0;
    title = widget.note?.title ?? '';
    description = widget.note?.description ?? '';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [buildButton()],
        ),
        body: Form(
          key: _formKey,
          child: NoteFormWidget(
            // number: number,
            title: title,
            description: description,
            // onChangedImportant: (isImportant) =>
            //     setState(() => this.isImportant = isImportant),
            // onChangedNumber: (number) => setState(() => this.number = number),
            onChangedTitle: (title) => setState(() => this.title = title),
            onChangedDescription: (description) =>
                setState(() => this.description = description),
          ),
        ),
      );

  Widget buildButton() {
    final isFormValid = title.isNotEmpty && description.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: isFormValid ? null : Colors.grey.shade700,
        ),
        onPressed: addOrUpdateNote,
        child: Text('Save'),
      ),
    );
  }

  void addOrUpdateNote() async {
    final isValid = _formKey.currentState.validate();

    if (isValid) {
      final isUpdating = widget.note != null;

      if (isUpdating) {
        // await updateNote();
      } else {
        await addNote();
      }

      Navigator.of(context).pop();
    }
  }

  // Future updateNote() async {
  //   // await crypt();

  //   final note = widget.note.copy(
  //     // isImportant: isImportant,
  //     // number: number,
  //     title: title,
  //     description: description,
  //   );

  //   await NotesDatabase.instance.update(note);
  // }

  Future addNote() async {
    DES des = DES();
    RSA rsa = RSA();

    String chiperDes =
        des.encryptToHexWithECB(description, des.ascii2hex(desKey));
    print("chiper c_des = $chiperDes");

    BigInt hexToBigInt = BigInt.parse(chiperDes, radix: 16);
    String numberString = hexToBigInt.toString();

    print("convert c_des to big = $hexToBigInt");

    List<String> hasil = [];
    for (int i = 0; i < numberString.length; i++) {
      var plain = numberString[i];
      var enc = rsa.encrypt(nilaiE, nilaiN, BigInt.tryParse(plain));
      hasil.add(enc.toString());
    }
    print(hasil);

    final note = Note(
      title: title,
      // isImportant: true,
      // number: number,
      description: hasil.toString(),
      createdTime: DateTime.now(),
    );

    await NotesDatabase.instance.create(note);
  }
}
