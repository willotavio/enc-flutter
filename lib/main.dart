import 'package:enc_flutter/screens/encrypted_texts_list.dart';

import '../screens/reencryption_screen.dart';
import 'package:flutter/material.dart';
import './screens/encryption_screen.dart';
import './screens/decryption_screen.dart';

void main(){
  runApp(MainApp());
}

class MainApp extends StatelessWidget{
  const MainApp({super.key});
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: "Enc-Flutter",
      darkTheme: ThemeData.dark(
        useMaterial3: true
      ),
      home: HomePage()
    );
  }
}

class HomePage extends StatefulWidget{
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context){
    Widget page;
    switch(selectedIndex){
      case 0:
        page = EncrypterScreen();
        break;
      case 1:
        page = EncryptedTextsList();
        break;
      default:
        throw UnimplementedError("No widget for $selectedIndex");
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("EncUrStuff", style: TextStyle(fontSize: 18)),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            SizedBox(
              height: 80,
              child: DrawerHeader(
                child: Text("EncUrStuff"),
              ),
            ),
            ListTile(
              selected: selectedIndex == 0,
              leading: Icon(Icons.lock),
              title: Text("Encrypter"),
              onTap: () {
                setState(() {
                  selectedIndex = 0;
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              selected: selectedIndex == 1,
              leading: Icon(Icons.list),
              title: Text("Encrypted List"),
              onTap: () {
                setState(() {
                  selectedIndex = 1;
                  Navigator.pop(context);
                });
              }
            ),
          ],
        ),
      ),
      body: page,
    );
  }
}

class EncrypterScreen extends StatefulWidget{
  @override
  State<EncrypterScreen> createState() => _EncrypterScreenState();
}

class _EncrypterScreenState extends State<EncrypterScreen>{
  var selectedIndex = 0;
  @override
  Widget build(BuildContext build){
    Widget page;
    switch(selectedIndex){
      case 0:
        page = EncryptionScreen();
        break;
      case 1:
        page = DecryptionScreen();
        break;
      case 2:
        page = ReencryptionScreen();
        break;
      default:
        throw UnimplementedError('No widget for $selectedIndex');
    }
    return LayoutBuilder(
      builder: (context, constraints){
        return Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.lock), label: "Encrypt"),
              BottomNavigationBarItem(icon: Icon(Icons.lock_open), label: "Decrypt"),
              BottomNavigationBarItem(icon: Icon(Icons.autorenew), label: "Reencrypt"),
            ],
            currentIndex: selectedIndex,
            onTap: (value) => {
              setState(() {
                selectedIndex = value;
              })
            },
          ),
          body: page,
        );
      }
    );
  }
}