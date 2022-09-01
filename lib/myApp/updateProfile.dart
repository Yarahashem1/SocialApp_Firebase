import 'dart:io';

import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/styles/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../cubit/cubit.dart';
import '../helperClasses/components.dart';
import '../social_login/social_login_screen.dart';

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
User? signedInUser;

String? name;
String? phone;
String? image;
String? email;
String? bio;

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({Key? key}) : super(key: key);

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  File? profileImage;
  var nameController = TextEditingController();
  var bioController = TextEditingController();
  var phoneController = TextEditingController();
  var passController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
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
          bio = userDoc.get('bio');
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

  Future<String?> openDialog1() => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
            backgroundColor: AppCubit.get(context).isDark
                ? HexColor('333739')
                : Color.fromARGB(255, 204, 200, 200),
            content: TextField(
              controller: nameController,
              autofocus: true,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                fillColor: Color.fromARGB(255, 204, 200, 200),
                focusColor: Color.fromARGB(255, 204, 200, 200),
                hintText: ' Enter New User Name',
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.black,
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    final user = _auth.currentUser;
                    if (user != null) {
                      signedInUser = user;
                      final docUser = FirebaseFirestore.instance
                          .collection('users')
                          .doc(signedInUser!.uid);
                      docUser.update({'name': nameController.text});
                    }
                    setState(() {
                      name = nameController.text;
                      nameController.clear();
                    });
                    Navigator.of(context).pop(nameController.text);
                  },
                  child: Text(
                    'UPDATE',
                    style: TextStyle(color: Colors.black),
                  ))
            ]),
      );
  Future<String?> openDialog2() => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
            backgroundColor: AppCubit.get(context).isDark
                ? HexColor('333739')
                : Color.fromARGB(255, 204, 200, 200),
            content: TextField(
              controller: bioController,
              autofocus: true,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                fillColor: Colors.teal,
                focusColor: Colors.teal,
                hintText: ' Enter New Bio',
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.black,
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    final user = _auth.currentUser;
                    if (user != null) {
                      signedInUser = user;
                      final docUser = FirebaseFirestore.instance
                          .collection('users')
                          .doc(signedInUser!.uid);
                      docUser.update({'bio': bioController.text});
                    }
                    setState(() {
                      bio = bioController.text;
                      bioController.clear();
                    });
                    Navigator.of(context).pop(nameController.text);
                  },
                  child: Text(
                    'UPDATE',
                    style: TextStyle(color: Colors.black),
                  ))
            ]),
      );
  Future<String?> openDialog3() => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
            backgroundColor: AppCubit.get(context).isDark
                ? HexColor('333739')
                : Color.fromARGB(255, 204, 200, 200),
            content: TextField(
              controller: phoneController,
              autofocus: true,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                fillColor: Colors.black,
                focusColor: Colors.black,
                hintText: ' Enter New Phone',
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.black,
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  final user = _auth.currentUser;
                  if (user != null) {
                    signedInUser = user;
                    final docUser = FirebaseFirestore.instance
                        .collection('users')
                        .doc(signedInUser!.uid);
                    docUser.update({'phone': phoneController.text});
                  }
                  setState(() {
                    phone = phoneController.text;
                    phoneController.clear();
                  });
                  Navigator.of(context).pop(nameController.text);
                },
                child: Text('UPDATE',
                style: TextStyle(color: Colors.black),)
              )
            ]),
      );
  Future<String?> openDialog() => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
            backgroundColor: AppCubit.get(context).isDark
                ? Color.fromARGB(255, 34, 31, 31)
                : Colors.white,
            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'You must click here to update your data',
                  style: TextStyle(
                    color: AppCubit.get(context).isDark
                        ? Colors.white
                        : Colors.black45,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    navigateTo(context, SocialLoginScreen());
                  },
                  child: Text(
                    'LOG OUT',
                    style: TextStyle(color: Colors.teal),
                  )),
            ]),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('profile')),
          backgroundColor:AppCubit.get(context).isDark?Color.fromARGB(255, 34, 31, 31): Color.fromARGB(255, 204, 200, 200),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Stack(alignment: AlignmentDirectional.bottomEnd, children: [
                CircleAvatar(
                    radius: 70.0,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: CircleAvatar(
                        radius: 70.0, backgroundImage: NetworkImage(image!))),
                IconButton(
                    icon: const CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 204, 200, 200),
                      radius: 28.0,
                      child: Icon(
                        Icons.camera_enhance,
                        size: 20.0,
                      ),
                    ),
                    onPressed: () async {
                      File? profileImage;
                      final pickedFile = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                      );

                      if (pickedFile != null) {
                        profileImage = File(pickedFile.path);
                        print(pickedFile.path);
                      } else {
                        print('No image selected.');
                      }
                      firebase_storage.FirebaseStorage.instance
                          .ref()
                          .child(
                              'users/${Uri.file(profileImage!.path).pathSegments.last}')
                          .putFile(profileImage)
                          .then((value) {
                        value.ref.getDownloadURL().then((value) {
                          setState(() {
                            image = value;
                          });
                          final user = _auth.currentUser;
                          if (user != null) {
                            signedInUser = user;
                            final docUser = FirebaseFirestore.instance
                                .collection('users')
                                .doc(signedInUser!.uid);
                            docUser.update({'image': value}).then((value) {});
                            
                          }
                        });
                      });
                      // openDialog();
                    }),
              ]),
              ListTile(
                title: Text('User Name',
                 style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color:AppCubit.get(context).isDark?Colors.white: Colors.black,
                fontSize: 17),
                ),
                subtitle: Text(
                  name!,
                   style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color:AppCubit.get(context).isDark?Colors.white70: Colors.black,
                fontSize: 12),
                ),
                leading: AppCubit.get(context).isDark
                    ? const Icon(
                        Icons.perm_identity,
                        color: Colors.white,
                      )
                    : const Icon(
                        Icons.perm_identity,
                        color: Color.fromARGB(255, 131, 126, 126),
                      ),
                trailing: IconButton(
                  onPressed: () async {
                    final name = await openDialog1();
                    if (name == null || name.isEmpty) return;
                  },
                  icon: AppCubit.get(context).isDark
                      ? const Icon(
                          Icons.edit,
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.edit,
                          color: Color.fromARGB(255, 131, 126, 126),
                        ),
                ),
              ),
              ListTile(
                title: Text('Bio',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color:AppCubit.get(context).isDark?Colors.white: Colors.black,
                fontSize: 17),),
                subtitle: Text(
                  bio!,
                   style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color:AppCubit.get(context).isDark?Colors.white54: Colors.black,
                fontSize: 12),
                ),
                leading: AppCubit.get(context).isDark
                    ? const Icon(
                        Icons.mood,
                        color: Colors.white,
                      )
                    : const Icon(
                        Icons.mood,
                        color: Color.fromARGB(255, 131, 126, 126),
                      ),
                trailing: IconButton(
                  onPressed: () async {
                    final email = await openDialog2();
                    if (bio == null) return;
                  },
                  icon: AppCubit.get(context).isDark
                      ? const Icon(
                          Icons.edit,
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.edit,
                          color: Color.fromARGB(255, 131, 126, 126),
                        ),
                ),
              ),
              ListTile(
                title: Text('Phone',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color:AppCubit.get(context).isDark?Colors.white: Colors.black,
                fontSize: 17),),
                subtitle: Text(
                  phone!,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color:AppCubit.get(context).isDark?Colors.white54: Colors.black,
                fontSize: 12),
                ),
                leading: AppCubit.get(context).isDark
                    ? const Icon(
                        Icons.phone,
                        color: Colors.white,
                      )
                    : const Icon(
                        Icons.phone,
                        color: Color.fromARGB(255, 131, 126, 126),
                      ),
                trailing: IconButton(
                  onPressed: () async {
                    final phone = await openDialog3();
                    if (phone == null || phone.isEmpty) return;
                  },
                  icon: AppCubit.get(context).isDark
                      ? const Icon(
                          Icons.edit,
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.edit,
                          color: Color.fromARGB(255, 131, 126, 126),
                        ),
                ),
              ),
            ],
          ),
        )

        /* Padding(
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
   */

        );
  }
}
/*

 Stack(alignment: AlignmentDirectional.bottomEnd, children: [
                  CircleAvatar(
                      radius: 95.0,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      child: CircleAvatar(
                          radius: 95.0, backgroundImage: NetworkImage(image!))),
                  IconButton(
                      icon: const CircleAvatar(
                        radius: 24.0,
                        child: Icon(
                          Icons.camera_enhance,
                          size: 20.0,
                        ),
                      ),
                      onPressed: () async {
                        File? profileImage;
                        final pickedFile = await ImagePicker().pickImage(
                          source: ImageSource.gallery,
                        );

                        if (pickedFile != null) {
                          profileImage = File(pickedFile.path);
                          print(pickedFile.path);
                        } else {
                          print('No image selected.');
                        }
                        firebase_storage.FirebaseStorage.instance
                            .ref()
                            .child(
                                'users/${Uri.file(profileImage!.path).pathSegments.last}')
                            .putFile(profileImage)
                            .then((value) {
                          value.ref.getDownloadURL().then((value) {
                          
                            print(value);
                            final user = _auth.currentUser;
                            if (user != null) {
                              signedInUser = user;
                              final docUser = FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(signedInUser.uid);
                              docUser.update({'image': value}).then((value) {
                           
                              });
                              openDialog();
                            }
                          });
                        });
                        // openDialog();
                      }),
                ]),
                ListTile(
                  title: Text('User Name'),
                  subtitle: Text(
                    name!,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontSize: 12,
                        ),
                  ),
                  leading: AppCubit.get(context).isDark
                      ? const Icon(
                          Icons.perm_identity,
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.perm_identity,
                          color: Color.fromARGB(255, 131, 126, 126),
                        ),
                  trailing: IconButton(
                    onPressed: () async {
                      final name = await openDialog1();
                      if (name == null || name.isEmpty) return;
                    },
                    icon: AppCubit.get(context).isDark
                        ?const Icon(
                            Icons.edit,
                            color: Colors.white,
                          )
                        :const Icon(
                            Icons.edit,
                            color: Color.fromARGB(255, 131, 126, 126),
                          ),
                  ),
                ),
                ListTile(
                  title: Text('Bio'),
                  subtitle: Text(
                    bio!,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontSize: 12,
                        ),
                  ),
                  leading: AppCubit.get(context).isDark
                      ?const Icon(
                          Icons.mood,
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.mood,
                          color: Color.fromARGB(255, 131, 126, 126),
                        ),
                  trailing: IconButton(
                    onPressed: () async {
                      final email = await openDialog2();
                      if (bio == null) return;
                    },
                    icon: AppCubit.get(context).isDark
                        ?const Icon(
                            Icons.edit,
                            color: Colors.white,
                          )
                        : const Icon(
                            Icons.edit,
                            color: Color.fromARGB(255, 131, 126, 126),
                          ),
                  ),
                ),
                ListTile(
                  title: Text('Phone'),
                  subtitle: Text(
                    phone!,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontSize: 12,
                        ),
                  ),
                  leading: AppCubit.get(context).isDark
                      ?const Icon(
                          Icons.phone,
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.phone,
                          color: Color.fromARGB(255, 131, 126, 126),
                        ),
                  trailing: IconButton(
                    onPressed: () async {
                      final phone = await openDialog3();
                      if (phone == null || phone.isEmpty) return;
                    },
                    icon: AppCubit.get(context).isDark
                        ?const Icon(
                            Icons.edit,
                            color: Colors.white,
                          )
                        : const Icon(
                            Icons.edit,
                            color: Color.fromARGB(255, 131, 126, 126),
                          ),
                  ),
                ),
                ListTile(
                  title: const Text('DarkMode'),
                  subtitle: const Text(' '),
                  leading: AppCubit.get(context).isDark
                      ? const Icon(
                          Icons.brightness_3_rounded,
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.brightness_3_outlined,
                          color: Color.fromARGB(255, 131, 126, 126),
                        ),
                  trailing: IconButton(
                    onPressed: () {
                      AppCubit.get(context).changeAppMode();
                    },
                    icon: AppCubit.get(context).isDark
                        ? const Icon(
                            Icons.toggle_on_rounded,
                            size: 38,
                            color: Colors.white,
                          )
                        :const Icon(
                            Icons.toggle_off_rounded,
                            size: 38,
                            color: Color.fromARGB(255, 131, 126, 126),
                          ),
                  ),
                ),
                */