import 'package:flutter/material.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatefulWidget {
  // Create the initialization Future outside of `build`:
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          //show error;
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'FlutterShare',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                primarySwatch: Colors.deepPurple,
                accentColor: Colors.blueGrey.shade600),
            home: Home(),
          );
        }
        return Container();
      },
    );
  }
}
