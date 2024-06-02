import 'package:enc_flutter/widgets/decryption/decryption_form.dart';
import 'package:flutter/material.dart';

class DecryptionScreen extends StatefulWidget{
  @override
  State<DecryptionScreen> createState() => _DecryptionScreenState();
}

class _DecryptionScreenState extends State<DecryptionScreen> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: DecryptionForm(),
    );
  }
}