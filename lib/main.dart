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
        useMaterial3: true,
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
      page = Placeholder();
      break;
    default:
      throw UnimplementedError('No widget for $selectedIndex');
   }

    return LayoutBuilder(
      builder: (context, constraints){
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.lock),
                      label: Text("Encrypt"),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.lock_open),
                      label: Text("Decryption"),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.autorenew),
                      label: Text("Reencryption")
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  }, 
                ),
              ),
              Expanded(
                child: page,
              ),
            ],
          ),
        );
      }
    );
  }
}