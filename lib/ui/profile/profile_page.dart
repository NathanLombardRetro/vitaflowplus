import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:vitaflowplus/ui/dashboard/dashboard_page.dart';

class ImageUploadPage extends StatefulWidget {
  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  File? _imageFile;

  Future<void> _getImageTwo() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _addUserPicture(File imageFile) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      QuerySnapshot existingPictures = await FirebaseFirestore.instance
          .collection('userPictures')
          .where('userId', isEqualTo: userId)
          .get();

      if (existingPictures.docs.isNotEmpty) {
        String existingPictureId = existingPictures.docs.first.id;
        List<int> imageData = await imageFile.readAsBytes();

        await FirebaseFirestore.instance
            .collection('userPictures')
            .doc(existingPictureId)
            .update({
          'date': DateTime.now(),
          'imageData': imageData,
        });
      } else {
        String userPictureId = Uuid().v4();
        List<int> imageData = await imageFile.readAsBytes();

        await FirebaseFirestore.instance
            .collection('userPictures')
            .doc(userPictureId)
            .set({
          'userId': userId,
          'date': DateTime.now(),
          'imageData': imageData,
        });
      }

      print('Picture uploaded successfully');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    } catch (e) {
      print('Failed to upload picture: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = ThemeProvider.themeOf(context).data;
    return Scaffold(
      backgroundColor: currentTheme.primaryColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 70,),
              Row(
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
                      side: BorderSide(
                          color: currentTheme.primaryColor, width: 0),
                    ),
                    child: Icon(Icons.arrow_back),
                  ),
                  Text(
                    'Add Workout',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: currentTheme.primaryColorLight),
                  ),
                  SizedBox(width: 56),
                ],
              ),
              SizedBox(height: 20),
              if (_imageFile != null)
                Image.file(
                  _imageFile!,
                  width: 300,
                  height: 300,
                )
              else
                Text(
                  'No image selected',
                  style: TextStyle(color: currentTheme.primaryColorLight),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _getImageTwo,
                child: Text('Select Image'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 253, 253, 252),
                  ),
                  foregroundColor: MaterialStateProperty.all<Color>(
                    Color(0xFF26547C),
                  ),
                  elevation: MaterialStateProperty.all<double>(0),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Color(0xFF26547C), width: 1),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_imageFile != null) {
                    _addUserPicture(_imageFile!);
                  }
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
                child: Text(
                  'Upload Image',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
