import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/helperClasses/getUserData.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';
import '../helperClasses/getuserImage.dart';
import 'chatdetailes.dart';

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
late User signedInUser;

String? phone;

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Map<String, dynamic>? userMap;
  var currentuser = FirebaseAuth.instance.currentUser?.uid;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  void dispose() {
    super.dispose();
    print('xxxxxxxxxxxxxxxxx');
  }

  List<String> docphone = [];
  List<String> docid = [];

  Future getUsers() async {
    docid = [];
    await FirebaseFirestore.instance
        .collection('users')
        .where('uId', isNotEqualTo: currentuser)
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              docid.add(document.reference.id);
            }));
    if (docid.isEmpty) {
      CircularProgressIndicator;
    }
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signedInUser = user;
        final DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(signedInUser.uid).get();
        setState(() {
          phone = userDoc.get('phone');
        });
      }
    } catch (e) {
      print(e);
    }
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: getUsers(),
            builder: (context, snapshot) {
              return ListView.separated(
                  separatorBuilder: ((context, index) => SizedBox(height: 0)),
                  itemCount: docid.length,
                  itemBuilder: ((context, index) {
                    return InkWell(
                        onTap: () {
                          String idd = docid[index];

                          String roomId =
                              chatRoomId(_auth.currentUser!.uid, idd);
                          FirebaseFirestore.instance
                              .collection('users')
                              .where('uId', isNotEqualTo: currentuser)
                              .get()
                              .then((value) {
                            userMap = value.docs[index].data();

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ChatRoom(
                                    chatRoomId: roomId,
                                    docid: docid,
                                    userMap: userMap!),
                              ),
                            );

                            print(value);
                            print(userMap);
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              GetImage(
                                documentId: docid[index],
                              ),
                              SizedBox(
                                width: 15.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GetUserData(
                                    documentId: docid[index],
                                    element: 'name',
                                    fontsize: 16.0,
                                    fontweight: FontWeight.bold,
                                  ),
                                  SizedBox(
                                    height: 1,
                                  ),
                                  GetUserData(
                                    documentId: docid[index],
                                    element: 'phone',
                                    fontsize: 12.0,
                                    fontweight: FontWeight.w400,
                                  ),
                                ],
                              ),
                              // getphone('phone', docid[index]),
                            ],
                          ),
                        ));
                  }));
            }));
  }
}
