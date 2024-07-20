import 'dart:convert';

import 'package:enc_flutter/services/encrypted_text/encrypted_text.dart';
import 'package:enc_flutter/services/encrypted_text/encrypted_text_service.dart';
import 'package:enc_flutter/services/user/user_service.dart';
import 'package:enc_flutter/widgets/encryption/encrypt_text_form.dart';
import 'package:flutter/material.dart';
import 'package:hashlib/hashlib.dart';

class EditEncryptedText extends StatefulWidget {
  final EncryptedText encryptedText;
  final VoidCallback ? onUpdateEncryptedText;
  EditEncryptedText({required this.encryptedText, this.onUpdateEncryptedText, Key? key}) : super(key: key);
  @override
  State<EditEncryptedText> createState() => _EditEncryptedTextState();
}

class _EditEncryptedTextState extends State<EditEncryptedText> {
  TextEditingController _encryptedText = TextEditingController();
  TextEditingController _title = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _password = TextEditingController();
  var _formKey = GlobalKey<FormState>();


  late String _encryptionMethod;

  bool _buttonEnabled = false;

  @override
  void initState() {
    super.initState();
    _title.text = widget.encryptedText.title;
    _encryptionMethod = widget.encryptedText.encryptionMethod;
    if(widget.encryptedText.description != null) {
      _description.text = widget.encryptedText.description!;
    }
    _encryptedText.text = widget.encryptedText.encryptedText;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: "Encrypted Text",
                prefixIcon: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context, 
                      builder: (context) {
                        return Dialog(
                          child: Container(
                            height: 600,
                            child: Padding(
                              padding: const EdgeInsets.all(40.0),
                              // what the encrypt form will do after encrypt will be defined by the widget caller
                              child: EncryptTextForm(encryptedResult: widget.encryptedText.encryptedText, onSaveEncryptedText: (String encryptionResult, String newEncryptionMethod) {
                                _encryptedText.text = encryptionResult;
                                _encryptionMethod = newEncryptionMethod;
                                _buttonEnabled = true;
                                setState(() {});
                                // in this case, close the modal
                                Navigator.of(context).pop();
                              }),
                            ),
                          ),
                        );
                      }
                    );
                  }, 
                  icon: Icon(Icons.edit),
                ),
              ),
              controller: _encryptedText,
              readOnly: true,
            ),
            SizedBox(height: 20,),
            TextFormField(
              validator: (String ? value) {
                if(value == null || value.isEmpty) {
                  return "Enter at least 1 character";
                }
                return null;
              },
              controller: _title,
              decoration: InputDecoration(
                labelText: "Title",
              ),
              onChanged: (String? value) {
                if(value != widget.encryptedText.title) {
                _buttonEnabled = true;
                setState(() {});
              } 
              else if(value == widget.encryptedText.title) {
                _buttonEnabled = false;
                setState(() {});
              }
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _description,
              decoration: InputDecoration(
                labelText: "Description",
              ),
              onChanged: (String? value) {
                String? newValue = value == "" ? null : value;
                if(newValue != widget.encryptedText.description) {
                  _buttonEnabled = true;
                  setState(() {});
                } 
                else if(newValue == widget.encryptedText.description
                  || widget.encryptedText.description == null && newValue == "") {
                  _buttonEnabled = false;
                  setState(() {});
                }
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              validator: (String? value) {
                if(value != null && value.isEmpty) {
                  return "Enter your account password";
                }
                return null;
              },
              controller: _password,
              decoration: InputDecoration(
                label: Text("Password"),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20,),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                ElevatedButton(
                  onPressed: _buttonEnabled ? () async {
                    if(_formKey.currentState!.validate()) {
                      var users = await UserService.getUsers();
                      if(bcryptVerify(users[0].password, utf8.encode(_password.text))) {
                        String? newEncryptedText = _encryptedText.text.isNotEmpty ? _encryptedText.text : null;
                        String? newTitle = _title.text.isNotEmpty ? _title.text : null;
                        String? newDescription = _description.text.isNotEmpty ? _description.text : null;
                        String? newEncryptionMethod = _encryptionMethod.isNotEmpty ? _encryptionMethod : null;
                        if(newEncryptedText != widget.encryptedText.encryptedText
                          || newTitle != widget.encryptedText.title
                          || newDescription != widget.encryptedText.description
                          || newEncryptionMethod != widget.encryptedText.encryptionMethod) {
                          bool result = await EncryptedTextService.updateEncryptedText(widget.encryptedText.id, newTitle, newDescription, newEncryptedText, _encryptionMethod);
                          if(result) {
                            if(widget.onUpdateEncryptedText != null) {
                              widget.onUpdateEncryptedText!();
                            }
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
                        }
                      }
                      else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Wrong password (|-v-)/"),
                            duration: Duration(seconds: 1),
                            dismissDirection: DismissDirection.horizontal,
                            showCloseIcon: true,
                          ),
                        );
                      }
                    }
                  } : null,
                  child: Text("Update"),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(100, 50),
                    disabledBackgroundColor: Colors.grey,
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                  }, 
                  child: Text("Cancel"),
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(Size(100, 50)),
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                    overlayColor: MaterialStateProperty.all(Color.fromARGB(255, 244, 40, 54)),
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