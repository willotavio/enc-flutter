import 'package:enc_flutter/widgets/reencryption_form.dart';
import 'package:flutter/material.dart';

class ReencryptionScreen extends StatefulWidget{
  @override
  State<ReencryptionScreen> createState() => _ReencryptionScreenState();
}

class _ReencryptionScreenState extends State<ReencryptionScreen>{
  

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: ReencryptionForm(),
    ); 
  }
}