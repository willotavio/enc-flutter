import 'package:enc_flutter/services/cryptographer/cryptographer.dart';
import 'package:flutter/material.dart';

class EncryptTextForm extends StatefulWidget {
  final String ? encryptedResult;
  final Function(String) ? onSaveEncryptedText;
  EncryptTextForm({this.encryptedResult, this.onSaveEncryptedText, Key ? key}) : super(key:key);
  @override
  State<EncryptTextForm> createState() => _EncryptTextFormState();
}

class _EncryptTextFormState extends State<EncryptTextForm> {
  TextEditingController _textToEncrypt = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _encryptedResult = TextEditingController();
  var _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if(widget.encryptedResult != null && widget.encryptedResult!.isNotEmpty) {
      this._encryptedResult.text = widget.encryptedResult!;
    }
  }

  @override
  Widget build(BuildContext) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              validator: (String ? value) {
                if(value == null || value.isEmpty) {
                  return "Enter at least 1 character to be encrypted";
                }
                return null;
              },
              controller: _textToEncrypt,
              decoration: InputDecoration(
                labelText: "Text to encrypt",
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              validator: (String ? value) {
                if(value == null || value.isEmpty) {
                  return "Enter a password with at least 12 characters";
                }
                return null;
              },
              controller: _password,
              decoration: InputDecoration(
                labelText: "Password",
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _encryptedResult,
              decoration: InputDecoration(
                labelText: "Result",
              ),
              readOnly: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if(_formKey.currentState!.validate()) {
                  setState(() {
                    var result = Cryptographer.encrypt(_textToEncrypt.text, _password.text);
                    if(result.$1) {
                      _encryptedResult.text = result.$2;
                    }
                  });
                }
              },
              child: Text("Encrypt"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if(widget.onSaveEncryptedText != null) {
                  widget.onSaveEncryptedText!(_encryptedResult.text);
                  Navigator.of(context).pop();
                }
              },
              child: Text("Confirm"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
          ],
        ),
      ), 
    );
  }
}