import 'package:flutter/material.dart';

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
      page = EncryptionWindow();
      break;
    case 1:
      page = Placeholder();
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

class EncryptionWindow extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Enter a text to encrypt"
                  ),
                ),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Enter the encryption password",
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    print("asd");
                  }, 
                  child: Text("Encrypt"),
                )
              ],
            ),
          ),
        ),
    );
    
  }
}