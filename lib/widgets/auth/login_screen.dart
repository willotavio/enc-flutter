import 'dart:convert';

import 'package:enc_flutter/main.dart';
import 'package:enc_flutter/services/user/user_service.dart';
import 'package:flutter/material.dart';
import 'package:hashlib/hashlib.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _password = TextEditingController();
  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40.0, 0, 40.0, 80.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text("Login", style: TextStyle(fontSize: 20),),
                  SizedBox(height: 20,),
                  TextFormField(
                    controller: _password,
                    validator: (String? value) {
                      if(value != null && value.isEmpty) {
                        return "Enter a password";
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
                      if(_formKey.currentState!.validate()) {
                        var users = await UserService.getUsers();
                        if(bcryptVerify(users[0].password, utf8.encode(_password.text))) {
                          Navigator.pushReplacement(
                            context, 
                            MaterialPageRoute(builder: (context) => HomePage()), 
                          );
                        }
                        else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Wrong password"),
                              dismissDirection: DismissDirection.startToEnd,
                              showCloseIcon: true,
                              duration: Duration(seconds: 1),
                            ),
                          );
                        }
                      }
                    }, 
                    child: Text("Login"),
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(125, 50),
                    ),
                  ),
                ],
              )
            ),
          ),
        ),
      ),
    );
  }
}