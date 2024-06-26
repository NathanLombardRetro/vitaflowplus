import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vitaflowplus/ui/login/forgot-password-page.dart';
import 'package:vitaflowplus/ui/register/register_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromARGB(255, 253, 253, 252),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Image.asset(
              'assets/vitaflow.png',
              width: 300,
              height: 300,
            ),
            Text(
              'Login',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF26547C),
              ),
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextField(
                    controller: _usernameController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF26547C)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF26547C)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF26547C)),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: _passwordController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF26547C)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF26547C)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF26547C)),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isObscure =
                                !_isObscure;
                          });
                        },
                        child: Icon(
                          _isObscure ? Icons.visibility_off : Icons.visibility,
                          color: Color(0xFF26547C),
                        ),
                      ),
                    ),
                    obscureText:
                        _isObscure,
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      _login();
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFF26547C)),
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 253, 253, 252)),
                      textStyle: MaterialStateProperty.all<TextStyle>(
                          TextStyle(fontSize: 14)),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.all(15)),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Color(0xFF26547C)),
                        ),
                      ),
                    ),
                    child: Text('Sign in'),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResetPasswordPage()),
                          );
                        },
                        child: Text(
                          'Forgot password?',
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
    );
  }

  void _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: username, password: password);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      if (e.code != '') {
        wrongEmailMessage();
      }
    }
  }

  void wrongEmailMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Incorrect Email address.'),
          duration: Duration(seconds: 3),
        ),
      );
  }

  void wrongPasswordmessage() {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Incorrect password.'),
          duration: Duration(seconds: 3),
        ),
      );
  }
}
