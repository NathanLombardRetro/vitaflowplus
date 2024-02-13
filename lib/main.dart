import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vitaflowplus/firebase_options.dart';
import 'package:vitaflowplus/ui/login/auth_page.dart';
//import 'package:vitaflowplus/ui/login/login_page.dart'; // Importing the LoginPage class from login_page.dart

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(const MainApp());
}


class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: AuthPage(),
    );
  }
}
