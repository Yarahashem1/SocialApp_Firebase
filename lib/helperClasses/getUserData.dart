import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class GetUserData extends StatelessWidget {
 
  final String documentId;
  final String element;
  final double? fontsize;
  final FontWeight? fontweight;

  GetUserData({required this.documentId,required this.element,this.fontweight,this.fontsize});

  @override
  Widget build(BuildContext context) {
    CollectionReference resul = FirebaseFirestore.instance.collection('users');
    return FutureBuilder<DocumentSnapshot>(
        future: resul.doc(documentId).get(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data?.data() as Map<String, dynamic>;
            return Text('${data[element]}'
            ,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
               fontSize: fontsize,
             fontWeight: fontweight,
                
              ),
             
             maxLines: 1,
              overflow: TextOverflow.ellipsis,);
          }
          return Text('leadind...',
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
                
              ),

          
                                  );
        }));
  }
}
