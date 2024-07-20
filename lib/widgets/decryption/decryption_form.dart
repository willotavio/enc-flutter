import 'package:enc_flutter/services/cryptographer/cryptographer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DecryptionForm extends StatefulWidget {
  final String? encryptedText;
  final String? encryptionMethod;
  DecryptionForm({this.encryptedText, this.encryptionMethod});
  @override
  State<DecryptionForm> createState() => _DecryptionFormState();
}

class _DecryptionFormState extends State<DecryptionForm> {
  TextEditingController _textToDecryptController = TextEditingController();
  TextEditingController _decryptionPasswordController = TextEditingController();

  List<String> _encryptionMethods = [
    "AES-128-CBC",
    "AES-192-CBC",
    "AES-256-CBC"
  ];

  List<DropdownMenuItem> _encryptionMethodsDropdown = [];
  String? _encryptionMethod;

  TextEditingController _decryptedTextResult = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if(widget.encryptedText != null) {
      _textToDecryptController.text = widget.encryptedText!;
    }
    if(widget.encryptionMethod != null) {
      _encryptionMethod = widget.encryptionMethod!;
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
    String? _validateTextToDecrypt(String? value){
      if(value == null || value.isEmpty){
        return "Enter something to be encrypted (*/•_•)/";
      }
      return null;
    }
    String? _validateDecryptionPassword(String? value){
      if(value == null || value.isEmpty){
        return "Enter the decryption password (*/•_•)/";
      }
      else if(value.length < 12){
        return "Decryption password must have at least 12 characters (*/•_•)/";
      }
      return null;
    }

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SingleChildScrollView(
                  child: Container(
                    height: 100,
                    child: TextFormField(
                      controller: _textToDecryptController,
                      validator: _validateTextToDecrypt,
                      decoration: InputDecoration(
                        labelText: "Enter a text to decrypt",
                      ),
                      maxLines: null,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _decryptionPasswordController,
                  validator: _validateDecryptionPassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Enter the decryption password",
                  ),
                ),
                SizedBox(height: 20),
                DropdownButtonFormField(
                  value: _encryptionMethod ?? null,
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
                    if(_formKey.currentState?.validate() ?? false){
                      final result = Cryptographer.decrypt(_textToDecryptController.text.split(" | ")[0], _textToDecryptController.text.split(" | ")[1], _decryptionPasswordController.text, _encryptionMethod!);
                      setState(() {
                        _decryptedTextResult.text = result.$2;
                      });
                    }
                  },
                  child: Text("Decrypt"),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(100,50),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    height: 100,
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: IconButton(
                          onPressed: _decryptedTextResult.text.isNotEmpty ? () {
                            showDialog(
                              context: context, 
                              builder: (context) {
                                return Dialog(
                                  child: Padding(
                                    padding: EdgeInsets.all(40.0),
                                    child: SingleChildScrollView(
                                      child: Text(_decryptedTextResult.text)
                                    ),
                                  ),
                                );
                              }
                            );
                          } : null,
                          icon: Icon(Icons.remove_red_eye),
                        ),
                      ),
                      controller: _decryptedTextResult,
                      readOnly: true,
                      maxLines: null,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    ElevatedButton(
                      onPressed: () async{
                        if(_decryptedTextResult.text.isNotEmpty){
                          await Clipboard.setData(ClipboardData(text: _decryptedTextResult.text));
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
                    ElevatedButton(
                      onPressed: () {
                        _textToDecryptController.text = "";
                        _decryptionPasswordController.text = "";
                        _decryptedTextResult.text = "";
                      },
                      child: Text("Clear"),
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(100, 50)
                      ),
                    )
                  ],
                ),
              ],
            ),  
          ),
        ),
      ),
    );
  }
}