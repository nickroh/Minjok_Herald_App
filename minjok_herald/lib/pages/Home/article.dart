

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class articlepage extends StatefulWidget{
  final DocumentSnapshot post;

  articlepage({this.post});

  @override
  articlepageState createState() => articlepageState();

}

class articlepageState extends State<articlepage>{
  String contents;
  DateTime posttime;
  String time;
  var comments_data = new List();

  void initState(){
    comments_data = widget.post.data['comments'];
    contents = widget.post.data["contents"];
    print(contents);
    contents = contents.replaceAll("\\n", "\n\n");

    posttime = new DateTime.fromMillisecondsSinceEpoch(widget.post.data["timestamp"]);
    time = posttime.toString();
    int tmp;
    for(int i=0;i<time.length;i++){
      if(time[i]==" "){
        tmp = i;
        break;
      }
    }
    if(comments_data == null){
      comments_data = [""];
    }

    time = time.substring(0,tmp+1 );
    print(time);
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: SafeArea(
        child: CustomScrollView(
              slivers: <Widget> [
                SliverAppBar(
                  expandedHeight: 180.0,
                  floating: true,
                  pinned: false,

                  flexibleSpace: FlexibleSpaceBar(
                    background: Hero(
                        tag: widget.post.documentID,
                        child: Image.network(
                          widget.post.data["url"],
                          fit: BoxFit.cover,
                        )
                    ),
                  ),
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                      SingleChildScrollView(
                          child: Container(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.access_time,
                                          color: Colors.grey,
                                        ),
                                        Padding(
                                            padding: EdgeInsets.fromLTRB(0, 0, 6, 0)
                                        ),
                                        Text(
                                          time,
                                          style: TextStyle(
                                              color: Colors.grey
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0)
                                  ),
                                  Text(
                                    widget.post.data["title"],
                                    style: TextStyle(
//                      fontWeight: FontWeight.w600,
                                      fontSize: 25,
                                      fontFamily: 'NanumSquareRound',

                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0)
                                  ),
                                  Text(
                                      contents,
                                    style: TextStyle(
                                      fontFamily: 'NanumSquareRound',
                                      fontSize: 17,
                                      height: 1.5
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(0, 50, 0, 0)
                                  ),
                                  ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.all(8),
                                    itemCount: comments_data.length,
                                    itemBuilder: (BuildContext context, int index){
                                      return ListTile(
                                        title: Text(comments_data[index]),
                                      );
                                    },

                                  )
//                                   ListView.builder(
//                                     padding: const EdgeInsets.all(8),
//                                        itemCount: comments_data.length,
//                                        physics: const NeverScrollableScrollPhysics(),
//                                        itemBuilder: (BuildContext context, index) {
//                                          return ListTile(
//                                          title: Text(comments_data[index]),
//                                        );
//                                      },
//                                   )
  
                                ],
                              )
                          )
                      )
                    ])

                )
              ],


        ),
      )
    );
  }
}
