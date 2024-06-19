import 'package:enc_flutter/services/cryptographer/cryptographer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReencryptTextForm extends StatefulWidget {
  final String? textToReencrypt;
  final Function(bool, String)? onReencryptText;
  ReencryptTextForm({this.textToReencrypt, this.onReencryptText});
  @override
  State<ReencryptTextForm> createState() => _ReencryptTextFormState();
}

class _ReencryptTextFormState extends State<ReencryptTextForm> {
  TextEditingController _textToReencrypt = TextEditingController();
  TextEditingController _oldPassword = TextEditingController();
  TextEditingController _newPassword = TextEditingController();
  TextEditingController _reencryptionResult = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if(widget.textToReencrypt != null && widget.textToReencrypt!.isNotEmpty) {
      _textToReencrypt.text = widget.textToReencrypt!;
    }
  }

  @override
  Widget build(BuildContext) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SingleChildScrollView(
                child: Container(
                  height: 100,
                  child: TextFormField(
                    validator: (String? value) {
                      if(value != null && value.isEmpty) {
                        return "Enter a text to reencrypt";
                      }
                      return null;
                    },
                    controller: _textToReencrypt,
                    decoration: InputDecoration(
                      labelText: "Text to Reencrypt",
                    ),
                    maxLines: null,
                  ),
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                validator: (String? value) {
                  if(value != null && value.isEmpty) {
                    return "Enter the old password";
                  }
                  return null;
                },
                controller: _oldPassword,
                decoration: InputDecoration(
                  labelText: "Old Password",
                ),
                obscureText: true,
              ),
              SizedBox(height: 20,),
              TextFormField(
                validator: (String? value) {
                  if(value != null && value.isEmpty) {
                    return "Enter the new password";
                  }
                  return null;
                },
                controller: _newPassword,
                decoration: InputDecoration(
                  labelText: "New Password",
                ),
                obscureText: true,
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: _reencryptionResult,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Result",
                ),
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () {
                  if(_formKey.currentState!.validate()) {
                    var result = Cryptographer.reencrypt(_textToReencrypt.text.split(" | ")[0], _textToReencrypt.text.split(" | ")[1], _oldPassword.text, _newPassword.text);
                    setState(() {
                      _reencryptionResult.text = result.$2;
                    });
                    if(widget.onReencryptText != null && result.$1) {
                      widget.onReencryptText!(result.$1, result.$2);
                    }
                  }
                }, 
                child: Text("Reencrypt"),
              ),
              SizedBox(height: 20,),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _textToReencrypt.clear();
                      _oldPassword.clear();
                      _newPassword.clear();
                      _reencryptionResult.clear();
                    }, 
                    child: Text("Clear"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if(_reencryptionResult.text.isNotEmpty) {
                        await Clipboard.setData(ClipboardData(text: _reencryptionResult.text));
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}