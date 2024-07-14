import 'package:enc_flutter/services/user/user.dart';
import 'package:enc_flutter/services/user/user_service.dart';
import 'package:enc_flutter/widgets/auth/login_screen.dart';
import 'package:enc_flutter/widgets/auth/register_screen.dart';
import 'package:enc_flutter/widgets/encrypted_texts/encrypted_texts_screen.dart';
import 'widgets/reencryption/reencryption_screen.dart';
import 'package:flutter/material.dart';
import './widgets/encryption/encryption_screen.dart';
import './widgets/decryption/decryption_screen.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Enc-Flutter",
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: Colors.indigoAccent,
        ),
        primaryColor: Colors.indigoAccent,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.indigoAccent),
            foregroundColor: MaterialStateProperty.all(Colors.white),
          )
        )
      ),
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ).copyWith(
        colorScheme: ColorScheme.dark(
          primary: Colors.indigoAccent
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.indigoAccent),
            foregroundColor: MaterialStateProperty.all(Colors.white),
          )
        )
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("EncUrStuff", style: TextStyle(fontSize: 18)),
          backgroundColor: Colors.indigoAccent,
          foregroundColor: Colors.white,
        ),
        body: FutureBuilder(
        future: UserService.getUsers(),
        builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
          if(!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          else if(snapshot.hasData && snapshot.data!.isNotEmpty) {
            return LoginScreen();
          }
          else {
            return RegisterScreen();
          }
        },
      ),),
      routes: {
        '/home': (context) => HomePage(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
      },
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
        page = EncryptedTextsScreen();
        break;
      default:
        throw UnimplementedError("No widget for $selectedIndex");
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("EncUrStuff", style: TextStyle(fontSize: 18)),
          backgroundColor: Colors.indigoAccent,
          foregroundColor: Colors.white,
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
      body: PopScope(
        child: page,
        canPop: false,
      ),
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