import 'dart:io';

import 'package:image_picker/image_picker.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/styles/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
User? signedInUser;

String? name;
String? phone;
String? image;
String? email;

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({Key? key}) : super(key: key);

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {

  File? profileImage;
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passController = TextEditingController();
  String profilePicLink = "";

  PlatformFile? pickedfile;
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedfile = result.files.first;
    });
  }
   
     
  var picker = ImagePicker();

  Future uploadfile() async {
     await FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
    }).catchError((error) {
       
      });
    }).catchError((error) {
     
    });
  }



  @override
  void initState() {
    super.initState();

    getCurrentUser();
    update();
  }

  Future update() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signedInUser = user;
        await _firestore.collection('users').doc(signedInUser!.uid).update({
          'name': nameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
        });
      }

      print(signedInUser?.uid);
      print('name $name');
      print(email);
      print(phone);
      print(image);
    } catch (e) {
      print(e);
    }
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signedInUser = user;
        final DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(signedInUser?.uid).get();
        setState(() {
          name = userDoc.get('name');
          email = userDoc.get('email');
          phone = userDoc.get('phone');
          image = userDoc.get('image');
        });
      }
      print(signedInUser?.uid);
      print('name $name');
      print(email);
      print(phone);
      print(image);
    } catch (e) {
      print(e);
    }
  }
  void pickUploadProfilePic() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 512,
      maxWidth: 512,
      imageQuality: 90,
    );

    Reference ref = FirebaseStorage.instance
        .ref().child("profilepic.jpg");

    await ref.putFile(File(image!.path));

    ref.getDownloadURL().then((value) async {
      setState(() {
       profilePicLink = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('profile')),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                /* Stack(alignment: AlignmentDirectional.bottomEnd, children: [
                  CircleAvatar(
                    radius: 70.0,
                    backgroundImage: NetworkImage(''),
                  ),
                  TextButton(
                      onPressed: () {},
                      child: Icon(
                        Icons.camera_alt_rounded,
                        size: 30,
                        color: Colors.teal,
                      ))
                ]),
                SizedBox(
                  height: 30.0,
                ),*/
                TextField(
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    fillColor: Colors.teal,
                    focusColor: Colors.teal,
                    hintText: ' User Name',
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.teal,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    fillColor: Colors.teal,
                    focusColor: Colors.teal,
                    hintText: ' Email',
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.teal,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    fillColor: Colors.teal,
                    focusColor: Colors.teal,
                    hintText: 'phone',
                    prefixIcon: Icon(
                      Icons.phone,
                      color: Colors.teal,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Container(
                  height: 50,
                  width: 320,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      9.0,
                    ),
                    color: Colors.teal,
                  ),
                  child: TextButton(
                      onPressed: () {
                        setState(() {
                          getCurrentUser();
                        });

                        print('hello');
                      },
                      child: Text(
                        'UPDATE',
                        style: TextStyle(color: Colors.white),
                      )),
                ),

                /*defaultButton(
                  function: () {
                     FirebaseFirestore.instance
                      .collection('users')
                      .doc(signedInUser.uid)
                      .update({
                    'name': nameController.text,
                    'email': emailController.text,
                    'phone': phoneController.text,
                    //'image':'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQfqGSpRSWM2LH7fa_Vvrr4V0IGlvG_QWXpJofT1-E&s',
    });
                    print(name);
                    print(email);
                    print(phone);
                  },
                  text: 'update',
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
