

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

  DateTime posttime;
  String time;
  void initState(){
    posttime = new DateTime.fromMillisecondsSinceEpoch(widget.post.data["timestamp"]);
    time = posttime.toString();
    int tmp;
    for(int i=0;i<time.length;i++){
      if(time[i]==" "){
        tmp = i;
        break;
      }
    }
    time = time.substring(0,tmp+1 );
    print(time);
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: SafeArea(
        child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
              return <Widget> [
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
                )
              ];
            },
            body: Container(
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
                  )

                ],
              )
        )
        ),
      )
    );
  }
}
