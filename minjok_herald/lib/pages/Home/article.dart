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

        )
        ),
      )
    );
  }
}
