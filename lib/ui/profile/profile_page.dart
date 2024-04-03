import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:vitaflowplus/ui/dashboard/dashboard_page.dart';

class ImageUploadPage extends StatefulWidget {
  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  Uint8List? _imageBytes;

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

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imageBytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = Uint8List.fromList(imageBytes);
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageBytes != null
                ? Image.memory(
                    _imageBytes!,
                    width: 300,
                    height: 300,
                  )
                : Text('No image selected'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getImageTwo,
              child: Text('Select Image'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_imageFile != null) {
                  _addUserPicture(
                      _imageFile!);
                }
              },
              child: Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}
