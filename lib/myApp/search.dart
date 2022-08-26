import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/cubit/cubit.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
    String name = " ";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
        
           appBar: AppBar(
         
          title: Card(
            child: TextField(
              decoration: InputDecoration(
                  prefixIcon: 
                     Icon(Icons.search),
                    
                  
                  hintText: '  Search In Messages...'),
              onChanged: (val) {
                setState(() {
                  name = val;
                });
              },
            ),
          ),
          
        ),
        
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('messages').snapshots(),
          builder: (context, snapshots) {
            return (snapshots.connectionState == ConnectionState.waiting)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: snapshots.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshots.data!.docs[index].data()
                          as Map<String, dynamic>;
                      if(name.isEmpty){
                       return Text(' ');
                      }
                      if (data['text']
                          .toString()
                          .toLowerCase()
                          .startsWith(name.toLowerCase())) {
                        return ListTile(
                          title: Text(
                            data['name'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:  Theme.of(context).textTheme.bodyText1!.copyWith(
                                
                              ),),
                          subtitle: Text(
                            data['text'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppCubit.get(context).isDark?Colors.grey:Colors.black,
                            )
                          ),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(data['image']),
                          ),
                        );
                      }
                      return Container();
                    });
          },
        ));
    
  }
}