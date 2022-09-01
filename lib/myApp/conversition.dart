import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/cubit/cubit.dart';
import 'package:flutter_application_2/myApp/profile.dart';
import '../helperClasses/components.dart';
import '../social_login/social_login_screen.dart';


final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
late User signedInUser;

String? name;
String? phone;
String? image;
String? email;
String? bio;

class Conversition extends StatefulWidget {
  const Conversition({Key? key}) : super(key: key);

  @override
  _ConversitionState createState() => _ConversitionState();
}

class _ConversitionState extends State<Conversition> {
  final messagecontroller = TextEditingController();

  String? massegeText;
  bool? model;

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
        });
      }
    } catch (e) {
      print(e);
    }
  }

  openDialog() async {
    final value = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
         backgroundColor: AppCubit.get(context).isDark?Color.fromARGB(255, 34, 31, 31):Colors.white,
          content: Text(
            'Do you want to Verity your Email',
            style: TextStyle(color: AppCubit.get(context).isDark?Colors.white: Colors.black45,),
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  navigateTo(context, ProfileScreen());
                },
                child: Text('No')),
            ElevatedButton(
                onPressed: () {
                  signedInUser.sendEmailVerification().then((value) {
                    showToast(
                      text: 'check your email',
                      state: ToastStates.SUCCESS,
                    );
                  }).catchError((error) {});
                  navigateTo(context, SocialLoginScreen());
                },
                child: Text('Yes')),
          ]),
    );
    if (value != null) {
      return Future.value(value);
    } else
      return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      signedInUser = user;
    }
    model = signedInUser.emailVerified;
    

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!model!)
              Container(
                color: Colors.amber.withOpacity(.6),
                height: 30,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                      const Expanded(
                        child: Text(
                          'please verify your email',
                        ),
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                    
                      IconButton(
                          onPressed: () {
                            openDialog();
                          },
                          icon:const Icon(Icons.close,size: 16,))
                    ],
                  ),
                ),
              ),
           const messsageStreamBuilder(),
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
                        controller: messagecontroller,
                        onChanged: (value) {
                          massegeText = value;
                        },
                        decoration:const InputDecoration(
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
                        onPressed: () {
                          messagecontroller.clear();
                          _firestore.collection('messages').add({
                            'text': massegeText,
                            'email': signedInUser.email,
                            'time': FieldValue.serverTimestamp(),
                            'name': name,
                            'image': image,
                          });
                        },
                        child:const Icon(
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
}

class messsageStreamBuilder extends StatelessWidget {
  const messsageStreamBuilder({Key? key}) : super(key: key);
   
   
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('messages').orderBy('time').snapshots(),
        builder: (context, snapshot) {
          List<messageLine> messageWidgets = [];
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final messages = snapshot.data!.docs.reversed;
          for (var message in messages) {
            final messageText = message.get('text');
            final emailText = message.get('email');
            final nameText = message.get('name');
            final imageText = message.get('image');
            final currentuser = signedInUser.email;

            if (emailText == currentuser) {}

            final messageWidget = messageLine(
              email: emailText,
              text: messageText,
              name: nameText,
              image: imageText,
              isMe: emailText == currentuser,
            );
            messageWidgets.add(messageWidget);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              children: messageWidgets,
            ),
          );
        });
  }
}

class messageLine extends StatelessWidget {
  const messageLine(
      {this.email,
      this.name,
      this.image,
      this.text,
      required this.isMe,
      Key? key})
      : super(key: key);

  final String? email;
  final String? text;
  final String? name;
  final String? image;
  final bool isMe;

  Widget? images() {
    if (!isMe)
      return CircleAvatar(
        radius: 20.0,
        backgroundImage: NetworkImage(image!),
      );
  }



  @override
  Widget build(BuildContext context) {
    return 
    Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        images() ?? Text(' '),
        Expanded(
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(email ?? ' ',
                  style: TextStyle(
                    fontSize: 10.5,
                    color: AppCubit.get(context).isDark
                        ? Colors.grey
                        : Colors.black,
                  )),
              Padding(
                padding: const EdgeInsets.all(1),
                child: Material(
                    borderRadius: isMe
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
                    color: isMe
                        ?
                         AppCubit.get(context).isDark
                            ? Color.fromARGB(255, 34, 31, 31)
                            : Colors.black:AppCubit.get(context).isDark?Colors.white70: Color.fromARGB(255, 204, 200, 200)
                    ,child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Text(
                        '$text ',
                        overflow: TextOverflow.clip,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color:isMe? AppCubit.get(context).isDark?Colors.white: Colors.white:
              AppCubit.get(context).isDark?Colors.black: Colors.black,

                fontSize: 17),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ],
    );
  
  }
}
