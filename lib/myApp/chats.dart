import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/helperClasses/getUserData.dart';
import '../helperClasses/getuserImage.dart';


class ChatScreen extends StatefulWidget {
  
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var currentuser = FirebaseAuth.instance.currentUser?.uid;

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
                          //print(FirebaseFirestore.instance.collection('users').snapshots());
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
                                    element: 'email',
                                    fontsize: 12.0,
                                    fontweight: FontWeight.w400,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ));
                  }));
            }));
  }
}
