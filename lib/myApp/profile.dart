import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/helperClasses/components.dart';
import 'package:flutter_application_2/cubit/cubit.dart';
import 'package:flutter_application_2/myApp/chats.dart';
import 'package:flutter_application_2/myApp/search.dart';
import 'package:flutter_application_2/social_login/social_login_screen.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'conversition.dart';

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
late User signedInUser;

String? name;
String? phone;
String? image;
String? bio;

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var nameController = TextEditingController();
  var bioController = TextEditingController();
  var phoneController = TextEditingController();
  var passController = TextEditingController();
  String namee = " ";

  @override
  void initState() {
    super.initState();
    getCurrentUser();

    nameController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signedInUser = user;
        final DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(signedInUser.uid).get();
        setState(() {
          name = userDoc.get('name');
          phone = userDoc.get('phone');
          image = userDoc.get('image');
          bio = userDoc.get('bio');
        });
      }
    
    } catch (e) {
      print(e);
    }
  }

  Future<String?> openDialog1() => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppCubit.get(context).isDark?HexColor('333739'):Colors.white,
            content: TextField(
              controller: nameController,
              autofocus: true,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                fillColor: Colors.teal,
                focusColor: Colors.teal,
                hintText: ' Enter New User Name',
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.teal,
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
                          .doc(signedInUser.uid);
                      docUser.update({'name': nameController.text});
                    }
                    Navigator.of(context).pop(nameController.text);
                    openDialog();
                  },
                  child: Text('UPDATE'))
            ]),
      );
  Future<String?> openDialog2() => showDialog<String>(
    
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppCubit.get(context).isDark?HexColor('333739'):Colors.white,
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
                  color: Colors.teal,
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
                          .doc(signedInUser.uid);
                      docUser.update({'bio': bioController.text});
                    }
                    Navigator.of(context).pop(nameController.text);
                    openDialog();
                  },
                  child: Text('UPDATE'))
            ]),
      );
  Future<String?> openDialog3() => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppCubit.get(context).isDark?HexColor('333739'):Colors.white,
            content: TextField(
              controller: phoneController,
              autofocus: true,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                
                fillColor: Colors.teal,
                focusColor: Colors.teal,
                hintText: ' Enter New Phone',
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.teal,
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
                          .doc(signedInUser.uid);
                      docUser.update({'phone': phoneController.text});
                    }
                    Navigator.of(context).pop(nameController.text);
                    openDialog();
                  },
                  child: Text('UPDATE'))
            ]),
      );
  Future<String?> openDialog() => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppCubit.get(context).isDark?Color.fromARGB(255, 34, 31, 31):Colors.white,
            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'You must click here to update your data',
                  style: TextStyle(color: AppCubit.get(context).isDark?Colors.white: Colors.black45,),
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: Drawer(
          child: Column(
              children: [
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
                SizedBox(height: 10),
                Container(
                  height: 40,
                  width: 280,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      9.0,
                    ),
                    color: Colors.teal,
                  ),
                  child: TextButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        navigateTo(context, SocialLoginScreen());
                      },
                      child:const Text(
                        'LOG OUT',
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              ]),
        ),
        appBar: AppBar(
          bottomOpacity: .7,
          title: Text(
            'Chat APP',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Color.fromARGB(255, 255, 255, 255), fontSize: 17),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  navigateTo(context, SearchPage());
                },
                icon: Icon(Icons.search)),
          ],
          bottom:const TabBar(tabs: [
            Tab(
              child: Text('Chats'),
            ),
            Tab(
              child: Text('Participation'),
            ),
          ]),
        ),
        // ignore: prefer_const_constructors
        body: TabBarView(

            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Conversition(),
              ChatScreen(),
            ]),
      
      ),
    );
  }
}
