import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/helperClasses/getUserData.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../cubit/cubit.dart';
import '../helperClasses/getuserImage.dart';

class ChatRoom extends StatelessWidget {
  List<String> docid;
  final String chatRoomId;
  final Map<String, dynamic> userMap;
  late User signedInUser;
  bool? model;

  ChatRoom(
      {required this.chatRoomId, required this.docid, required this.userMap});
  var currentuser = FirebaseAuth.instance.currentUser?.uid;
  final TextEditingController _message = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  File? imageFile;

  Future getImage() async {
    ImagePicker _picker = ImagePicker();

    await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        //uploadImage();
      }
    });
  }

  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendby": _auth.currentUser!.email,
        "message": _message.text,
        "type": "text",
        "time": FieldValue.serverTimestamp(),
      };

      _message.clear();
      await _firestore
          .collection('chatroom')
          .doc(chatRoomId)
          .collection('chats')
          .add(messages);
      print('lllllllllll${_auth.currentUser!.email}');
    } else {
      print("Enter Some Text");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      signedInUser = user;
    }
    model = signedInUser.emailVerified;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppCubit.get(context).isDark
            ? Color.fromARGB(255, 34, 31, 31)
            : Color.fromARGB(255, 204, 200, 200),
        title: StreamBuilder<DocumentSnapshot>(
          stream:
              _firestore.collection("users").doc(userMap['uid']).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Container(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage(userMap['image']),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(userMap['name']),
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
        ),
        actions: [
          IconButton(
              onPressed: () async {
                String number = userMap['phone'];
                launch('tel://$number');
                await FlutterPhoneDirectCaller.callNumber(number);
              },
              icon: Icon(Icons.phone))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            
            SizedBox(
              height: 20,
            ),
            if(model!)
            SingleChildScrollView(
              child: Container(
                height: size.height/1.36 ,
                width: size.width,
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('chatroom')
                      .doc(chatRoomId)
                      .collection('chats')
                      .orderBy("time")
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.data != null) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> map = snapshot.data!.docs[index]
                              .data() as Map<String, dynamic>;

                          return messages(size, map, context);
                        },
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
            ),
            if(model!)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(
                    15.0,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _message,
                        onChanged: (value) {
                          //massegeText = value;
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                          hintText: 'Write your message here...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: onSendMessage,
                        child: const Icon(
                          Icons.send,
                          color: Colors.black,
                        ))
                  ],
                ),
              ),
            ),
          
          ],
        ),
      ),
    );
  }

  Widget messages(Size size, Map<String, dynamic> map, BuildContext context) {
    return map['type'] == "text"
        ? Padding(
            padding: const EdgeInsets.all(1),
            child: Row(
              mainAxisAlignment: map['sendby'] == _auth.currentUser!.email
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        map['sendby'] == _auth.currentUser!.email
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(1),
                        child: Material(
                            borderRadius:
                                map['sendby'] == _auth.currentUser!.email
                                    ? BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        bottomLeft: Radius.circular(30),
                                        bottomRight: Radius.circular(30),
                                      )
                                    : BorderRadius.only(
                                        topRight: Radius.circular(30),
                                        bottomLeft: Radius.circular(30),
                                        bottomRight: Radius.circular(30),
                                      ),
                            color: map['sendby'] == _auth.currentUser!.email
                                ? AppCubit.get(context).isDark
                                    ? Color.fromARGB(255, 34, 31, 31)
                                    : Colors.black
                                : AppCubit.get(context).isDark
                                    ? Colors.white70
                                    : Color.fromARGB(255, 204, 200, 200),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: Text(
                                map['message'],
                                overflow: TextOverflow.clip,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                        color: map['sendby'] ==
                                                _auth.currentUser!.email
                                            ? AppCubit.get(context).isDark
                                                ? Colors.white
                                                : Colors.white
                                            : AppCubit.get(context).isDark
                                                ? Colors.black
                                                : Colors.black,
                                        fontSize: 17),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Container(
            height: size.height / 2.5,
            width: size.width,
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            alignment: map['sendby'] == _auth.currentUser!.displayName
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: InkWell(
              onTap: () {},
              /* => Navigator.of(context).push(
               MaterialPageRoute(
                  builder: (_) => ShowImage(
                    imageUrl: map['message'],
                  ),
                ),
              ),*/
              child: Container(
                height: size.height / 2.5,
                width: size.width / 2,
                decoration: BoxDecoration(border: Border.all()),
                alignment: map['message'] != "" ? null : Alignment.center,
                child: map['message'] != ""
                    ? Image.network(
                        map['message'],
                        fit: BoxFit.cover,
                      )
                    : CircularProgressIndicator(),
              ),
            ),
          );
  }
}
