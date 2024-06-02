import 'package:enc_flutter/services/encrypted_text/encrypted_text.dart';
import 'package:enc_flutter/services/encrypted_text/encrypted_text_service.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class SaveEncryptionTextForm extends StatefulWidget{
  final String encryptedTextResult;
  SaveEncryptionTextForm({required this.encryptedTextResult, Key? key}) : super(key: key);
  @override
  State<SaveEncryptionTextForm> createState() => _SaveEncryptionTextForm();
}

class _SaveEncryptionTextForm extends State<SaveEncryptionTextForm> {
  TextEditingController _title = TextEditingController();
  TextEditingController _description = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _validateTitle(String? value) {
    if(value == null || value.isEmpty) {
      return "Enter at least 1 character (*/-д-)/";
    }
    return null;
  }

  @override
  Widget build(BuildContext) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Save this encrypted text", style: TextStyle(fontSize: 20),),
            SizedBox(height: 20),
            TextFormField(
              controller: _title,
              validator: _validateTitle,
              decoration: InputDecoration(
                labelText: "Enter a title",
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _description,
              decoration: InputDecoration(
                labelText: "Enter a description",
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if(_formKey.currentState!.validate()) {
                  await EncryptedTextService.insertEncryptedText(EncryptedText(id: Uuid().v4(), title: _title.text, description: _description.text.isNotEmpty ? _description.text : null, encryptedText: widget.encryptedTextResult));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Saved (/•v-)/"),
                      duration: Duration(seconds: 1),
                      dismissDirection: DismissDirection.horizontal,
                      showCloseIcon: true,
                    ),
                  );
                  Navigator.of(context).pop();
                }
              },
              child: Text("Confirm"),
            ),
          ]
        ),
      ),
    );
  }
}