import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DocumentView extends StatelessWidget {

  final DocumentSnapshot documentData;
  DocumentView(this.documentData);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(documentData.data["title"]),
          subtitle: Row(
            children: <Widget>[
              Text(documentData.data["price"].toString()),
              SizedBox(width: 10, height: 10),
              Text(documentData.data["purchase?"].toString()),
            ],
          ),
        ),
      ),
    );
  }
}