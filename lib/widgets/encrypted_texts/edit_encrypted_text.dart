import 'package:enc_flutter/services/encrypted_text/encrypted_text.dart';
import 'package:enc_flutter/services/encrypted_text/encrypted_text_service.dart';
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
  var _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _title.text = widget.encryptedText.title;
    if(widget.encryptedText.description != null) {
      _description.text = widget.encryptedText.description!;
    }
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
          ElevatedButton(
            onPressed: () async {
              if(_formKey.currentState!.validate()) {
                await EncryptedTextService.updateEncryptedText(widget.encryptedText.id, _title.text, _description.text, null);
                if(widget.onUpdateEncryptedText != null) {
                  widget.onUpdateEncryptedText!();
                }
                Navigator.of(context).pop();
              }
            }, 
            child: Text("Update"),
          ),
        ],
      ),
    );
  }
}