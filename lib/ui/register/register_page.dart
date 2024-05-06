import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:theme_provider/theme_provider.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumController = TextEditingController();

  Future<void> _register() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': _emailController.text,
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'phone': _phoneNumController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User registered successfully.'),
          duration: Duration(seconds: 3),
        ),
      );
      FirebaseAuth.instance.signOut();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to register.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = ThemeProvider.themeOf(context).data;
    return Scaffold(
      backgroundColor: currentTheme.primaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 60),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  backgroundColor: currentTheme.primaryColor,
                  foregroundColor: Color(0xFF26547C),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side:
                        BorderSide(color: currentTheme.primaryColor, width: 0),
                  ),
                  child: Icon(Icons.arrow_back),
                ),
                Text(
                  "Register",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: currentTheme.primaryColorLight),
                ),
                SizedBox(
                    width:
                        56),
              ],
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Fill out the form below to register:",
              style: TextStyle(
                  fontSize: 18, color: currentTheme.primaryColorLight),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _firstNameController,
                      style: TextStyle(color: currentTheme.primaryColorLight),
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        labelStyle:
                            TextStyle(color: currentTheme.primaryColorLight),
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
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _lastNameController,
                      style: TextStyle(color: currentTheme.primaryColorLight),
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        labelStyle:
                            TextStyle(color: currentTheme.primaryColorLight),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF26547C)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF26547C)),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      style: TextStyle(color: currentTheme.primaryColorLight),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle:
                            TextStyle(color: currentTheme.primaryColorLight),
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
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneNumController,
                      style: TextStyle(color: currentTheme.primaryColorLight),
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        labelStyle:
                            TextStyle(color: currentTheme.primaryColorLight),
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
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      style: TextStyle(color: currentTheme.primaryColorLight),
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle:
                            TextStyle(color: currentTheme.primaryColorLight),
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
                    SizedBox(height: 32),
                    SizedBox(
                      child: ElevatedButton(
                        onPressed: _register,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xFF26547C)),
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(255, 253, 253, 252)),
                          textStyle: MaterialStateProperty.all<TextStyle>(
                              TextStyle(fontSize: 14)),
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                                  EdgeInsets.all(15)),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: Color(0xFF26547C)),
                            ),
                          ),
                        ),
                        child: Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
