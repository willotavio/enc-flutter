import 'package:enc_flutter/services/cryptographer/cryptographer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EncryptTextForm extends StatefulWidget {
  final String ? encryptedResult;
  final Function(String, String) ? onSaveEncryptedText;
  EncryptTextForm({this.encryptedResult, this.onSaveEncryptedText, Key ? key}) : super(key:key);
  @override
  State<EncryptTextForm> createState() => _EncryptTextFormState();
}

class _EncryptTextFormState extends State<EncryptTextForm> {
  TextEditingController _textToEncrypt = TextEditingController();
  TextEditingController _encryptionPassword = TextEditingController();
  
  List<String> _encryptionMethods = [
    "AES-128-CBC",
    "AES-192-CBC",
    "AES-256-CBC"
  ];

  List<DropdownMenuItem> _encryptionMethodsDropdown = [];
  late String _encryptionMethod;

  TextEditingController _encryptedResult = TextEditingController();
  var _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if(widget.encryptedResult != null && widget.encryptedResult!.isNotEmpty) {
      this._encryptedResult.text = widget.encryptedResult!;
    }
    List<DropdownMenuItem> _encryptionMethodsDropdownList = [];
    for(int i = 0; i < _encryptionMethods.length; i++) {
      _encryptionMethodsDropdownList.add(
        DropdownMenuItem(
          child: Text(_encryptionMethods[i]),
          value: _encryptionMethods[i],
        ),
      );
    } 
    setState(() {
      _encryptionMethodsDropdown = _encryptionMethodsDropdownList;
    });
  }

  @override
  Widget build(BuildContext) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SingleChildScrollView(
              child: Container(
                height: 100,
                child: TextFormField(
                  validator: (String ? value) {
                    if(value == null || value.isEmpty) {
                      return "Enter at least 1 character (*/-д-)/";
                    }
                    return null;
                  },
                  controller: _textToEncrypt,
                  decoration: InputDecoration(
                    labelText: "Text to encrypt",
                  ),
                  maxLines: null,
                ),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              validator: (String ? value) {
                if(value == null || value.isEmpty) {
                  return "Provide a password (*/-д-)/";
                }
                else if(value.length < 12) {
                  return "The password must have at least 12 characters (*/-д-)/";
                }
                return null;
              },
              controller: _encryptionPassword,
              decoration: InputDecoration(
                labelText: "Password",
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            DropdownButtonFormField(
              hint: Text("Select an encryption method"),
              validator: (dynamic value) {
                if(value == null) {
                  return "Choose a valid option";
                }
                return null;
              },
              items: _encryptionMethodsDropdown,
              onChanged: (dynamic value) {
                setState(() {
                  _encryptionMethod = value;
                });
              }
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if(_formKey.currentState!.validate()) {
                  setState(() {
                    var result = Cryptographer.encrypt(_textToEncrypt.text, _encryptionPassword.text, _encryptionMethod);
                    if(result.$1) {
                      _encryptedResult.text = result.$2;
                    }
                  });
                  if(widget.onSaveEncryptedText != null) {
                    widget.onSaveEncryptedText!(_encryptedResult.text, _encryptionMethod);
                  }
                }
              },
              child: Text("Encrypt"),
              style: ElevatedButton.styleFrom(
                fixedSize: Size(100, 50),
              ),
            ),
            TextFormField(
              controller: _encryptedResult,
              decoration: InputDecoration(
                labelText: "Result",
              ),
              readOnly: true,
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _textToEncrypt.text = "";
                    _encryptionPassword.text = "";
                    _encryptedResult.text = "";
                  },
                  child: Text("Clear"),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(100, 50),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async{
                    if(_encryptedResult.text.isNotEmpty){
                      await Clipboard.setData(ClipboardData(text: _encryptedResult.text));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Copied (/•v•)/!"),
                          duration: Duration(seconds: 1),
                          dismissDirection: DismissDirection.horizontal,
                          showCloseIcon: true,
                        ),
                      );
                    }
                  },
                  child: Text("Copy"),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(100, 50),
                  ),
                ),
              ],
            ),
          ],
        ),
      ), 
    );
  }
}