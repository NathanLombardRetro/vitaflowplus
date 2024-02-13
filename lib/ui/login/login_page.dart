import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vitaflowplus/ui/register/register_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      color: Color(0xFFF1F1EF),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Add logo here
            Image.asset(
              'assets/vitaflow.png', // Replace 'logo.png' with your actual logo asset path
              width: 300,
              height: 300,
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.0),
              child: Text(
                'Login',
                style: TextStyle(
                  fontSize: 30, // Increased font size
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF26547C),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      _login();
                    },
                    child: Text('Sign in'),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Implement forgot password functionality
                        },
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          // Implement registration functionality
                        },
                        child: Text(
                          'Reset password',
                          style: TextStyle(color: Color(0xFF26547C)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Don\'t have an account? ',
                    style: TextStyle(fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    child: Text(
                      'Sign up',
                      style: TextStyle(fontSize: 16, color: Color(0xFF26547C)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
  void _login() async{
    String username = _usernameController.text;
    String password = _passwordController.text;

    showDialog(context: context, builder: (context){
      return Center(
        child:CircularProgressIndicator(),
      );
    },
    );
    
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: username,password: password);
      Navigator.pop(context);  
    }on FirebaseAuthException catch (e){
      
      Navigator.pop(context);
      
      if(e.code != '')
      {
        //wrongEmailMessage();
        wrongEmailMessage();
      }
    }
  }

  void wrongEmailMessage(){
    showDialog
    (context: context,
     builder: (context){
        return const AlertDialog(
          title: Text("Incorrect Email address"),
        );
     },
    );
  }

  void wrongPasswordmessage()
  {
    showDialog
    (context: context,
     builder: (context){
        return const AlertDialog(
          title: Text("Incorrect password"),
        );
     },
    );
  }
}