import 'package:enc_flutter/services/encrypted_text/encrypted_text.dart';
import 'package:enc_flutter/services/encrypted_text/encrypted_text_service.dart';
import 'package:enc_flutter/widgets/encrypt_text_form.dart';
import 'package:flutter/material.dart';

class EditEncryptedText extends StatefulWidget {
  final EncryptedText encryptedText;
  final VoidCallback ? onUpdateEncryptedText;
  EditEncryptedText({required this.encryptedText, this.onUpdateEncryptedText, Key? key}) : super(key: key);
  @override
  State<EditEncryptedText> createState() => _EditEncryptedTextState();
}

class _EditEncryptedTextState extends State<EditEncryptedText> {
  TextEditingController _title = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _encryptedText = TextEditingController();
  var _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _title.text = widget.encryptedText.title;
    if(widget.encryptedText.description != null) {
      _description.text = widget.encryptedText.description!;
    }
    _encryptedText.text = widget.encryptedText.encryptedText;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            validator: (String ? value) {
              if(value == null || value.isEmpty) {
                return "Enter at least 1 character";
              }
              return null;
            },
            controller: _title,
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
          TextFormField(
            controller: _encryptedText,
            readOnly: true,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context, 
                builder: (context) {
                  return Dialog(
                    child: Container(
                      height: 600,
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: EncryptTextForm(encryptedResult: widget.encryptedText.encryptedText, onSaveEncryptedText: (String text) {
                          _encryptedText.text = text;
                        }),
                      ),
                    ),
                  );
                }
              );
            },
            child: Text("Change Encrypted Text"),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if(_formKey.currentState!.validate()) {
                bool result = await EncryptedTextService.updateEncryptedText(widget.encryptedText.id, _title.text, _description.text, _encryptedText.text);
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
            }, 
            child: Text("Update"),
          ),
        ],
      ),
    );
  }
}