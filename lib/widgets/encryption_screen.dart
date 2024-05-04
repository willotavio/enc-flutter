import 'package:enc_flutter/widgets/encryption_form.dart';
import 'package:flutter/material.dart';

class EncryptionScreen extends StatefulWidget{
  @override
  State<EncryptionScreen> createState() => _EncryptionScreenState();
}

class _EncryptionScreenState extends State<EncryptionScreen> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: EncryptionForm(),
    );
  }
}