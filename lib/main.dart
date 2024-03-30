import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:vitaflowplus/firebase_options.dart';
import 'package:vitaflowplus/ui/login/auth_page.dart';

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
    return ThemeProvider(
      saveThemesOnChange: true,
      loadThemeOnInit: true,
      themes: [
        AppTheme.light().copyWith(
          id: 'custom_light',
          data: ThemeData(
            primaryColor: Color.fromARGB(255, 253, 253, 252),
            primaryColorLight:Colors.deepPurple,
            scaffoldBackgroundColor: Colors.deepPurple 
          ),
        ),
        AppTheme.dark().copyWith(
          id: 'custom_dark',
          data: ThemeData(
            primaryColor: Color.fromARGB(255, 19, 19, 19),
            primaryColorDark:Colors.deepPurple ,
            scaffoldBackgroundColor: Colors.deepPurple
          ),
        ),
      ],
      child: MaterialApp(
        title: 'VitaFlow+',
        home: AuthPage(),
      ),
    );
  }
}
