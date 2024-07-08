import 'dart:convert';

import 'package:enc_flutter/main.dart';
import 'package:enc_flutter/services/user/user.dart';
import 'package:enc_flutter/services/user/user_service.dart';
import 'package:flutter/material.dart';
import 'package:hashlib/hashlib.dart';
import 'package:uuid/uuid.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _username = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("EncUrStuff", style: TextStyle(fontSize: 18)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text("Register", style: TextStyle(fontSize: 20),),
                TextFormField(
                  controller: _username,
                  validator: (String? value) {
                    if(value != null && value.isEmpty) {
                      return "Enter a username";
                    }
                    else if(value != null && value.length < 4) {
                      return "Enter a username with at least 4 characters";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Username",
                  )
                ),
                SizedBox(height: 20,),
                TextFormField(
                  controller: _email,
                  validator: (String? value) {
                    if(value != null && value.isEmpty) {
                      return "Enter a email";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Email",
                  )
                ),
                SizedBox(height: 20,),
                TextFormField(
                  controller: _password,
                  validator: (String? value) {
                    if(value != null && value.isEmpty) {
                      return "Enter a password";
                    }
                    else if(value != null && value.length < 6) {
                      return "Enter a password with at least 6 characters";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Password",
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: () async {
                    var id = Uuid().v4();
                    if(_formKey.currentState!.validate()) {
                      var newUser = User(
                        id: id, 
                        username: _username.text, 
                        email: _email.text, 
                        password: bcrypt(utf8.encode(_password.text), bcryptSalt(security: BcryptSecurity.moderate))
                      );
                      var result = await UserService.addUser(newUser);
                      if(result) {
                        var createdUser = await UserService.getUserById(id);
                        print(
                          "User created:\n $createdUser"
                        );
                        Navigator.pushAndRemoveUntil(
                        context, 
                        MaterialPageRoute(builder: (context) => HomePage()), 
                        (route) => false,
                      );
                      }
                    }
                  }, 
                  child: Text("Register"),
                ),
              ],
            )
          ),
        ),
      ),
    );
  }
}