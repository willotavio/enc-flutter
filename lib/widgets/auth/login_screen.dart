import 'package:enc_flutter/main.dart';
import 'package:enc_flutter/services/user/user_service.dart';
import 'package:flutter/material.dart';
import 'package:password_dart/password_dart.dart';

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
      appBar: AppBar(
        title: Text("EncUrStuff", style: TextStyle(fontSize: 18)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
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
                    if(Password.verify(_password.text, users[0].password)) {
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
              ),
            ],
          )
        ),
      ),
    );
  }
}