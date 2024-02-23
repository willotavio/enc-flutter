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
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context){

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
          appBar: AppBar(
            title: Text("EncUrStuff", style: TextStyle(fontSize: 18)),
          ),
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