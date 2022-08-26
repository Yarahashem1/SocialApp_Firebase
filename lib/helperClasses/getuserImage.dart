import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class GetImage extends StatelessWidget {
  final String documentId;

  GetImage({required this.documentId});

  @override
  Widget build(BuildContext context) {
    CollectionReference resul = FirebaseFirestore.instance.collection('users');
    return FutureBuilder<DocumentSnapshot>(
        future: resul.doc(documentId).get(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data?.data() as Map<String, dynamic>;
          
              return CircleAvatar(
                radius: 30.0,
                backgroundImage: NetworkImage('${data['image']}'),
              );
          
          }
          return CircleAvatar(
            radius: 30.0,
            backgroundImage: NetworkImage(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQfqGSpRSWM2LH7fa_Vvrr4V0IGlvG_QWXpJofT1-E&s'),
          );
        }));
  }
}
