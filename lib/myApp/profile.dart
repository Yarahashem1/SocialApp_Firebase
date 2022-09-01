import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/helperClasses/components.dart';
import 'package:flutter_application_2/cubit/cubit.dart';
import 'package:flutter_application_2/myApp/chats.dart';
import 'package:flutter_application_2/myApp/search.dart';
import 'package:flutter_application_2/myApp/updateProfile.dart';
import 'package:flutter_application_2/social_login/social_login_screen.dart';
import 'package:hexcolor/hexcolor.dart';
import 'conversition.dart';

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
late User signedInUser;

String? name;
String? phone;
String? image;
String? bio;
String? email;

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
            await _firestore.collection('users').doc(signedInUser.uid).get();
        setState(() {
          name = userDoc.get('name');
          phone = userDoc.get('phone');
          image = userDoc.get('image');
          bio = userDoc.get('bio');
          email = userDoc.get('email');
        });
      }
      print('jglggll$name');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: Drawer(
          child: Column(children: [
            MyHeaderDrawer(),
            ListTile(
              title: Text('Profile'),
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
                onPressed: () {
                  navigateTo(context, UpdateProfile());
                },
                icon: AppCubit.get(context).isDark
                    ? const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      )
                    : const Icon(
                        Icons.arrow_forward_ios,
                        color: Color.fromARGB(255, 131, 126, 126),
                      ),
              ),
            ),
            ListTile(
              title: const Text('DarkMode'),
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
                    : const Icon(
                        Icons.toggle_off_rounded,
                        size: 38,
                        color: Color.fromARGB(255, 131, 126, 126),
                      ),
              ),
            ),
            ListTile(
              title: const Text('Log out'),
              leading: IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  navigateTo(context, SocialLoginScreen());
                },
                icon: AppCubit.get(context).isDark
                    ? const Icon(
                        Icons.logout,
                        color: Colors.white,
                      )
                    : const Icon(
                        Icons.logout,
                        color: Color.fromARGB(255, 131, 126, 126),
                      ),
              ),
            ),
          ]),
        ),
        appBar: AppBar(
          bottomOpacity: .7,
          title: Text(
            'Chat APP',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: AppCubit.get(context).isDark
                    ? Colors.white54
                    : Colors.black,
                fontSize: 17),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  navigateTo(context, SearchPage());
                },
                icon: Icon(Icons.search)),
          ],
          bottom: TabBar(tabs: [
            Tab(
              child: Text(
                'Chats',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: AppCubit.get(context).isDark
                        ? Colors.white54
                        : Colors.black,
                    fontSize: 17),
              ),
            ),
            Tab(
              child: Text(
                'Participation',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: AppCubit.get(context).isDark
                        ? Colors.white54
                        : Colors.black,
                    fontSize: 17),
              ),
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

class MyHeaderDrawer extends StatefulWidget {
  @override
  _MyHeaderDrawerState createState() => _MyHeaderDrawerState();
}

class _MyHeaderDrawerState extends State<MyHeaderDrawer> {
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
            await _firestore.collection('users').doc(signedInUser.uid).get();
        setState(() {
          name = userDoc.get('name');
          phone = userDoc.get('phone');
          image = userDoc.get('image');
          bio = userDoc.get('bio');
          email = userDoc.get('email');
        });
      }
    } catch (e) {
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppCubit.get(context).isDark
          ? Color.fromARGB(255, 34, 31, 31)
          : Color.fromARGB(255, 204, 200, 200),
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              margin: EdgeInsets.only(bottom: 10),
              height: 70,
              child: CircleAvatar(
                  radius: 95.0, backgroundImage: NetworkImage(image!))),
          Text(
            name!,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color:
                    AppCubit.get(context).isDark ? Colors.white : Colors.black,
                fontSize: 20),
          ),
          SizedBox(
            height: 3,
          ),
          Text(
            bio!,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: AppCubit.get(context).isDark
                    ? Colors.white54
                    : Colors.black,
                fontSize: 13),
          ),
          SizedBox(
            height: 3,
          ),
          Text(
            email!,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: AppCubit.get(context).isDark
                    ? Colors.white54
                    : Colors.black45,
                fontSize: 14),
          ),
        ],
      ),
    );
  }
}
